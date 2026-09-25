package de.deviceviewer

import android.os.Build
import com.google.protobuf.ByteString
import de.deviceviewer.proto.AgentError
import de.deviceviewer.proto.AgentRequest
import de.deviceviewer.proto.AgentResponse
import de.deviceviewer.proto.CaptureScreenshotRequest
import de.deviceviewer.proto.CaptureScreenshotResponse
import de.deviceviewer.proto.GetInfoRequest
import de.deviceviewer.proto.GetInfoResponse
import de.deviceviewer.proto.StartScreenStreamRequest
import de.deviceviewer.proto.StartScreenStreamResponse
import de.deviceviewer.proto.StopScreenStreamRequest
import de.deviceviewer.proto.StopScreenStreamResponse
import java.io.DataInputStream
import java.io.DataOutputStream
import java.io.EOFException
import java.net.InetAddress
import java.net.ServerSocket

private const val PORT = 27183

fun main() {
    val serverSocket = ServerSocket(PORT, 0, InetAddress.getLoopbackAddress())
    println("Agent listening on port $PORT")

    val screenStreamSession = ScreenStreamSession()

    serverSocket.use { server ->
        val socket = server.accept()
        println("Client connected")

        try {
            socket.use {
                val input = DataInputStream(socket.getInputStream())
                val output = DataOutputStream(socket.getOutputStream())

                while (true) {
                    val length = try {
                        input.readInt()
                    } catch (e: EOFException) {
                        break // Connection has been closed by the client.
                    }

                    val requestBytes = ByteArray(length)
                    input.readFully(requestBytes)

                    val request = AgentRequest.parseFrom(requestBytes)
                    val response = dispatch(request, screenStreamSession)

                    val responseBytes = response.toByteArray()
                    output.writeInt(responseBytes.size)
                    output.write(responseBytes)
                    output.flush()
                }
            }
        } finally {
            // The control connection dropped (or the loop above exited) -
            // never leave the encoder/virtual display running unattended.
            screenStreamSession.stop()
        }
    }
}

fun dispatch(request: AgentRequest, screenStreamSession: ScreenStreamSession): AgentResponse {
    return try {
        when (request.payloadCase) {
            AgentRequest.PayloadCase.GET_INFO -> {
                AgentResponse
                    .newBuilder()
                    .setGetInfo(handleGetInfo(request.getInfo))
                    .build()
            }

            AgentRequest.PayloadCase.CAPTURE_SCREENSHOT -> {
                AgentResponse
                    .newBuilder()
                    .setCaptureScreenshot(handleCaptureScreenshot(request.captureScreenshot))
                    .build()
            }

            AgentRequest.PayloadCase.START_SCREEN_STREAM -> {
                AgentResponse
                    .newBuilder()
                    .setStartScreenStream(handleStartScreenStream(request.startScreenStream, screenStreamSession))
                    .build()
            }

            AgentRequest.PayloadCase.STOP_SCREEN_STREAM -> {
                AgentResponse
                    .newBuilder()
                    .setStopScreenStream(handleStopScreenStream(request.stopScreenStream, screenStreamSession))
                    .build()
            }

            AgentRequest.PayloadCase.PAYLOAD_NOT_SET -> {
                error("Received request without payload")
            }
        }
    } catch (e: Exception) {
        AgentResponse
            .newBuilder()
            .setError(
                AgentError
                    .newBuilder()
                    .setMessage(e.message ?: e.toString())
                    .build()
            )
            .build()
    }
}

private fun handleGetInfo(request: GetInfoRequest): GetInfoResponse {
    return GetInfoResponse
        .newBuilder()
        .setModel(Build.MODEL)
        .setManufacturer(Build.MANUFACTURER)
        .setAndroidVersion(Build.VERSION.RELEASE)
        .setSdkVersion(Build.VERSION.SDK_INT)
        .build()
}

private fun handleStartScreenStream(
    request: StartScreenStreamRequest,
    session: ScreenStreamSession
): StartScreenStreamResponse {
    val port = session.start()
    return StartScreenStreamResponse
        .newBuilder()
        .setVideoPort(port)
        .build()
}

private fun handleStopScreenStream(
    request: StopScreenStreamRequest,
    session: ScreenStreamSession
): StopScreenStreamResponse {
    session.stop()
    return StopScreenStreamResponse.newBuilder().build()
}

private fun handleCaptureScreenshot(request: CaptureScreenshotRequest): CaptureScreenshotResponse {
    val process = ProcessBuilder("screencap", "-p").start()
    val pngBytes = process.inputStream.readBytes()
    val exitCode = process.waitFor()

    check(exitCode == 0) { "screencap failed with exit code $exitCode" }

    return CaptureScreenshotResponse
        .newBuilder()
        .setPng(ByteString.copyFrom(pngBytes))
        .build()
}
