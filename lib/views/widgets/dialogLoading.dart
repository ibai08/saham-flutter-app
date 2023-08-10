// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/constants/app_colors.dart';

enum LoadingState { progress, info, warning, success, error }

class _LoadingStateData {
  LoadingState? state;
  LoadingState? status;
  Color? backgroundColor;
  Color? fontColor;
  String? caption;
  Widget? iconSt;
  _LoadingStateData({
    this.state,
    this.backgroundColor,
    this.fontColor,
    this.caption,
    this.iconSt,
    this.status,
  });
}

// class DialogLoadingController extends GetxController {
//   // Variabel Rx untuk menyimpan data loading state
//   final Rx<_LoadingStateData>? _caption = _LoadingStateData().obs;

//   // Fungsi untuk mengubah data loading state menjadi progress
//   void setProgress(LoadingState status, String caps) {
//     Image? iconSt;
//     switch (status) {
//       case LoadingState.success:
//         iconSt = Image.asset(
//           "assets/icon-alert-success.png",
//           width: 50,
//         );
//         break;
//       case LoadingState.warning:
//         iconSt = Image.asset(
//           "assets/icon-alert-warning.png",
//           width: 50,
//         );
//         break;
//       case LoadingState.error:
//         iconSt = Image.asset(
//           "assets/icon-alert-error.png",
//           width: 50,
//         );
//         break;
//       case LoadingState.info:
//         iconSt = Image.asset(
//           "assets/icon-alert-warning.png",
//           width: 50,
//         );
//         break;
//       default:
//     }
//     // Memperbarui nilai _caption menggunakan update()
//     _caption?.update((_LoadingStateData? value) {
//       value?.status = status;
//       value?.state = LoadingState.progress;
//       value?.iconSt = iconSt;
//       value?.backgroundColor = Colors.white;
//       value?.fontColor = Colors.black;
//       value?.caption = caps;
//     });
//   }

//   // Fungsi untuk mengubah data loading state menjadi success
//   void setSuccess(String caps) {
//     // Memperbarui nilai _caption menggunakan update()
//     _caption?.update((_LoadingStateData? value) {
//       value?.state = LoadingState.progress;
//       value?.iconSt = Image.asset(
//         "assets/icon-success.png",
//         width: 50,
//       );
//       value?.backgroundColor = Colors.white;
//       value?.status = LoadingState.success;
//       value?.fontColor = Colors.black;
//       value?.caption = caps;
//     });
//   }

//   // Fungsi untuk mengubah data loading state menjadi error
//   void setError(Object error) {
//     // Memperbarui nilai _caption menggunakan update()
//     _caption?.update((_LoadingStateData? value) {
//       value?.iconSt = Image.asset(
//         "assets/icon-error.png",
//         width: 50,
//       );
//       value?.state = LoadingState.progress;
//       value?.backgroundColor = Colors.white;
//       value?.status = LoadingState.error;
//       value?.fontColor = Colors.black;
//       value?.caption = error as String;
//     });
//   }

//   final int? autoclose;

//   DialogLoadingController({this.autoclose});

//   @override
//   void onInit() {
//     super.onInit();
//     // Memastikan bahwa widget akan diperbarui saat nilai _caption berubah
//     ever(_caption!, (_) {
//       update();
//     });
//   }

//   @override
//   void onClose() {
//     // Menutup StreamController saat widget dihapus
//     _caption?.close();
//     super.onClose();
//   }
// }

// class DialogLoading extends StatelessWidget {
//   final DialogLoadingController controller = Get.find();
//   Widget getDialogWidget(BuildContext context, _LoadingStateData loading) {
//     Widget icon = CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen));
//     if (loading.state != LoadingState.progress) {
//       return Container(
//         width: double.infinity,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const SizedBox(
//               height: 10,
//             ),
//             Text(
//               loading.caption!,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   fontSize: 19.0,
//                   fontWeight: FontWeight.w600,
//                   color: loading.fontColor),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//           ],
//         ),
//       );
//     }
//     if (loading.status != null) {
//       icon = loading.iconSt!;
//     }
//     return Container(
//       width: double.infinity,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           const SizedBox(
//             height: 10,
//           ),
//           Center(child: icon),
//           const SizedBox(
//             height: 15,
//           ),
//           Text(
//             loading.caption!,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: loading.fontColor),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (controller.autoclose != null) {
//       Future.delayed(Duration(seconds: controller.autoclose!)).then((x) {
//         Get.back();
//       });
//     }
//     return Dialog(
//       // shape: RoundedRectangleBorder(
//       //   borderRadius: BorderRadius.circular(25),
//       // ),
//       elevation: 0.0,
//       backgroundColor: Colors.transparent,
//       child: Obx(
//         () {
//           final loading = controller._caption?.value ?? _LoadingStateData(
//             state: LoadingState.progress,
//             backgroundColor: Colors.white,
//             fontColor: Colors.black,
//             caption: "Mohon tunggu..."
//           );
//           return Stack(
//             children: <Widget>[
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                 margin: const EdgeInsets.only(top: 30),
//                 decoration: BoxDecoration(
//                   color: loading.backgroundColor,
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: getDialogWidget(context, loading),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

class DialogLoadingController extends GetxController {
  final Rx<_LoadingStateData>? _caption = _LoadingStateData().obs;

  void setProgress(LoadingState status, String caps) {
    Image? iconSt;
    switch (status) {
      case LoadingState.success:
        iconSt = Image.asset(
          "assets/icon-alert-success.png",
          width: 50,
        );
        break;
      case LoadingState.warning:
        iconSt = Image.asset(
          "assets/icon-alert-warning.png",
          width: 50,
        );
        break;
      case LoadingState.error:
        iconSt = Image.asset(
          "assets/icon-alert-error.png",
          width: 50,
        );
        break;
      case LoadingState.info:
        iconSt = Image.asset(
          "assets/icon-alert-warning.png",
          width: 50,
        );
        break;
      default:
    }
    _caption?.value = _LoadingStateData(
      status: status,
      state: LoadingState.progress,
      iconSt: iconSt,
      backgroundColor: Colors.white,
      fontColor: Colors.black,
      caption: caps,
    );
  }

  void setSuccess(String caps) {
    _caption?.value = _LoadingStateData(
      state: LoadingState.progress,
      iconSt: Image.asset(
        "assets/icon-success.png",
        width: 50,
      ),
      backgroundColor: Colors.white,
      status: LoadingState.success,
      fontColor: Colors.black,
      caption: caps,
    );
  }

  void setError(Object error) {
    _caption?.value = _LoadingStateData(
      iconSt: Image.asset(
        "assets/icon-error.png",
        width: 50,
      ),
      state: LoadingState.progress,
      backgroundColor: Colors.white,
      status: LoadingState.error,
      fontColor: Colors.black,
      caption: error.toString(),
    );
  }

  @override
  void onClose() {
    _caption?.close();
    super.onClose();
  }
}

class DialogLoading extends StatelessWidget {
  final int? autoclose;

  DialogLoading({Key? key, this.autoclose}) : super(key: key);

  final DialogLoadingController loadingController = Get.put(DialogLoadingController());

  Widget getDialogWidget(BuildContext context, _LoadingStateData loading) {
    Widget icon = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
    );
    if (loading.state != LoadingState.progress) {
      return Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              loading.caption ?? "Mohon tunggu...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.w600,
                color: loading.fontColor,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    }
    if (loading.status != null) {
      icon = loading.iconSt!;
    }
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          Center(child: icon),
          const SizedBox(height: 15),
          Text(
            loading.caption ?? "Mohon tunggu...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: loading.fontColor,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    if (autoclose != null) {
      Future.delayed(Duration(seconds: autoclose ?? 0)).then((x) {
        Get.back();
      });
    }
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Obx(() {
          // _LoadingStateData? loading = controller._caption?.value ?? _LoadingStateData(
          //   state: LoadingState.progress,
          //   backgroundColor: Colors.white,
          //   fontColor: Colors.black,
          //   caption: "Mohon tunggu..."
          // );
          _LoadingStateData? loading = loadingController._caption?.value;
          loading?.caption != null ? loading : loading = _LoadingStateData(
            state: LoadingState.progress,
            backgroundColor: Colors.white,
            fontColor: Colors.black,
            caption: "Mohon tunggu..."
          );
          return Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  color: loading?.backgroundColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: getDialogWidget(context, loading!),
              ),
            ],
          );
        },
      ),
    );
  }
}