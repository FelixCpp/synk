package de.deviceviewer

import android.hardware.display.VirtualDisplay
import android.media.MediaCodec
import android.media.MediaCodecInfo
import android.media.MediaFormat
import android.view.Display
import android.view.Surface
import java.lang.reflect.Method

/**
 * Standalone spike: mirrors the physical display into a MediaCodec AVC
 * encoder's input surface (no `screenrecord` subprocess) and writes the raw
 * Annex-B elementary stream to stdout. Verifies the DisplayManager hidden
 * mirror API works on-device before wiring it into the real agent.
 *
 * Usage (from host): adb shell CLASSPATH=... app_process /system/bin \
 *   de.deviceviewer.ScreenCaptureSpikeKt <width> <height> <seconds> > out.h264
 */
fun main(args: Array<String>) {
    val width = args.getOrNull(0)?.toIntOrNull() ?: 1080
    val height = args.getOrNull(1)?.toIntOrNull() ?: 2400
    val seconds = args.getOrNull(2)?.toIntOrNull() ?: 8

    log("Starting capture spike: ${width}x$height for ${seconds}s")

    val format = MediaFormat.createVideoFormat("video/avc", width, height).apply {
        setInteger(MediaFormat.KEY_COLOR_FORMAT, MediaCodecInfo.CodecCapabilities.COLOR_FormatSurface)
        setInteger(MediaFormat.KEY_BIT_RATE, 8_000_000)
        setInteger(MediaFormat.KEY_FRAME_RATE, 60)
        setInteger(MediaFormat.KEY_I_FRAME_INTERVAL, 1)
    }

    val codec = MediaCodec.createEncoderByType("video/avc")
    codec.configure(format, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE)
    val inputSurface = codec.createInputSurface()
    codec.start()
    log("MediaCodec encoder started, input surface created")

    val virtualDisplay = createMirrorVirtualDisplay(
        name = "device-viewer-spike",
        width = width,
        height = height,
        displayIdToMirror = Display.DEFAULT_DISPLAY,
        surface = inputSurface
    )
    log("Virtual display created: $virtualDisplay")

    val virtualDisplayId = virtualDisplay.display.displayId
    val powerRequestOk = requestDisplayPower(virtualDisplayId, on = true)
    log("requestDisplayPower($virtualDisplayId, true) -> $powerRequestOk")

    val bufferInfo = MediaCodec.BufferInfo()
    val deadline = System.currentTimeMillis() + seconds * 1000L
    var totalBytes = 0L
    var frameCount = 0

    val stdout = System.out
    while (System.currentTimeMillis() < deadline) {
        val outIndex = codec.dequeueOutputBuffer(bufferInfo, 10_000)
        if (outIndex >= 0) {
            val outBuffer = codec.getOutputBuffer(outIndex)
            if (outBuffer != null && bufferInfo.size > 0) {
                val chunk = ByteArray(bufferInfo.size)
                outBuffer.get(chunk)
                stdout.write(chunk)
                totalBytes += chunk.size
                frameCount++
            }
            codec.releaseOutputBuffer(outIndex, false)
        } else {
            log("dequeueOutputBuffer returned $outIndex")
        }
    }
    stdout.flush()

    log("Done: wrote $frameCount buffers, $totalBytes bytes total")

    virtualDisplay.release()
    codec.stop()
    codec.release()
}

private fun createMirrorVirtualDisplay(
    name: String,
    width: Int,
    height: Int,
    displayIdToMirror: Int,
    surface: Surface
): VirtualDisplay {
    // android.hardware.display.DisplayManager.createVirtualDisplay(String, int, int, int, Surface)
    // is @hide (mirrors an existing display's content) - not in the public SDK
    // stub jar, so it must be invoked via reflection. It is a *static* method,
    // confirmed against scrcpy's wrappers/DisplayManager.java.
    val method: Method = android.hardware.display.DisplayManager::class.java.getMethod(
        "createVirtualDisplay",
        String::class.java,
        Int::class.javaPrimitiveType,
        Int::class.javaPrimitiveType,
        Int::class.javaPrimitiveType,
        Surface::class.java
    )
    return method.invoke(null, name, width, height, displayIdToMirror, surface) as VirtualDisplay
}

private fun requestDisplayPower(displayId: Int, on: Boolean): Boolean {
    return try {
        // android.hardware.display.DisplayManagerGlobal.requestDisplayPower(int, boolean)
        // is @hide. Without this, a mirroring VirtualDisplay only ever receives a
        // single initial composite from SurfaceFlinger and is never refreshed again.
        val dmgClass = Class.forName("android.hardware.display.DisplayManagerGlobal")
        val getInstance = dmgClass.getDeclaredMethod("getInstance")
        val dmg = getInstance.invoke(null)
        val method = dmgClass.getMethod("requestDisplayPower", Int::class.javaPrimitiveType, Boolean::class.javaPrimitiveType)
        method.invoke(dmg, displayId, on) as Boolean
    } catch (e: ReflectiveOperationException) {
        log("requestDisplayPower failed: $e")
        false
    }
}

private fun log(message: String) {
    System.err.println("ScreenCaptureSpike: $message")
}
