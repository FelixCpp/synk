package de.synk

import android.os.Build
import com.google.protobuf.ByteString
import de.synk.proto.AgentError
import de.synk.proto.AgentRequest
import de.synk.proto.AgentResponse
import de.synk.proto.CaptureScreenshotRequest
import de.synk.proto.CaptureScreenshotResponse
import de.synk.proto.GetInfoRequest
import de.synk.proto.GetInfoResponse
import java.io.DataInputStream
import java.io.DataOutputStream
import java.io.EOFException
import java.net.InetAddress
import java.net.ServerSocket

private const val PORT = 27183

fun main() {
    val serverSocket = ServerSocket(PORT, 0, InetAddress.getLoopbackAddress())
    println("Agent listening on port $PORT")

    serverSocket.use { server ->
        val socket = server.accept()
        println("Client connected")

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
                val response = dispatch(request)

                val responseBytes = response.toByteArray()
                output.writeInt(responseBytes.size)
                output.write(responseBytes)
                output.flush()
            }
        }
    }
}

fun dispatch(request: AgentRequest): AgentResponse {
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
