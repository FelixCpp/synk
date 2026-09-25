package de.deviceviewer

import android.os.Build
import de.deviceviewer.proto.GetInfoRequest
import de.deviceviewer.proto.GetInfoResponse
import java.io.DataInputStream
import java.io.DataOutputStream
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

            val requestLength = input.readInt()
            val requestBytes = ByteArray(requestLength)

            input.readFully(requestBytes)

            val request = GetInfoRequest.parseFrom(requestBytes)
            println("Received: $request")

            val response =
                GetInfoResponse
                    .newBuilder()
                    .setModel(Build.MODEL)
                    .setManufacturer(Build.MANUFACTURER)
                    .setAndroidVersion(Build.VERSION.RELEASE)
                    .setSdkVersion(Build.VERSION.SDK_INT)
                    .build()

            val responseBytes = response.toByteArray()
            output.writeInt(responseBytes.size)
            output.write(responseBytes)
            output.flush()
        }
    }
}
