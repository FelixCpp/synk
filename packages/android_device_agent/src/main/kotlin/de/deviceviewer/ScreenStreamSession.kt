package de.deviceviewer

import android.hardware.display.VirtualDisplay
import android.media.MediaCodec
import android.media.MediaCodecInfo
import android.media.MediaFormat
import android.view.Display
import android.view.Surface
import java.io.IOException
import java.net.ServerSocket
import java.net.Socket
import kotlin.concurrent.thread

/**
 * Owns the lifecycle of one screen-mirroring session: a dedicated TCP socket
 * that a client connects to, a MediaCodec AVC encoder whose input surface is
 * fed by a virtual display mirroring the real screen, and the background
 * thread pumping encoded Annex-B output onto the socket.
 *
 * Only one session is meaningful per agent process (one physical device, one
 * connected client), so this class is not designed to run multiple
 * overlapping streams.
 */
class ScreenStreamSession {
    private var serverSocket: ServerSocket? = null
    private var clientSocket: Socket? = null
    private var acceptThread: Thread? = null
    private var pumpThread: Thread? = null
    private var codec: MediaCodec? = null
    private var virtualDisplay: VirtualDisplay? = null

    @Volatile
    private var running = false

    /** Starts listening for a video connection and returns the port to connect to. */
    @Synchronized
    fun start(): Int {
        stop()

        val server = ServerSocket(0)
        serverSocket = server
        running = true

        acceptThread = thread(name = "screen-stream-accept") {
            try {
                val client = server.accept()
                beginEncoding(client)
            } catch (e: IOException) {
                // Expected when stop() closes the server socket while waiting.
                log("accept loop ended: $e")
            }
        }

        return server.localPort
    }

    @Synchronized
    fun stop() {
        running = false

        try {
            serverSocket?.close()
        } catch (e: IOException) {
            // Ignore - we're tearing down anyway.
        }
        try {
            clientSocket?.close()
        } catch (e: IOException) {
            // Ignore - we're tearing down anyway.
        }

        pumpThread?.join(1000)
        cleanupEncoder()

        serverSocket = null
        clientSocket = null
        acceptThread = null
        pumpThread = null
    }

    private fun beginEncoding(client: Socket) {
        clientSocket = client

        val (width, height) = getRealDisplaySize(Display.DEFAULT_DISPLAY)

        log("Starting encoder for ${width}x$height")

        val format = MediaFormat.createVideoFormat("video/avc", width, height).apply {
            setInteger(MediaFormat.KEY_COLOR_FORMAT, MediaCodecInfo.CodecCapabilities.COLOR_FormatSurface)
            setInteger(MediaFormat.KEY_BIT_RATE, 8_000_000)
            setInteger(MediaFormat.KEY_FRAME_RATE, 60)
            setInteger(MediaFormat.KEY_I_FRAME_INTERVAL, 1)
            // A surface-input encoder only gets a new frame when SurfaceFlinger
            // actually recomposites the mirrored display, which it skips
            // entirely when nothing on screen changes. Without this, an idle
            // device shows a black/frozen mirror until something is touched.
            setLong(MediaFormat.KEY_REPEAT_PREVIOUS_FRAME_AFTER, 100_000L)
        }

        val codec = MediaCodec.createEncoderByType("video/avc")
        codec.configure(format, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE)
        val inputSurface = codec.createInputSurface()
        codec.start()
        this.codec = codec

        val virtualDisplay = createMirrorVirtualDisplay(
            name = "device-viewer-mirror",
            width = width,
            height = height,
            displayIdToMirror = Display.DEFAULT_DISPLAY,
            surface = inputSurface
        )
        this.virtualDisplay = virtualDisplay
        requestDisplayPower(virtualDisplay.display.displayId, on = true)

        pumpThread = thread(name = "screen-stream-pump") {
            pumpEncodedFrames(codec, client)
        }
    }

    private fun pumpEncodedFrames(codec: MediaCodec, client: Socket) {
        val bufferInfo = MediaCodec.BufferInfo()
        val out = client.getOutputStream()

        try {
            while (running) {
                val index = codec.dequeueOutputBuffer(bufferInfo, 100_000)
                if (index >= 0) {
                    val buffer = codec.getOutputBuffer(index)
                    if (buffer != null && bufferInfo.size > 0) {
                        val chunk = ByteArray(bufferInfo.size)
                        buffer.get(chunk)
                        out.write(chunk)
                        out.flush()
                    }
                    codec.releaseOutputBuffer(index, false)
                }
            }
        } catch (e: IOException) {
            // Expected when the client disconnects or stop() closes the socket.
            log("pump loop ended: $e")
        } finally {
            cleanupEncoder()
        }
    }

    @Synchronized
    private fun cleanupEncoder() {
        virtualDisplay?.release()
        virtualDisplay = null

        codec?.let {
            try {
                it.stop()
            } catch (e: Exception) {
                // Ignore - may already be in a stopped/error state.
            }
            try {
                it.release()
            } catch (e: Exception) {
                // Ignore - may already be released.
            }
        }
        codec = null
    }

    private fun createMirrorVirtualDisplay(
        name: String,
        width: Int,
        height: Int,
        displayIdToMirror: Int,
        surface: Surface
    ): VirtualDisplay {
        // android.hardware.display.DisplayManager.createVirtualDisplay(String, int, int, int, Surface)
        // is @hide (mirrors an existing display's content), so it must be
        // invoked via reflection. Confirmed against scrcpy's
        // wrappers/DisplayManager.java and verified working on-device.
        val method = android.hardware.display.DisplayManager::class.java.getMethod(
            "createVirtualDisplay",
            String::class.java,
            Int::class.javaPrimitiveType,
            Int::class.javaPrimitiveType,
            Int::class.javaPrimitiveType,
            Surface::class.java
        )
        return method.invoke(null, name, width, height, displayIdToMirror, surface) as VirtualDisplay
    }

    private fun getRealDisplaySize(displayId: Int): Pair<Int, Int> {
        // Resources.getSystem().displayMetrics reports 0x0 in this headless
        // app_process context (no attached window), so the real physical
        // size has to come from DisplayManagerGlobal's hidden DisplayInfo,
        // same as scrcpy's wrappers/DisplayManager.getDisplayInfo - verified
        // on-device.
        val dmgClass = Class.forName("android.hardware.display.DisplayManagerGlobal")
        val dmg = dmgClass.getDeclaredMethod("getInstance").invoke(null)
        val displayInfo = dmgClass.getMethod("getDisplayInfo", Int::class.javaPrimitiveType)
            .invoke(dmg, displayId)
            ?: error("DisplayManagerGlobal.getDisplayInfo($displayId) returned null")

        val infoClass = displayInfo.javaClass
        val width = infoClass.getDeclaredField("logicalWidth").getInt(displayInfo)
        val height = infoClass.getDeclaredField("logicalHeight").getInt(displayInfo)
        return width to height
    }

    private fun requestDisplayPower(displayId: Int, on: Boolean): Boolean {
        return try {
            // android.hardware.display.DisplayManagerGlobal.requestDisplayPower(int, boolean)
            // is @hide. Without this, a mirroring VirtualDisplay only ever
            // receives a single initial composite from SurfaceFlinger and is
            // never refreshed again - verified on-device.
            val dmgClass = Class.forName("android.hardware.display.DisplayManagerGlobal")
            val dmg = dmgClass.getDeclaredMethod("getInstance").invoke(null)
            val method = dmgClass.getMethod(
                "requestDisplayPower",
                Int::class.javaPrimitiveType,
                Boolean::class.javaPrimitiveType
            )
            method.invoke(dmg, displayId, on) as Boolean
        } catch (e: ReflectiveOperationException) {
            log("requestDisplayPower failed: $e")
            false
        }
    }

    private fun log(message: String) {
        System.err.println("ScreenStreamSession: $message")
    }
}
