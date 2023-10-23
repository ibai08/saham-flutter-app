import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user.dart';

enum LoadingState { progress, success, error, info, warning }
enum DialogType { dialogCabang, dialogConfirmation, dialogToken }

class LoadingStateData {
  LoadingState? state;
  LoadingState? status;
  Color? backgroundColor;
  Color? fontColor;
  String? caption;
  Widget? iconSt;
  LoadingStateData({this.state, this.backgroundColor, this.fontColor, this.caption, this.iconSt, this.status});
}

class DialogController extends GetxController {
  Rx<LoadingStateData> caption = Rx<LoadingStateData>(LoadingStateData(
    backgroundColor: Colors.white,
    state: LoadingState.progress,
    status: LoadingState.progress,
    fontColor: Colors.black,
    caption: "Mohon Tunggu",
    iconSt: const CircularProgressIndicator()
  ));
  // RxBool login = false.obs;
  // RxBool cekLog = false.obs;

  // cekLogin() {
  //   if (cekLog.value)
  // }

  showToast(String message, String label) {
    return Get.showSnackbar(
      GetSnackBar(
        snackStyle: SnackStyle.GROUNDED,
        message: message,
        duration: const Duration(seconds: 2),
        mainButton: SnackBarAction(
          textColor: Colors.blue,
          label: label,
          onPressed: Get.closeCurrentSnackbar
        ),
      )
    );
  }

  logoutConfirm() {
    return Get.defaultDialog(
      title: "LOGOUT",
      textConfirm: "Log Out",
      textCancel: "Cancel",
      buttonColor: Colors.transparent,
      confirmTextColor: Colors.red,
      onCancel: () {
        Get.back();
      },
      onConfirm: () async {
        Get.back();
        await UserModel.instance.logout();
      },
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4)
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "assets/icon-alert-warning.png",
                width: 50,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Are you sure you want to Logout?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      )
    );
  }

  // showDialog(DialogType dialogType, dynamic user, dynamic arguments) {
  //   switch (dialogType) {
  //     case DialogType.dialogCabang:
  //       String? dropdownValue; 
  //       List<dynamic> users = user;
  //       dropdownValue ??= users[0]["id"].toString();
  //       return Get.defaultDialog(
  //         content: Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(25)
  //           ),
  //           color: Colors.transparent,
  //           child: Stack(
  //             children: <Widget>[
  //               Container(
  //                 padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
  //                 margin: const EdgeInsets.only(top: 66.0),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   shape: BoxShape.rectangle,
  //                   borderRadius: BorderRadius.circular(16.0),
  //                   boxShadow: const [
  //                     BoxShadow(
  //                       color: Colors.black26,
  //                       blurRadius: 10.0,
  //                       offset: Offset(0.0, 10.0),
  //                     ),
  //                   ],
  //                 ),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min, // To make the card compact
  //                   children: <Widget>[
  //                     const Text(
  //                       "Pilih Cabang",
  //                       style: TextStyle(
  //                         fontSize: 22.0,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 16.0),
  //                     DropdownWithLabel<String>(
  //                       value: dropdownValue,
  //                       title: "Pilih Cabang",
  //                       label: "Pilih Cabang",
  //                       onChange: (String newValue) {
  //                         dropdownValue = newValue;
  //                       },
  //                       items: users.map<DropdownMenuItem<String>>((value) {
  //                         return DropdownMenuItem<String>(
  //                           value: value["id"].toString(),
  //                           child: Text(value["cabang_city"]),
  //                         );
  //                       }).toList(),
  //                     ),
  //                     SizedBox(height: 24.0),
  //                     BtnBlock(
  //                       title: "Login",
  //                       onTap: () async {
  //                         try {
  //                           widget.cekLog = true;
  //                           await performLogin(users);
  //                         } catch (xerr) {
  //                           print(xerr);
  //                           widget.cekLog = null;
  //                           widget.errors = xerr.message;
  //                         }
  //                         // Navigator.pop(context);
  //                       },
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )
  //       );
  //     case DialogType.dialogConfirmation:
  //       break;
  //     case DialogType.dialogToken:
  //       break;
  //   }
  // }
 
  setProgress(LoadingState status, String caps) {
    Image iconSt;
    switch (status) {
      case LoadingState.progress: 
        caption.value = LoadingStateData( 
          backgroundColor: Colors.white,
          state: LoadingState.progress,
          status: status,
          fontColor: Colors.black,
          caption: "Mohon Tunggu",
          iconSt: const CircularProgressIndicator()
        );
        return Get.defaultDialog(
          content: Container(
            decoration: BoxDecoration(
              color: caption.value.backgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4)
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(child: caption.value.iconSt),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    caption.value.caption!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: caption.value.fontColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        );
        
      case LoadingState.success: 
        iconSt = Image.asset(
          "assets/icon-alert-success.png",
          width: 50,
        );
        caption.value = LoadingStateData(
          backgroundColor: Colors.white,
          state: LoadingState.success,
          status: status,
          fontColor: Colors.black,
          caption: caps,
          iconSt: iconSt
        );
        return Get.defaultDialog(
          content: Container(
            decoration: BoxDecoration(
              color: caption.value.backgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4)
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(child: caption.value.iconSt),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    caption.value.caption!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: caption.value.fontColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        );
      case LoadingState.error:
        iconSt = Image.asset(
          "assets/icon-alert-error.png",
          width: 50,
        );
        caption.value = LoadingStateData(
          backgroundColor: Colors.white,
          state: LoadingState.error,
          status: status,
          fontColor: Colors.black,
          caption: caps,
          iconSt: iconSt
        );
        return Get.defaultDialog(
          content: Container(
            decoration: BoxDecoration(
              color: caption.value.backgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4)
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(child: caption.value.iconSt),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    caption.value.caption!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: caption.value.fontColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        );
      case LoadingState.warning:
        iconSt = Image.asset(
          "assets/icon-alert-warning.png",
          width: 50,
        );
         caption.value = LoadingStateData(
          backgroundColor: Colors.white,
          state: LoadingState.warning,
          status: status,
          fontColor: Colors.black,
          caption: caps,
          iconSt: iconSt
        );
        return Get.defaultDialog(
          content: Container(
            decoration: BoxDecoration(
              color: caption.value.backgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4)
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(child: caption.value.iconSt),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    caption.value.caption!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: caption.value.fontColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        );
      case LoadingState.info:
        iconSt = Image.asset(
          "assets/icon-info.png",
          width: 50,
        );
         caption.value = LoadingStateData(
          backgroundColor: Colors.white,
          state: LoadingState.info,
          status: status,
          fontColor: Colors.black,
          caption: caps,
          iconSt: iconSt
        );
        return Get.defaultDialog(
          content: Container(
            decoration: BoxDecoration(
              color: caption.value.backgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4)
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(child: caption.value.iconSt),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    caption.value.caption!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: caption.value.fontColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        );
    }
  }
}