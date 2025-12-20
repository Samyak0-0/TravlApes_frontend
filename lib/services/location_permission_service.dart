import 'package:permission_handler/permission_handler.dart';

class LocationPermissionService {
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  static Future<bool> hasLocationPermission() async {
    return await Permission.location.isGranted;
  }
}

