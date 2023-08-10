import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/function/changeFocus.dart';
import 'package:saham_01_app/function/removeFocus.dart';
import 'package:saham_01_app/controller/editProfileController.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/btnBlock.dart';

final _formKey = GlobalKey<FormState>();

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      appBar: NavTxt(
        title: "Edit Pofile",
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: EditProfileForm(),
      ),
    );
  }
}

class EditProfileForm extends StatelessWidget {
  final EditProfileFormController editFormController = Get.put(EditProfileFormController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white3,
      child: GetBuilder<AppStateController>(
        init: AppStateController(),
        builder: (controller) {
          editFormController.villageCon.text = (controller.users.value.village != controller.usersEdit.value.village ? controller.usersEdit.value.village : controller.users.value.village)!;
          editFormController.villageCon.text = editFormController.villageCon.text == 'null' ? "" : editFormController.villageCon.text;
          return Form(
            key: editFormController.formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: AppColors.black),
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.2,
                        color: AppColors.darkGrey4
                      )
                    ),
                    border: editFormController.borderUsername
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: editFormController.usernameCon,
                  readOnly: editFormController.editOnlyUsername,
                  focusNode: editFormController.usernameFocus,
                  onFieldSubmitted: (term) {
                    removeFocus(context);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppColors.black),
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.3,
                        color: AppColors.darkGrey4
                      )
                    ),
                    border: InputBorder.none
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: editFormController.emailCon,
                  readOnly: true,
                  focusNode: editFormController.emailFocus,
                  onFieldSubmitted: (term) {
                    changeFocus(context, editFormController.emailFocus, editFormController.fullnameFocus);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    labelStyle: TextStyle(color: AppColors.black),
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.3,
                        color: AppColors.darkGrey4
                      )
                    ),
                    border: InputBorder.none
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: editFormController.fullnameCon,
                  focusNode: editFormController.fullnameFocus,
                  onFieldSubmitted: (term) {
                    changeFocus(context, editFormController.fullnameFocus, editFormController.phoneFocus);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'No. Telp',
                    labelStyle: TextStyle(color: AppColors.black),
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.3,
                        color: AppColors.darkGrey4
                      )
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: editFormController.phoneCon,
                  focusNode: editFormController.phoneFocus,
                  onFieldSubmitted: (term) {
                    changeFocus(context, editFormController.phoneFocus, editFormController.address1Focus);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Alamat 1',
                    labelStyle: TextStyle(color: AppColors.black),
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.3,
                        color: AppColors.darkGrey4
                      )
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 3,
                  controller: editFormController.address1Con,
                  focusNode: editFormController.address1Focus,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Alamat 2 (optional)',
                    labelStyle: TextStyle(color: AppColors.black),
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.3,
                        color: AppColors.darkGrey4
                      )
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 3,
                  controller: editFormController.address2Con,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Kode Pos (optional)',
                    labelStyle: TextStyle(color: AppColors.black),
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.2,
                        color: AppColors.darkGrey4
                      )
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  textInputAction: TextInputAction.next,
                  controller: editFormController.zipcodeCon,
                  focusNode: editFormController.zipcodeFocus,
                  onFieldSubmitted: (term) {
                    removeFocus(context);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Kelurahan / Desa',
                    labelStyle: TextStyle(color: AppColors.black),
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.3,
                        color: AppColors.darkGrey4
                      )
                    ),
                    suffixIcon: const Icon(Icons.arrow_right)
                  ),
                  keyboardType: TextInputType.text,
                  readOnly: true,
                  textInputAction: TextInputAction.next,
                  controller: editFormController.villageCon,
                  onTap: () {
                    Get.toNamed("/search/region", arguments: {"step": 1});
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
                BtnBlock(
                  title: "Simpan",
                  onTap: () {
                    editFormController.performSaveProfile(appStateController);
                  },
                ),
                const SizedBox(
                  height: 10
                )
              ],
            ),
          );
        },
      ),
    );
  }
}