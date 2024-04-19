package com.ysbing.audioshare;

public class Options {
    String socketName;
    String connectCode;

    public static Options parse(String... args) {
        Options options = new Options();

        for (String arg : args) {
            int equalIndex = arg.indexOf('=');
            if (equalIndex == -1) {
                throw new IllegalArgumentException("Invalid key=value pair: \"" + arg + "\"");
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
        return options;
    }
}