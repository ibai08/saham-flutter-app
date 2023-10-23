// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/controller/app_state_controller.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/function/helper.dart';
import 'package:saham_01_app/function/remove_focus.dart';
import 'package:saham_01_app/function/show_alert.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/entities/user.dart';
import 'package:saham_01_app/models/ois.dart';
import 'package:saham_01_app/views/widgets/dialog_confirmation.dart';
import 'package:saham_01_app/views/widgets/dialog_loading.dart';

class NewChannelsFormController extends GetxController {
  final TextEditingController txtChannel = TextEditingController();
  final TextEditingController txtHarga = TextEditingController();
  final TextEditingController txtBank = TextEditingController();
  final TextEditingController txtBankNo = TextEditingController();
  final TextEditingController txtBankUser = TextEditingController();
  final TextEditingController accountCon = TextEditingController();
  
  final FocusNode txtBankFocus = FocusNode();
  final FocusNode txtBankNoFocus = FocusNode();
  final FocusNode txtBankUserFocus = FocusNode();

  RxInt? streamNom = 0.obs;
  RxMap<dynamic, dynamic> streamAcc = {}.obs;
  Rx<List?> listBankStream = Rx<List?>(null);
  Rx<ChannelCardSlim?> channels = Rx<ChannelCardSlim?>(null);
  

  late BuildContext context;

  List month = [3, 6, 12];
  List<ChannelPricing> priceList = [];

  Widget radioAcc = const SizedBox();
  Widget formAcc = const SizedBox();

  Widget nominal = const Text("");
  RxString dropdownValue = "".obs;
  File? image;

  final ImagePicker picker = ImagePicker();
  int channel = 0;

  Map data = {};

  RxBool trySumbit = false.obs;

  AppStateController appStateController = Get.find();

  UserInfo? user;

  late GlobalKey<FormState> formKey;

  String formatter(double val) {
    NumberFormat formatter = NumberFormat("#,###", "ID");
    return formatter.format(val);
  }

  Future openCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      Get.back();
    }
  }

  Future openFile() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      Get.back();
    }
  }

  Future<void> optionsDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          titlePadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: const Text('Foto'),
                  ),
                  onTap: openCamera,
                ),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: const Text('Galeri'),
                  ),
                  onTap: openFile,
                )
              ],
            ),
          ),
        );
      }
    );
  }

  RxMap accList = {"rdAcc": 0, "wantConnect": false}.obs;
  RxBool isPriceHasError = true.obs;

  void handlePickAcc(int? val) {
    if (accList["rdAcc"] != val) {
      accountCon.clear();
      removeFocus(context);
    }
    accList["rdAcc"] = val;
    streamAcc = accList;
  }

  void handleRadioValueChangeNominal(int? value) {
    if (value == 0) {
      data["harga"] = 0.00;
    } else {
      data["harga"] = double.tryParse(txtHarga.text.replaceAll(".", ""));
    }
    streamNom?.value = value!;
  }

  void prepareForm() async {
    if (channels.value?.id != null) {
      channels.value = await ChannelModel.instance.getDetail(channels.value?.id);
      priceList = channels.value!.pricing!;
      txtChannel.text = channels.value?.price == null ? "" : channels.value!.name!;
      txtHarga.text = channels.value?.price == null ? "" : formatter(channels.value!.price!);
      streamNom?.value = channels.value?.price == null || channels.value?.price == 0 ? 0 : 1;
      if (remoteConfig.getInt("can_paid_channel") == 1 && channels.value!.price! > 0) {
        handleRadioValueChangeNominal(1);
      } else {
        data["harga"] = 0.00;
      }

      if (channels.value?.account != null) {
        accList["wantConnect"] = true;
        accList["rdAcc"] = channels.value!.real! ? 1 : 0;
        accountCon.text = channels.value!.account!;
        streamAcc = accList;
      }
    }
  }

  void createChannel() async {
    trySumbit.value = true;
    removeFocus(context);

    var valid = false;
    if (formKey.currentState!.validate() && (user?.bankName != "null" || data["bankName"] != null) && isPriceHasError.value) {
      valid = true;
    }

    if (valid) {
      formKey.currentState?.save();
      int monthChange = remoteConfig.getInt("ois_can_change_channel_price_month");
      if (channels.value?.id != null && monthChange > 0 && data["harga"] != channels.value?.price) {
        bool result = await showDialog(
          barrierDismissible:  false,
          context: context,
          builder: (BuildContext context) {
            return DialogConfirmation(
              title: "Konfirmasi",
              desc: "Setelah melakukan konfirmasi, Anda tidak dapat mengubah harga channel selama $monthChange bulan.",
            );
          }
        );
        if (!result) {
          return;
        }
      }
      DialogLoading dlg = DialogLoading();
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return dlg;
        }
      );
      Future.delayed(Duration.zero).then((_) async {
        try {
          String message = "Sukses membuat channel baru";
          if (channels.value?.id == null) {
            await ChannelModel.instance.createChannel(
              name: data["nama"],
              harga: data["harga"],
              bankName: data["bankName"],
              bankOwner: data["bankUsername"],
              bankRekening: data["bankNumber"],
              caption: "",
              real: data["real"],
              account: data["account"],
              pricing: priceList
            );
          } else {
            await ChannelModel.instance.updateChannel(
              id: channels.value!.id,
              name: data["nama"],
              harga: data["harga"],
              bankName: data["bankName"],
              bankOwner: data["bankUsername"],
              bankRekening: data["bankNumber"],
              real: data["real"],
              account: data["account"],
              pricing: priceList
            );
            if (image != null) {
              await ChannelModel.instance.uploadAvatarChannel(
                image: image, channelid: channels.value!.id
              );
            }
            message = "Sukses mengubah channel";
          }
          await OisModel.instance.synchronizeMyChannel(clearCache: true);
          Get.offAllNamed("/dsc/channels/info", predicate: ModalRoute.withName("/home"), arguments: {"dialog": message, "state": LoadingState.success});
        } catch(e) {
          Get.back(canPop: true);
          showAlert(context, LoadingState.error, translateFromPattern(e.toString()));
        }
      });
    }
  }

  void handleWantConnect(bool val) {
    if (accList["wantConnect"] != val) {
      data["real"] = null;
      data["account"] = null;
      accountCon.clear();
      removeFocus(context);
    }
    accList["wantConnect"] = val;
    streamAcc = accList;
  }

  @override
  void onInit() {
    super.onInit();
    try {
      user = appStateController.users.value;
      handleRadioValueChangeNominal(0);
      prepareForm();
      // txtBank.text = user?.bankName != null || user?.bankName != "null" ? user!.bankName! : "";
      // txtBankNo.text = user?.bankNumber ?? "";
      // txtBankUser.text = user?.bankUsername != "null" || user?.bankUsername != null ? user!.bankUsername! : "";
      if (user?.bankName != null || user?.bankName != "null") {
        txtBank.text = user!.bankName!;
      } else {
        txtBank.text = "";
      }
      if (user?.bankNumber != null || user?.bankNumber != "null") {
        txtBankNo.text = user!.bankNumber!;
      } else {
        txtBankNo.text = "";
      }
      if (user?.bankUsername != "null" || user?.bankUsername != null) {
        txtBankUser.text = user!.bankUsername!;
      } else {
        txtBankUser.text = "";
      }
      streamAcc = accList;
      data["bankName"] = null;

      OisModel.instance.getBanks().then((banks) {
        listBankStream.value = banks;
      });
      
    } catch (e, stack) {
      print("erorrss: $e");
      print("erros stack: $stack");
    }
  }
}