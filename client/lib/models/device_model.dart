class DeviceModel {
  final String deviceId;
  final bool usb;
  final String serialNumber;
  final String model;
  final String manufacturer;
  final String androidVersion;
  final String apiLevel;
  final String ip;
  final String port;

  DeviceModel({
    required this.deviceId,
    required this.usb,
    required this.serialNumber,
    required this.model,
    required this.manufacturer,
    required this.androidVersion,
    required this.apiLevel,
    required this.ip,
    required this.port,
  });
}
