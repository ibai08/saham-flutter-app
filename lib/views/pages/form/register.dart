import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/views/widgets/loginHint.dart';
import '../../../controller/registerController.dart';
import '../../../constants/app_colors.dart';
import '../../../core/string.dart';
import '../../../function/changeFocus.dart';
import '../../../function/helper.dart';
import '../../../function/removeFocus.dart';
import '../../../function/showAlert.dart';
import '../../../models/user.dart';
import '../../appbar/navtxt.dart';
import '../../widgets/btnBlock.dart';
import '../../widgets/dialogLoading.dart';
import '../../widgets/line.dart';
import '../../widgets/passwordIcon.dart';

class Register extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 55,
        child: Column(
          children: [
            Line(),
            SizedBox(
              height: 15,
            ),
            LoginHint()
          ],
        ),
      ),
      appBar: NavTxt(
        title: "Daftar",
      ),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(child: RegisterForm())),
    );
  }
}

class RegisterForm extends StatelessWidget {
  final RegisterController controller = Get.find();

  @override
  Widget build(BuildContext context) => Obx(
    () {
      return Container(
          color: AppColors.white3,
          child: Form(
            key: controller.formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    labelStyle: TextStyle(color: AppColors.black),
                    contentPadding: EdgeInsets.only(bottom: 5, top: 20),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.2,
                        color: AppColors.darkGrey4,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  controller: controller.fullnameController,
                  focusNode: controller.fullnameFocus,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Mohon masukkan Nama Lengkap Anda";
                    }
                    return null;
                  },
                  onFieldSubmitted: (term) {
                    changeFocus(context, controller.fullnameFocus, controller.emailFocus);
                  }
                ),
                TextFormField(
                  enabled: !controller.isEmailDisabled,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppColors.black),
                    contentPadding: EdgeInsets.only(bottom: 5, top: 20),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.2,
                        color: AppColors.darkGrey4,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailController,
                  focusNode: controller.emailFocus,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Mohon masukkan Email Anda";
                    }
                    return null;
                  },
                  onFieldSubmitted: (term) {
                    changeFocus(context, controller.emailFocus, controller.passwordFocus);
                  }
                ),
                if (controller.token == '')
                TextFormField(
                  obscureText: controller.seePass.value,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5, top: 20),
                    suffixIcon: IconButton(
                        padding: EdgeInsets.only(top: 20),
                        onPressed: () {
                          controller.togglePass();
                        },
                        icon: PasswordIcon(
                          seePass: controller.seePass.value,
                        )),
                    labelText: 'Kata sandi',
                    labelStyle: TextStyle(color: AppColors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.2,
                        color: AppColors.darkGrey4,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  controller: controller.passwordController,
                  focusNode: controller.passwordFocus,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Mohon masukkan konfirmasi kata sandi Anda";
                    } else if (val.length > 12 || val.length < 6) {
                      return "Password harus diantara 6 - 12 karakter";
                    } else if (val != controller.passwordController.text) {
                      return "Konfirmasi password tidak sama";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    changeFocus(
                        context, controller.passwordFocus, controller.passwordConfirmFocus);
                  }
                ),
                if (controller.token == '')
                TextFormField(
                  obscureText: controller.seePassCon.value,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5, top: 20),
                    suffixIcon: IconButton(
                        padding: EdgeInsets.only(top: 20),
                        onPressed: () {
                          controller.togglePassCon();
                        },
                        icon: PasswordIcon(
                          seePass: controller.seePassCon.value,
                        )),
                    labelText: 'Konfirmasi kata sandi',
                    labelStyle: TextStyle(color: AppColors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.2,
                        color: AppColors.darkGrey4,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  controller: controller.passwordConfirmController,
                  focusNode: controller.passwordConfirmFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    changeFocus(context, controller.passwordConfirmFocus, controller.phoneFocus);
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Mohon masukkan konfirmasi kata sandi Anda";
                    } else if (val.length > 12 || val.length < 6) {
                      return "Password harus diantara 6 - 12 karakter";
                    } else if (val != controller.passwordController.text) {
                      return "Konfirmasi password tidak sama";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5, top: 20),
                    labelText: 'No. Telp',
                    labelStyle: TextStyle(color: AppColors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.2,
                        color: AppColors.darkGrey4,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  controller: controller.phoneController,
                  focusNode: controller.phoneFocus,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Mohon masukkan No. telp Anda";
                    } else if (!validateMobileNumber(val)) {
                      return "No. telp Anda tidak valid";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    changeFocus(context, controller.passwordConfirmFocus, controller.domisiliFocus);
                  }
                ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 5, top: 20),
                      labelText: 'Kota Domisili',
                      labelStyle: TextStyle(color: AppColors.black),
                      suffixIcon: Icon(Icons.arrow_right),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.2,
                          color: AppColors.darkGrey4,
                        ),
                      ),
                    ),
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  controller: controller.domisiliController,
                  onTap: () async {
                    controller.domMap =
                        await Navigator.pushNamed(context, "/search/domisili") as Map;
                    if (controller.domMap != null) {
                      controller.domisiliController.text = controller.domMap?["name"];
                    }
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Mohon pilih Kota Anda";
                    }
                    return null;
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: CheckboxListTile(
                    title: Text("Saya menyetujui untuk menerima berita terbaru"),
                    value: controller.isNewsLetter.value,
                    activeColor: AppColors.primaryGreen,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (val) {
                        controller.isNewsLetter.value = val!;
                    },
                  ),
                ),
                // SizedBox(height: 15),
                BtnBlock(
                  onTap: () async {
                    await performRegister(context);
                  },
                  title: "DAFTAR",
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
    }
  );

  Future<void> performRegister(BuildContext context) async {
    removeFocus(context);
    controller.trySubmit.value = true;

    var valid = false;
    if (controller.formKey.currentState!.validate()) {
      valid = true;
    }
    if (valid) {
      controller.formKey.currentState?.save();
      DialogLoading dlg = DialogLoading();
      try {
        print("TRY UNTUK LOGIN..............");
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return dlg;
            });
        bool result = await UserModel.instance.registerWithCity(
            token: controller.token,
            email: controller.emailController.text,
            name: controller.fullnameController.text,
            password: controller.passwordController.text,
            passconfirm: controller.passwordConfirmController.text,
            phone: controller.phoneController.text,
            city: controller.domMap?["code"],
            subscribe: controller.isNewsLetter.value ? 1 : 0);
        if (result && controller.token == '') {
        print("result && token == ''......... BARIS 129");
          // Navigator.pop(context);
          // Get.back(canPop: true);

          // Get.toNamed('/forms/login');
          // Navigator.pushNamed(context, "/forms/login"); // nyangkut disini
          showAlert(
            context,
            LoadingState.success,
            "Pendaftaran berhasil, silahkan cek email Anda untuk meverifikasi email Anda",
          );
          print("udah alert");
          // return true;
        } else if (controller.token != '') {
        print("token != ''............. BARIS 139");

          // Navigator.popUntil(context, ModalRoute.withName("/home"));
          // Get.until((route) => route.settings.name == '/home');
          showAlert(
            context,
            LoadingState.success,
            "Pendaftaran berhasil",
          );
          // return true;
        }
      } catch (e, stack) {
        print(e);
        print(stack);
        Navigator.pop(context);
        showAlert(context, LoadingState.error, translateFromPattern(e.toString()));
      }
      // return false;
    }
    // return null;
  }
}