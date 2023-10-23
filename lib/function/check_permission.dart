import 'dart:io';

import 'package:mutex/mutex.dart';
import 'package:permission_handler/permission_handler.dart';

Mutex requestingPermission = Mutex();

Future<bool> cekPermission() async {
  if (!Platform.isIOS) {
    int i = 0;
    try {
      if (await Permission.camera.request().isGranted) {
        i++;
      }
      if (await Permission.photos.request().isGranted) {
        i++;
      }
      if (await Permission.storage.request().isGranted) {
        i++;
      }
      if (i >= 1) {
        return true;
      }
      return false;
    } catch (ex) {
      return false;
    }
  } else {
    return true;
  }
}

Future<bool> cekPermissionNotif() async {
  if (!Platform.isIOS) {

    try {
      if (await Permission.notification.request().isGranted) {
        return true;
      }
      return false;
    } catch (ex) {
      return false;
    }
  } else {
    return true;
  }
}
