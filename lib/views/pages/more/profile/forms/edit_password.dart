import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/edit_password_controller.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/password_icon.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../function/change_focus.dart';
import '../../../../widgets/btn_block.dart';

class EditPassword extends StatelessWidget {
  final EditPasswordController controller = Get.put(EditPasswordController());

  EditPassword({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white3,
      appBar: NavTxt(
        title: "Ganti Kata Sandi",
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: EditPassWordForm(),
      ),
    );
  }
}

class EditPassWordForm extends StatelessWidget {
  final EditPasswordController controller = Get.find();

  EditPassWordForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: <Widget>[
              TextFormField(
                controller: controller.oldPassController,
                focusNode: controller.oldPassFocus,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.toggleOldPassVisibility();
                    },
                    icon: PasswordIcon(
                      seePass: controller.seePassOld.value,
                    ),
                  ),
                  labelText: 'Kata Sandi Lama',
                  labelStyle: TextStyle(color: AppColors.black)
                ),
                keyboardType: TextInputType.text,
                obscureText: controller.seePassOld.value,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Mohon masukkan kata sandi lama anda";
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  changeFocus(context, controller.oldPassFocus, controller.oldPassFocus);
                },
                onSaved: (val) {
                  controller.data["old_pass"] = val;
                },
              ),
              TextFormField(
                controller: controller.newPassController,
                focusNode: controller.newPassFocus,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.togglePassVisibility();
                    },
                    icon: PasswordIcon(
                      seePass: controller.seePass.value,
                    ),
                  ),
                  labelText: 'Kata Sandi Baru',
                  labelStyle: TextStyle(color: AppColors.black)
                ),
                keyboardType: TextInputType.text,
                obscureText: controller.seePass.value,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Mohon masukkan kata sandi baru anda";
                  } else if (val.length > 16 || val.length < 4) {
                    return "Password harus diantara 4 - 16 karakter";
                  }
                  return null;
                },
                onFieldSubmitted: (term) {
                  changeFocus(context, controller.newPassFocus, controller.newPassFocus);
                },
                onSaved: (val) {
                  controller.data["new_pass"] = val;
                },
              ),
              TextFormField(
                controller: controller.confirmPassController,
                focusNode: controller.confirmPassFocus,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.toggleConfirmPassVisibility();
                    },
                    icon: PasswordIcon(
                      seePass: controller.seePassCon.value,
                    ),
                  ),
                  labelText: 'Konfirmasi Kata Sandi Baru',
                  labelStyle: TextStyle(color: AppColors.black)
                ),
                keyboardType: TextInputType.text,
                obscureText: controller.seePassCon.value,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Mohon masukkan konfirmasi kata sandi baru Anda";
                  } else if (val.length > 16 || val.length < 4) {
                    return "Password harus diantara 4 - 16 karakter";
                  } else if (val != controller.confirmPassController.text) {
                    return "Konfirmasi password tidak sama";
                  }
                  return null;
                },
                onFieldSubmitted: (temp) async {
                  await controller.changePassword(context);
                },
                onSaved: (val) {
                  controller.data["confirm_new_pass"] = val;
                },
              ),
              const SizedBox(
                height: 35,
              ),
              BtnBlock(
                onTap: () async {
                  await controller.changePassword(context);
                },
                title: "Simpan",
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      }
    );
  }
}