import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/appStatesController.dart';
import '../../function/helper.dart';
import '../../function/removeFocus.dart';
import '../../function/showAlert.dart';
import '../../models/entities/user.dart';
import '../../models/user.dart';
import '../../views/widgets/dialogLoading.dart';

class EditProfileFormController extends GetxController {
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

  final AppStateController appStateController = Get.put(AppStateController());

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 0)).then((_) {
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
    DialogLoading dlg = DialogLoading();
    showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) {
          return dlg;
        });

    UserInfo editProf = UserInfo.clone(appStateController.usersEdit.value);
    editProf.fullname = fullnameCon.text;
    editProf.phone = phoneCon.text;
    editProf.address1 = address1Con.text;
    editProf.address2 = address2Con.text;
    editProf.zipcode = zipcodeCon.text;
    editProf.username = usernameCon.text;

    bool result = false;
    try {
      result = await UserModel.instance.editProfile(editProf);
      if (result) {
        Get.back();
        showAlert(Get.context!, LoadingState.success, "Update profile berhasil",
            thens: (x) {
          appStateController.setAppState(Operation.bringToHome, HomeTab.home);
          Map? arg = Get.arguments;
          if (arg != null) {
            if (arg.containsKey("route") && arg.containsKey("arguments")) {
              appStateController.setAppState(Operation.pushNamed, arg);
            }
          }
        });
      }
    } catch (e) {
      Get.back();
      showAlert(
          Get.context!, LoadingState.error, translateFromPattern(e.toString()));
    }
  }
}
