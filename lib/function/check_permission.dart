import 'package:permission_handler/permission_handler.dart';

// Future<bool> cekPermission() async {
//   if (!Platform.isIOS) {
//     int i = 0;
//     try {
//       if (await Permission.camera.request().isGranted) {
//         i++;
//       }
//       if (await Permission.photos.request().isGranted) {
//         i++;
//       }
//       if (await Permission.storage.request().isGranted) {
//         i++;
//       }
//       if (i >= 1) {
//         return true;
//       }
//       return false;
//     } catch (ex) {
//       return false;
//     }
//   } else {
//     return true;
//   }
// }

Future<bool> cekPermission() async {
  int i = 0;
  try {
    var status1 = await Permission.camera.request();
    var status2 = await Permission.photos.request();
    var status3 = await Permission.storage.request();
    if (status1.isGranted) {
      i++;
    }
    if (status2.isGranted) {
      i++;
    }
    if (status3.isGranted) {
      i++;
    }
    // Digunakan apabila user memilih opsi untuk tidak mengizinkan secara permanen
    // if (status1 == PermissionStatus.permanentlyDenied || status2 == PermissionStatus.permanentlyDenied || status3 == PermissionStatus.permanentlyDenied) {
    //   openAppSettings();
    // }
    if (i >= 3) {
      return true;
    }
  } catch (ex) {
    // DialogController dialogController = Get.find();
    // dialogController.setProgress(LoadingState.error, ex.toString(), null, null, null);
    return false;
  }
  return false;
}

// Future<bool> cekPermissionNotif() async {
//   if (!Platform.isIOS) {

//     try {
//       if (await Permission.notification.request().isGranted) {
//         return true;
//       }
//       return false;
//     } catch (ex) {
//       return false;
//     }
//   } else {
//     return true;
//   }
// }

Future<bool> cekPermissionNotif() async {
  try {
    if (await Permission.notification.request().isGranted) {
      return true;
    }
  } catch (ex) {
    return false;
  }
  return false;
}
