package com.ysbing.audioshare;

import android.media.AudioAttributes;
import android.media.AudioFormat;
import android.media.AudioTrack;
import android.net.LocalSocket;
import android.net.LocalSocketAddress;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class Main {

    public static void main(String[] args) {
        try {
            Options options = Options.parse(args);
            LocalSocket socket = connect(options.socketName, options.connectCode);
            play(socket.getInputStream());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static LocalSocket connect(String abstractName, String connectCode) throws IOException {
        LocalSocket localSocket = new LocalSocket();
        localSocket.connect(new LocalSocketAddress(abstractName));
        OutputStream outputStream = localSocket.getOutputStream();
        outputStream.write(connectCode.getBytes());
        outputStream.flush();
        return localSocket;
    }

    private static void play(InputStream inputStream) throws IOException {
        int bufferSize = AudioTrack.getMinBufferSize(48000, AudioFormat.CHANNEL_OUT_STEREO, AudioFormat.ENCODING_PCM_16BIT);
        AudioTrack audioTrack = new AudioTrack.Builder()
                .setAudioAttributes(new AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_MEDIA)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .build())
                .setAudioFormat(new AudioFormat.Builder()
                        .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                        .setSampleRate(48000)
                        .setChannelMask(AudioFormat.CHANNEL_OUT_STEREO)
                        .build())
                .setBufferSizeInBytes(bufferSize)
                .setTransferMode(AudioTrack.MODE_STREAM)
                .build();
        audioTrack.play();
        byte[] audioBuffer = new byte[bufferSize];
        while (!Thread.currentThread().isInterrupted()) {
            int bytesRead = inputStream.read(audioBuffer, 0, bufferSize);
            if (bytesRead == -1) {
                continue;
            }
            audioTrack.write(audioBuffer, 0, bytesRead);
        }
        // 不再播放时停止和释放资源
        audioTrack.stop();
        audioTrack.release();
    }
}
