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
            try (LocalSocket socket = connect(options.socketName, options.connectCode)) {
                InputStream inputStream = socket.getInputStream();

                // Read 8-byte format header: [uint32 sampleRate LE][uint16 channels LE][uint16 bitsPerSample LE]
                byte[] header = readFully(inputStream, 8);
                int sampleRate = readInt32LE(header, 0);
                int channels = readInt16LE(header, 4);

                int channelMask = (channels == 1)
                        ? AudioFormat.CHANNEL_OUT_MONO
                        : AudioFormat.CHANNEL_OUT_STEREO;

                play(inputStream, sampleRate, channelMask);
            }
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

    private static byte[] readFully(InputStream in, int len) throws IOException {
        byte[] buf = new byte[len];
        int offset = 0;
        while (offset < len) {
            int n = in.read(buf, offset, len - offset);
            if (n == -1) throw new IOException("Stream ended before format header was complete");
            offset += n;
        }
        return buf;
    }

    private static int readInt32LE(byte[] buf, int offset) {
        return (buf[offset] & 0xFF)
                | ((buf[offset + 1] & 0xFF) << 8)
                | ((buf[offset + 2] & 0xFF) << 16)
                | ((buf[offset + 3] & 0xFF) << 24);
    }

    private static int readInt16LE(byte[] buf, int offset) {
        return (buf[offset] & 0xFF) | ((buf[offset + 1] & 0xFF) << 8);
    }

    private static void play(InputStream inputStream, int sampleRate, int channelMask) throws IOException {
        android.os.Process.setThreadPriority(android.os.Process.THREAD_PRIORITY_AUDIO);

        int minBuffer = AudioTrack.getMinBufferSize(sampleRate, channelMask, AudioFormat.ENCODING_PCM_16BIT);
        // 8x minimum: WASAPI delivers audio in ~10ms engine-period bursts; a large buffer
        // absorbs jitter so AudioTrack never underruns between bursts.
        int trackBuffer = minBuffer * 8;
        AudioTrack audioTrack = new AudioTrack.Builder()
                .setAudioAttributes(new AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_MEDIA)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .build())
                .setAudioFormat(new AudioFormat.Builder()
                        .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                        .setSampleRate(sampleRate)
                        .setChannelMask(channelMask)
                        .build())
                .setBufferSizeInBytes(trackBuffer)
                .setTransferMode(AudioTrack.MODE_STREAM)
                .build();

        byte[] readBuf = new byte[minBuffer];

        // Pre-roll: fill half the AudioTrack buffer before starting playback.
        // This creates a timing cushion so the first 10ms engine-period gap never underruns.
        int preRollTarget = trackBuffer / 2;
        int preRolled = 0;
        outer:
        while (preRolled < preRollTarget) {
            int n = inputStream.read(readBuf, 0, Math.min(readBuf.length, preRollTarget - preRolled));
            if (n == -1) break;
            int offset = 0;
            while (offset < n) {
                int written = audioTrack.write(readBuf, offset, n - offset);
                if (written < 0) break outer;
                offset += written;
            }
            preRolled += n;
        }

        audioTrack.play();
        try {
            while (!Thread.currentThread().isInterrupted()) {
                int bytesRead = inputStream.read(readBuf, 0, readBuf.length);
                if (bytesRead == -1) break;
                int offset = 0;
                while (offset < bytesRead) {
                    int written = audioTrack.write(readBuf, offset, bytesRead - offset);
                    if (written < 0) break;
                    offset += written;
                }
            }
        } finally {
            audioTrack.stop();
            audioTrack.release();
        }
    }
}
