import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/forgetPasswordController.dart';

import '../../appbar/navtxt.dart';
import '../../widgets/btnBlock.dart';
import '../../widgets/logo.dart';

class ForgotPassWord extends StatelessWidget {
  final ForgotPassController controller = Get.put(ForgotPassController());

  ForgotPassWord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavTxt(
        title: "Lupa Password",
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const LogoDom(),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Lupa Password",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Silahkan masukkan alamat email Anda,\n untuk menerima email verifikasi",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: controller.emailCon,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.2,
                        color: AppColors.darkGrey4,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Mohon untuk mengisi email Anda";
                    }
                    return null;
                  },
                  onFieldSubmitted: (term) {
                    controller.performReset(context);
                  },
                  onSaved: (val) {
                    controller.data["email"] = val;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                BtnBlock(
                  onTap: () {
                    controller.performReset(context);
                  },
                  title: "Reset Password",
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}