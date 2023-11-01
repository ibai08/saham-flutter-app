import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/home_tab_controller.dart';
import 'package:saham_01_app/views/widgets/get_alert.dart';
import 'app_state_controller.dart';
import '../function/remove_focus.dart';
import '../../models/entities/user.dart';
import '../../models/user.dart';

class EditProfileFormController extends GetxController {
  final DialogController dialogController = Get.find();
  final NewHomeTabController newHomeTabController = Get.find();
  final usernameCon = TextEditingController();
  final emailCon = TextEditingController();
  final fullnameCon = TextEditingController();
  final phoneCon = TextEditingController();
  final zipcodeCon = TextEditingController();
  final address1Con = TextEditingController();
  final address2Con = TextEditingController();
  final villageCon = TextEditingController();

  final usernameFocus = FocusNode();
  final emailFocus = FocusNode();
  final fullnameFocus = FocusNode();
  final phoneFocus = FocusNode();
  final zipcodeFocus = FocusNode();
  final address1Focus = FocusNode();

  late InputBorder borderUsername;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late bool editOnlyUsername;

  final AppStateController appStateController = Get.find();

  @override
  void onInit() {
    Future.delayed(const Duration(milliseconds: 0)).then((_) {
      if (appStateController.users.value.id < 1) {
        // Navigator.popUntil(context, ModalRoute.withName("/home"));
        Get.until((route) => route.isFirst || route.settings.name == '/home');
      }
    });

    usernameCon.text = (appStateController.users.value.username !=
            appStateController.usersEdit.value.username)
        ? appStateController.usersEdit.value.username ?? ''
        : appStateController.users.value.username ?? '';

    emailCon.text = (appStateController.users.value.email !=
            appStateController.usersEdit.value.email)
        ? appStateController.usersEdit.value.email ?? ''
        : appStateController.users.value.email ?? '';

    fullnameCon.text = (appStateController.users.value.fullname !=
            appStateController.usersEdit.value.fullname)
        ? appStateController.usersEdit.value.fullname ?? ''
        : appStateController.users.value.fullname ?? '';

    phoneCon.text = (appStateController.users.value.phone !=
            appStateController.usersEdit.value.phone)
        ? appStateController.usersEdit.value.phone ?? ''
        : appStateController.users.value.phone ?? '';

    zipcodeCon.text = (appStateController.users.value.zipcode !=
            appStateController.usersEdit.value.zipcode)
        ? appStateController.usersEdit.value.zipcode ?? ''
        : appStateController.users.value.zipcode ?? '';

    address1Con.text = (appStateController.users.value.address1 !=
            appStateController.usersEdit.value.address1)
        ? appStateController.usersEdit.value.address1 ?? ''
        : appStateController.users.value.address1 ?? '';

    address2Con.text = (appStateController.users.value.address2 !=
            appStateController.usersEdit.value.address2)
        ? appStateController.usersEdit.value.address2 ?? ''
        : appStateController.users.value.address2 ?? '';

    villageCon.text = (appStateController.users.value.village !=
            appStateController.usersEdit.value.village)
        ? appStateController.usersEdit.value.village ?? ''
        : appStateController.users.value.village ?? '';

    usernameCon.text = usernameCon.text == 'null' ? "" : usernameCon.text;
    address2Con.text = address2Con.text == 'null' ? "" : address2Con.text;
    zipcodeCon.text = zipcodeCon.text == 'null' ? '' : zipcodeCon.text;

    borderUsername = usernameCon.text != ""
        ? InputBorder.none
        : const UnderlineInputBorder();
    editOnlyUsername = usernameCon.text != "" ? true : false;
    super.onInit();
  }

  performSaveProfile() async {
    removeFocus(Get.context);
    // DialogLoading dlg = DialogLoading();
    // showDialog(
    //     barrierDismissible: false,
    //     context: Get.context!,
    //     builder: (context) {
    //       return dlg;
    //     });
    dialogController.setProgress(LoadingState.progress, "Mohon Tunggu", null, null, null);
    UserInfo editProf = UserInfo.clone(appStateController.usersEdit.value);
    editProf.fullname = fullnameCon.text;
    editProf.phone = phoneCon.text;
    editProf.address1 = address1Con.text;
    editProf.address2 = address2Con.text;
    editProf.zipcode = zipcodeCon.text;
    editProf.username = usernameCon.text;
    editProf.village = villageCon.text;
    editProf.email = emailCon.text;

    bool result = false;
    try {
      result = await UserModel.instance.editProfile(editProf);
      if (result) {
        Get.back();
        await dialogController.setProgress(LoadingState.success, "Update profile berhasil", null, null, null);
        Get.until((route) => route.isFirst || route.settings.name == '/home');
        newHomeTabController.tab.value = HomeTab.home;
        newHomeTabController.tabController.animateTo(0,duration: const Duration(milliseconds: 200),curve:Curves.easeIn);
        onClose();
      }
    } catch (e) {
      Get.back();
      dialogController.setProgress(LoadingState.error, e.toString(), null, null, null);
    }
  }

  @override
  void onClose() {
    usernameCon.clear();
    emailCon.clear();
    fullnameCon.clear();
    phoneCon.clear();
    zipcodeCon.clear();
    address1Con.clear();
    address2Con.clear();
    villageCon.clear();
    super.onClose();
  }
}
