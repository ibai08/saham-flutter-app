import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/function/helper.dart';
import 'package:saham_01_app/function/showAlert.dart';
import 'package:saham_01_app/models/user.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/dialogConfirmation.dart';
import 'package:saham_01_app/views/widgets/dialogLoading.dart';

class RefreshPage extends StatelessWidget {
  const RefreshPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavTxt(title: "Bersihkan Cache"),
      body: ListView(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                        Get.back();
                      },
                    );
                  }
                );
                if (lanjut) {
                  DialogLoading dlg = DialogLoading();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return dlg;
                    }
                  ).catchError((err) {
                    throw err;
                  });
                  await Future.delayed(const Duration(milliseconds: 500));
                  UserModel.instance.refreshFCMToken();
                  Get.back();
                  showAlert(
                    context,
                    LoadingState.success,
                    "Berhasil atur ulang notifikasi"
                  );
                }
              } catch (e) {
                Get.back();
                showAlert(
                  context, LoadingState.error,
                  translateFromPattern(e.toString())
                );
              }
            },
            title: const Text("Atur ulang notifikasi"),
            subtitle: const Text(
              "Gunakan fitur ini jika kamu merasa tidak mendapatkan notifikasi dari XYZ"
            ),
            trailing: const Icon(
              Icons.chevron_right_outlined,
              size: 28,
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                    DialogLoading dlg = DialogLoading();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return dlg;
                        }).catchError((err) {
                      throw err;
                    });
                    await Future.delayed(const Duration(milliseconds: 500));
                    UserModel.instance.clearCache();
                    Get.back();
                    showAlert(
                      context, 
                      LoadingState.success, 
                      "Berhasil membersihkan data",
                      thens: (x) {
                        Get.until((route) => route.isFirst);
                      }
                    );
                  }
              } catch (e) {
                Get.back();
                showAlert(context, LoadingState.error, translateFromPattern(e.toString()));
              }
            },
            title: const Text("Bersihkan semua data"),
            subtitle: const Text("Gunakan fitur ini untuk me-refresh semua data di aplikasi XYZ"),
            trailing: const Icon(
              Icons.chevron_right_outlined,
              size: 28,
            ),
          )
        ],
      ),
    );
  }
}