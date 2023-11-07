// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/withdraws_controller.dart';
import 'package:saham_01_app/core/currency.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/custom_dropdown_button.dart';

import '../../../../models/entities/ois.dart';
import '../../../widgets/btn_block.dart';
import '../../../widgets/info.dart';

class Withdraw extends StatelessWidget {
  final WithdrawController controllers = Get.put(WithdrawController());

  Withdraw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavTxt(
        title: "Withdraw",
      ),
      body: GetX<WithdrawController>(
        init: WithdrawController(),
        builder: (controller) {
          if (controller.myChannelController.value == OisMyChannelPageData.init()) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (controller.hasError.value) {
            return SmartRefresher(
                  controller: controller.refreshController,
                  onRefresh: controller.onRefresh,
                  enablePullDown: true,
                  enablePullUp: false,
                  child: Info(
                      // desc: snapshot.error.toString(),
                      onTap: () async {
                    // await getClass();
                    controller.refreshController.requestRefresh();
                  }));
          }
          if (controller.myChannelController.value.listMyChannel?.where((channel) => controller.myChannelController.value.listChannelBalance?["${channel.id}"] > 0).length == 0) {
            return SmartRefresher(
              controller: controller.refreshController,
              onRefresh: controller.onRefresh,
              enablePullDown: true,
              enablePullUp: false,
              child: Info(
                image: Image.asset("assets/icon-cashout-warning.png", width: 50),
                title: "Belum memilki channel bersaldo aktif",
                desc: "Buat channel dan dapatkan subscriber",
                caption: "Buat Channel",
                onTap: () async {
                  Get.offAndToNamed('/dsc/channels/new');
                },
              ),
            );
          }
          return SmartRefresher(
            enablePullUp: false,
            enablePullDown: true,
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: controller.bankCon,
                      decoration: const InputDecoration(
                          labelText: 'Bank',
                          labelStyle: TextStyle(fontWeight: FontWeight.w600),
                          border: InputBorder.none),
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    TextFormField(
                      controller: controller.bankUserNameCon,
                      decoration: const InputDecoration(
                          labelText: 'Atas Nama',
                          labelStyle: TextStyle(fontWeight: FontWeight.w600),
                          border: InputBorder.none),
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    TextFormField(
                      controller: controller.bankNoCon,
                      decoration: const InputDecoration(
                          labelText: 'No. Rekening',
                          labelStyle: TextStyle(fontWeight: FontWeight.w600),
                          border: InputBorder.none),
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    Column(
                      children: <Widget>[
                        DropdownWithLabel<int>(
                          title: "Pilih Channel",
                          label: "Pilih Channel",
                          value: controller.data["channel"],
                          error: controller.trySumbit.value && controller.data["channel"] == null ? "Mohon untuk memilih channel" : null,
                          onChange: (int newValueNo) {
                            controller.data["channel"] = newValueNo;
                          },
                          items: controller.myChannelController.value.listMyChannel?.where((channel) => controller.myChannelController.value.listChannelBalance?["${channel.id}"] > 0).map<DropdownMenuItem<int>>((value) {
                            return DropdownMenuItem<int>(
                              value: value.id,
                              child: Text(value.name! + " (Rp" + NumberFormat("#,###", "ID").format(controller.myChannelController.value.listChannelBalance?["${value.id}"]) + ")"),
                            );
                          }).toList(),
                        ),
                        TextFormField(
                          controller: controller.nominalCon,
                          decoration: InputDecoration(
                            helperText: controller.data["channel"] != null ? "Saldo Aktif : Rp" + NumberFormat("#,###", "ID").format(controller.myChannelController.value.listChannelBalance?["${controller.data["channel"]}"]) : "",
                            labelText: "Nominal",
                            labelStyle: TextStyle(color: AppColors.black),
                            contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.2,
                                color: AppColors.darkGrey4
                              )
                            ),
                            prefixText: "Rp"
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter()
                          ],
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Mohon untuk mengisi nominal";
                            }
                            if (double.parse(val.replaceAll(".", "")) >
                                controller.myChannelController.value.listChannelBalance?["${controller.data["channel"]}"]) {
                              return "Saldo Anda tidak mencukupi";
                            }
                            return null;
                          },
                          onFieldSubmitted: (term) {
                            controller.performWithdrawal(context);
                          },
                          onSaved: (val) {
                            controller.data["nominal"] = val?.replaceAll(".", "");
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    BtnBlock(
                      onTap: () {
                        controller.performWithdrawal(context);
                      },
                      title: "Cash Out",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ),
          );
        },
      ),
    );
  }
}