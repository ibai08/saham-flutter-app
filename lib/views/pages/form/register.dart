import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/views/widgets/login_hint.dart';
import '../../../controller/register_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../core/string.dart';
import '../../../function/change_focus.dart';
import '../../appbar/navtxt.dart';
import '../../widgets/btn_block.dart';
import '../../widgets/line.dart';
import '../../widgets/password_icon.dart';

class Register extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  Register({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 55,
        child: Column(
          children: const [
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
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(child: RegisterForm())),
    );
  }
}

class RegisterForm extends StatelessWidget {
  final RegisterController controller = Get.find();

  RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Obx(
    () {
      return Container(
          color: AppColors.white3,
          child: Form(
            key: controller.formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    labelStyle: TextStyle(color: AppColors.black),
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
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
                  enabled: !controller.isEmailDisabled.value,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppColors.black),
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
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
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    suffixIcon: IconButton(
                        padding: const EdgeInsets.only(top: 20),
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
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    suffixIcon: IconButton(
                        padding: const EdgeInsets.only(top: 20),
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
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
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
                      contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                      labelText: 'Kota Domisili',
                      labelStyle: TextStyle(color: AppColors.black),
                      suffixIcon: const Icon(Icons.arrow_right),
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
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: CheckboxListTile(
                    title: const Text("Saya menyetujui untuk menerima berita terbaru"),
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
                    await controller.performRegister();
                  },
                  title: "DAFTAR",
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
    }
  );
}