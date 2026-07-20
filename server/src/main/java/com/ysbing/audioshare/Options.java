package com.ysbing.audioshare;

public class Options {
    String socketName;
    String connectCode;

    public static Options parse(String... args) {
        Options options = new Options();

        for (String arg : args) {
            int equalIndex = arg.indexOf('=');
            if (equalIndex == -1) {
                throw new IllegalArgumentException("ARGUMENT_FORMAT_INVALID");
            }
            String key = arg.substring(0, equalIndex);
            String value = arg.substring(equalIndex + 1);
            switch (key) {
                case "socketName":
                    options.socketName = value;
                    break;
                case "connectCode":
                    options.connectCode = value;
                    break;
                default:
                    break;
            }
        }

        if (options.socketName == null) throw new IllegalArgumentException("SOCKET_NAME_REQUIRED");
        if (options.connectCode == null) throw new IllegalArgumentException("CONNECT_CODE_REQUIRED");

        return options;
    }
}
