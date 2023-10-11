import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum LoadingState { progress, success, error, info, warning}

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
    iconSt: CircularProgressIndicator()
  ));

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
          iconSt: CircularProgressIndicator()
        );
        return Get.defaultDialog(
          content: Container(
            decoration: BoxDecoration(
              color: caption.value.backgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4)
            ),
            child: Container(
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
          caption: "Login Berhasil",
          iconSt: iconSt
        );
        return Get.defaultDialog(
          content: Container(
            decoration: BoxDecoration(
              color: caption.value.backgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4)
            ),
            child: Container(
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
            child: Container(
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
            child: Container(
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
            child: Container(
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

  @override
  void onClose() {
    super.onClose();
  }
}