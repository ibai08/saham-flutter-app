import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/home_tab_controller.dart';
import 'package:saham_01_app/function/helper.dart';
import 'package:saham_01_app/views/widgets/get_alert.dart';

import '../../controller/app_state_controller.dart';
import '../../models/user.dart';
import '../appbar/navtxt.dart';
import '../widgets/dialog_confirmation.dart';

class RefreshPage extends StatelessWidget {
  final DialogController dialogController = Get.find();
  final NewHomeTabController newHomeTabController = Get.find();

  RefreshPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: NavTxt(title: "Bersihkan Cache"),
      body: ListView(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            onTap: () async {
              try {
                bool lanjut = false;
                lanjut = await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return DialogConfirmation(
                        desc: "Yakin ingin atur ulang notifikasi?",
                        action: () {
                          // Navigator.pop(context, true);
                          Get.back(result: true);
                        },
                      );
                    });
                if (lanjut) {
                  // DialogLoading dlg = DialogLoading();
                  // showDialog(
                  //     context: context,
                  //     barrierDismissible: false,
                  //     builder: (context) {
                  //       return dlg;
                  //     }).catchError((err) {
                  //   throw err;
                  // });
                  dialogController.setProgress(LoadingState.progress, "Mohon Tunggu", null, null, null);
                  await Future.delayed(const Duration(milliseconds: 500));
                  UserModel.instance.refreshFCMToken();
                  // Navigator.pop(context);
                  Get.back();
                  // showAlert(context, LoadingState.success,
                  //     "Berhasil atur ulang notifikasi");
                  dialogController.setProgress(LoadingState.success, "Berhasil atur ulang notifikasi", null, null, null); 
                }
              } catch (e) {
                // Navigator.pop(context);
                Get.back();
                dialogController.setProgress(LoadingState.error, translateFromPattern(e.toString()), null, null, null);
                // showAlert(
                //     context, LoadingState.error, translateFromPattern(e));
              }
            },
            title: const Text("Atur ulang notifikasi"),
            subtitle: const Text(
                "Gunakan fitur ini jika kamu merasa tidak mendapatkan notifikasi dari XYZ"),
            trailing: const Icon(
              Icons.chevron_right_outlined,
              size: 28,
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            onTap: () async {
              try {
                bool lanjut = false;
                lanjut = await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return DialogConfirmation(
                        desc: "Yakin ingin membersihkan data?",
                        action: () {
                          Navigator.pop(context, true);
                        },
                      );
                    });
                if (lanjut) {
                  // DialogLoading dlg = DialogLoading();
                  // showDialog(
                  //     context: context,
                  //     barrierDismissible: false,
                  //     builder: (context) {
                  //       return dlg;
                  //     }).catchError((err) {
                  //   throw err;
                  // });
                  dialogController.setProgress(LoadingState.progress, "Mohon Tunggu", null, null, null);
                  await Future.delayed(const Duration(milliseconds: 500));
                  UserModel.instance.clearCache();
                  // Navigator.pop(context);
                  Get.back();
                  // showAlert(context, LoadingState.success,
                  //     "Berhasil membersihkan data", then: (x) {
                  //   Navigator.popUntil(context, ModalRoute.withName("/home"));
                  // });
                  await dialogController.setProgress(LoadingState.success, "Berhasil membersihkan data", null, null, null);
                  Get.until((route) => route.settings.name == "/home");
                  newHomeTabController.tab.value = HomeTab.home;
                  newHomeTabController.tabController.animateTo(0,duration: const Duration(milliseconds: 200),curve:Curves.easeIn);
                }
              } catch (e) {
                // Navigator.pop(context);
                Get.back();
                // showAlert(context, LoadingState.error,
                //     translateFromPattern(e.toString()));
                dialogController.setProgress(LoadingState.error, translateFromPattern(e.toString()), null, null, null);
              }
            },
            title: const Text("Bersihkan semua data"),
            subtitle: const Text(
                "Gunakan fitur ini untuk me-refresh semua data di aplikasi XYZ"),
            trailing: const Icon(
              Icons.chevron_right_outlined,
              size: 28,
            ),
          ),
          const Divider(),
        ],
      ));
  }
}