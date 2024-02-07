import 'package:device_info_plus/device_info_plus.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Shows a message stating that the feature is not yet implemented.
void showTodoMessage(BuildContext context) {
  showSnackBar('Feature was not implemented yet', context);
}

/// Shows a snack bar with the given [message].
void showSnackBar(String message, BuildContext? context) {
  if (context == null) {
    return;
  }
  context.showFlash<bool>(
    duration: const Duration(seconds: 2),
    builder: (context, controller) {
      return FlashBar(
        controller: controller,
        backgroundColor: Colors.black,
        position: FlashPosition.bottom,
        dismissDirections: const [FlashDismissDirection.startToEnd, FlashDismissDirection.vertical],
        content: Text(message, style: const TextStyle(color: Colors.white)),
      );
    },
  );
}

/// A mixin that provides information about the app and the device.
mixin InfoMixin<T extends StatefulWidget> on State<T> {
  /// A future that resolves to the package info of the app.
  late Future<PackageInfo> packageInfoFuture;

  /// A future that resolves to the device info of the device.
  late Future<BaseDeviceInfo> deviceInfoFuture;

  @override
  void initState() {
    super.initState();
    packageInfoFuture = PackageInfo.fromPlatform();
    deviceInfoFuture = DeviceInfoPlugin().deviceInfo;
  }
}

/// Serializes the given [deviceInfo] to a map.
Map<String, Object?> serializeDeviceInfo(BaseDeviceInfo deviceInfo) {
  return deviceInfo.data..removeWhere((key, value) => value is! String && value is! int && value is! bool);
}
