// ignore_for_file: prefer_conditional_assignment, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/app_state_controller.dart';
import 'package:saham_01_app/controller/new_channel_form_controller.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/function/change_focus.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/mrg.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/btn_block.dart';
import 'package:saham_01_app/views/widgets/channel_avatar.dart';
import 'package:saham_01_app/views/widgets/custom_dropdown_button.dart';
import 'package:saham_01_app/views/widgets/default_image.dart';
import 'package:saham_01_app/views/widgets/image_from_network.dart';

import '../../../../core/currency.dart';

class NewChannels extends StatelessWidget {
  final AppStateController appStateController = Get.find<AppStateController>();

  final NewChannelsFormController controller = Get.put(NewChannelsFormController());  

  NewChannels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    ChannelCardSlim channel = ChannelCardSlim();
    if (arguments != null) {
      print("arguments: $arguments");
      if (arguments is Map) {
        channel = arguments['channel'];
        controller.channels.value = channel;
      }
      if (arguments is ChannelCardSlim) {
        channel = arguments;
        controller.channels.value = channel;
        print("kena ini: ${ controller.channels.value?.id}");
        print(controller.channels.value?.id == null ? false : true);
      }
    }
    controller.context = context;
    Future.delayed(const Duration(milliseconds: 0)).then((_) {
      if (appStateController.users.value.id > 0 && !appStateController.users.value.isProfileComplete()) {
        Get.offAndToNamed("/forms/editprofile", arguments: {
          "route": "/dsc/channels/new",
          "arguments": channel
        });
      } else if (appStateController.users.value.id < 1 || !appStateController.users.value.verify!) {
        Get.offAndToNamed("/forms/editprofile", arguments: {
          "route": "/dsc/channels/new",
          "arguments": channel
        });
      }
    });

    return Scaffold(
      appBar: NavTxt(
        title: controller.channels.value?.id == null ? "Buat Channel" : "Edit Channel",
      ),
      body: NewChannelsForm(channel: controller.channels.value),
    );
  }
}

class NewChannelsForm extends StatelessWidget {
  final ChannelCardSlim? channel;
  NewChannelsForm({Key? key, this.channel}) : super(key: key);

  final controller = Get.find<NewChannelsFormController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    controller.formKey = formKey;
    controller.isPriceHasError.value = true;
    return Container(
      color: AppColors.white,
      child: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
          children: <Widget>[
            Column(
              children: <Widget>[
                channel?.id != null ? Column(
                  children: [
                    const SizedBox(height: 25),
                    Obx(() {
                      // print(channel?.id == null ? false : true);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                controller.optionsDialogBox();
                              },
                              child: controller.image.value == null ? ImageFromNetwork(
                                channel?.avatar,
                                defaultImage: const ChannelAvatar(
                                  width: 120,
                                ),
                                width: 120,
                              ) : DefaultImage(
                                option: "1",
                                tex: controller.image.value,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.optionsDialogBox();
                              },
                              child: Image.asset(
                                "assets/icon-pencil-green.png",
                                width: 20,
                              ),
                            )
                          ],
                        );
                      }
                    )
                  ],
                ) : const SizedBox(),
                TextFormField(
                  controller: controller.txtChannel,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.2,
                        color:  AppColors.darkGrey4
                      )
                    ),
                    labelText: "Nama Channel",
                    labelStyle: TextStyle(
                      color: AppColors.black
                    )
                  ),
                  keyboardType: TextInputType.text,
                  readOnly: controller.channels.value?.id == null ? false : true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Mohon untuk mengisi nama channel";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    controller.data["nama"] = val;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Harga",
                    style: TextStyle(fontSize: 12, color: AppColors.darkGrey3),
                    textAlign: TextAlign.left,
                  ),
                ),
                Obx(() {
                  if (controller.streamNom?.value == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  switch (controller.streamNom?.value) {
                    case 0: 
                      controller.nominal = const SizedBox();
                      break;
                    case 1:
                      controller.nominal = remoteConfig.getInt("can_paid_channel") == 1 ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: controller.txtHarga,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(bottom: 5, top: 20),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0.2,
                                  color: AppColors.darkGrey4,
                                ),
                              ),
                              prefix: const Text("Rp "),
                              labelText: 'Harga per bulan',
                              labelStyle:
                                  TextStyle(color: AppColors.black),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyInputFormatter()
                            ],
                            keyboardType: TextInputType.number,
                            onSaved: (val) {
                              controller.data["harga"] = double.parse(
                                  val!.replaceAll(".", ""));
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Mohon masukkan harga";
                              } else if (double.tryParse(
                                      val.replaceAll(".", "")) ==
                                  null) {
                                return "Harga hanya boleh angka";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          remoteConfig.getInt("channel_pricing") == 1 ? Column(
                            children: [
                              ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.priceList.length,
                                itemBuilder: (context, i) {
                                  ChannelPricing dat = controller.priceList[i];
                                  if (dat.qty == null) {
                                    dat.qty = controller.month[i];
                                  }
                                  String? error = controller.priceList.where((price) => price.qty == dat.qty).toList().length > 1 ? "Mohon untuk memilih bulan yang berbeda" : controller.trySumbit.value && dat.qty == null ? "Mohon untuk memilih Instrument" : null;
                                  if (i == 0) {
                                    controller.isPriceHasError.value = true;
                                  }
                                  if (dat.price == 0) {
                                    controller.isPriceHasError.value = false;
                                    if (controller.trySumbit.value) {
                                      error = "Mohon masukkan harga per periode";
                                    }
                                  } else if (double.tryParse(dat.price!.toStringAsFixed(0).replaceAll(".", "")) == null && controller.trySumbit.value) {
                                    controller.isPriceHasError.value = false;
                                    if (controller.trySumbit.value) {
                                      error = "Harga hanya boleh angka";
                                    }
                                  }

                                  if (controller.priceList.length > 0 && error == null) {
                                    if (dat.price! > 0) {
                                      var temp = dat.price! / dat.qty! >= double.tryParse(controller.txtHarga.text.replaceAll(".", ""))!;
                                      if (temp) {
                                        controller.isPriceHasError.value = false;
                                        if (controller.trySumbit.value) {
                                          error = "Harga periode harus lebih";
                                        }
                                      }
                                    }
                                    for (var m in controller.priceList) {
                                      if (m.qty != null) {
                                        if (m.qty! < dat.qty! && m.price! / m.qty! < dat.price! / dat.qty!) {
                                          controller.isPriceHasError.value = false;
                                          if (controller.trySumbit.value) {
                                            error = "Harga periode ini harus lebih kecil dari periode sebelumnya";
                                          }
                                        }
                                      }
                                    }
                                  }

                                  return Column(
                                    children: <Widget>[
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Expanded(
                                            flex: 2,
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                "Periode",
                                                style: TextStyle(
                                                  color: Colors.black
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Text(
                                              "Harga total ${dat.qty} bulan",
                                              style: const TextStyle(
                                                color: Colors.black
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: DropdownButton<int>(
                                              isExpanded: true,
                                              isDense: false,
                                              icon: const Icon(Icons.arrow_drop_down),
                                              iconSize: 18,
                                              elevation: 12,
                                              hint: Text(
                                                dat.qty.toString(),
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                              onChanged: (newValue) {
                                                dat.qty = newValue;
                                              },
                                              underline: Container(
                                                height: 1,
                                                color: error != null ? Colors.redAccent : Colors.grey,
                                              ),
                                              value: dat.qty,
                                              items: controller.month.map<DropdownMenuItem<int>>((value) {
                                                return DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Text(
                                                    value.toString(),
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Container(
                                              margin: const EdgeInsets.only(bottom: 9),
                                              padding: const EdgeInsets.only(left: 15),
                                              child: TextFormField(
                                                initialValue: dat.price == 0 ? '' : controller.formatter(dat.price!),
                                                decoration: const InputDecoration(
                                                  prefix: Text(
                                                    "Rp ",
                                                  ),
                                                  hintText: "Masukkan Harga per Periode",
                                                  errorStyle: TextStyle(
                                                    height: 0
                                                  ),
                                                  labelStyle: TextStyle(
                                                    fontWeight: FontWeight.w600
                                                  )
                                                ),
                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly, CurrencyInputFormatter()],
                                                keyboardType: TextInputType.number,
                                                onChanged: (val) {
                                                  dat.price = double.parse(val.replaceAll(".", ""));
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: IconButton(
                                              padding: const EdgeInsets.only(top: 10),
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                controller.priceList.removeAt(i);
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          error ?? '',
                                          style: TextStyle(
                                            color: Colors.redAccent.shade700,
                                            fontSize: 12.0,
                                            height: error != null ? 2 : 0
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                              controller.priceList.length < 3 ? TextButton(
                                onPressed: () {
                                  if (controller.priceList.length < 3) {
                                    controller.priceList.add(ChannelPricing(
                                      qty: null,
                                      price: 0
                                    ));
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent
                                ),
                                child: Text(
                                  "Tambah Harga +",
                                  style: TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ) : const SizedBox()
                            ],
                          ) : const SizedBox()
                        ],
                      ) : const SizedBox();
                      break;
                  }
                  int rdValue = controller.streamNom?.value == 0 ? 0 : controller.streamNom!.value;
                  return Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              activeColor: AppColors.primaryGreen,
                              value: 0,
                              dense:  true,
                              groupValue: rdValue,
                              onChanged: controller.handleRadioValueChangeNominal,
                              title: const Text("Gratis"),
                            ),
                          ),
                          remoteConfig.getInt("can_paid_channel") == 1 ? Expanded(
                            child: RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              activeColor: AppColors.primaryGreen,
                              value: 1,
                              dense:  true,
                              groupValue: rdValue,
                              onChanged: controller.handleRadioValueChangeNominal,
                              title: const Text("Berbayar"),
                            ),
                          ) : const SizedBox()
                        ],
                      ),
                      controller.nominal
                    ],
                  );
                }),
                /// TODOs: balikin value nya menjadi 1 lagi kalau udah testing
                remoteConfig.getInt("can_link_mt4_to_channel") == 1 ? Obx(() {
                  if (controller.streamAcc == {}) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  bool checkTile = controller.streamAcc["wantConnect"];
                  int rdAcc = controller.streamAcc["rdAcc"];
                  return Column(
                    children: <Widget>[
                      SwitchListTile(
                        value: checkTile,
                        onChanged: (x) {
                          controller.handleWantConnect(x);
                        },
                        dense: true,
                        title: const Text("Hubungkan channel ini dengan account MT4"),
                      ),
                      checkTile ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: RadioListTile(
                              value: 0,
                              dense: true,
                              groupValue: rdAcc,
                              onChanged: controller.handlePickAcc,
                              title: const Text("Demo Account"),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              value: 1,
                              dense: true,
                              groupValue: rdAcc,
                              onChanged: controller.handlePickAcc,
                              title: const Text("Real Account"),
                            ),
                          ),
                        ],
                      ) : const SizedBox(),
                      checkTile ? TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Account',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600
                          ),
                          suffixIcon: Icon(Icons.arrow_right)
                        ),
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Account tidak boleh kosong";
                          }
                          return null;
                        },
                        controller: controller.accountCon,
                        onSaved: (val) {
                          controller.data["real"] = rdAcc;
                          controller.data["account"] = val;
                        },
                        onTap: () async {
                          final result = await Get.toNamed("/search/mt4mrg", arguments: {
                            "type": rdAcc == 1 ? MrgModel.realAcc : MrgModel.demoAcc
                          });

                          if (result != null && result is String) {
                            controller.accountCon.text = result;
                            controller.formKey.currentState?.validate();
                          }
                        },
                      ) : const SizedBox(),
                    ]
                  );
                }) : const SizedBox(),
                controller.user?.bankName == "null" ? Obx(() {
                  if (!controller.listBankStream.value!.isNotEmpty || controller.listBankStream.value == null) {
                    return const SizedBox();
                  }
                  return DropdownWithLabel(
                    title: "Pilih Bank",
                    label: "Pilih Bank",
                    error: controller.trySumbit.value && controller.data["bankName"] == null ? "Mohon untuk memilih bank Anda" : null,
                    value: controller.dropdownValue.value,
                    onChange: (String newValue) {
                      controller.dropdownValue.value = newValue;
                      controller.data["bankName"] = newValue;
                    },
                    items: controller.listBankStream.value?.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                }) : const SizedBox(
                  height: 0,
                ),
                controller.user?.bankNumber == "null" ? TextFormField(
                  readOnly: controller.user?.bankNumber == "null" ? false : true,
                  controller: controller.txtBankNo,
                  focusNode: controller.txtBankNoFocus,
                  decoration: InputDecoration(
                    labelText: "No Rekening",
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600
                    ),
                    border: controller.user?.bankName != "null" ? InputBorder.none : const UnderlineInputBorder()
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    changeFocus(context, controller.txtBankNoFocus, controller.txtBankUserFocus);
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Mohon untuk mengisi no rekening";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    controller.data["bankNumber"]  = val;
                  },
                ) : const SizedBox(height: 0),
                controller.user?.bankName == "null" ? TextFormField(
                  readOnly: controller.user?.bankUsername == "null" ? false : true,
                  controller: controller.txtBankUser,
                  focusNode: controller.txtBankUserFocus,
                  decoration: InputDecoration(
                    labelText: "Nama Pemilik",
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    border: controller.user?.bankName != "null" ? InputBorder.none : const UnderlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (term) {
                    controller.createChannel();
                  },
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Mohon untuk mengisi nama pemilik";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    controller.data["bankUsername"] = val;
                  },
                ) : const SizedBox(
                  height: 0,
                ),
                const SizedBox(
                  height: 15,
                ),
                BtnBlock(
                  onTap: controller.createChannel,
                  title: controller.channels.value?.id == null ? "Buat Channel" : "Simpan Perubahan",
                )
              ],
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}