// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/payment_controller.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/custom_dropdown_button.dart';

class Payment extends StatelessWidget {
  final PaymentController paymentController = Get.put(PaymentController());

  Payment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    paymentController.channel.value = Get.arguments as ChannelCardSlim;
    if (paymentController.channel.value == ChannelCardSlim()) {
      Get.back();
    }
    if (paymentController.channel.value != ChannelCardSlim()) {
      paymentController.channel.value.pricing?.sort((a, b) => a.qty!.compareTo(b.qty!));
    }

    List<ChannelPricing> sPrice = paymentController.duration != 0 ? paymentController.channel.value.pricing!.where((test) => test.qty! <= paymentController.duration).toList().reversed.toList() : [];

    return GetX<PaymentController>(
      init: PaymentController(),
      builder: (paymentController) {
      return Scaffold(
        appBar: NavTxt(
          title: "Pembayaran",
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)]
          ),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const Text(
                "Pembayaran Channels",
                style: TextStyle(
                  fontSize: 18
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Nama Channel',
                    labelStyle: TextStyle(fontWeight: FontWeight.w600),
                    border: InputBorder.none),
                keyboardType: TextInputType.text,
                readOnly: true,
                initialValue: paymentController.channel.value.name,
              ),
              Obx(() {
                return paymentController.channelController.value == [] || paymentController.channelController.value == null ? const Center(
                  child: CircularProgressIndicator(),
                ) : DropdownWithLabel<int>(
                  title: "Metode Pembayaran",
                  label: "Pilih Metode Pembayaran",
                  value: paymentController.metodeDD,
                  error: paymentController.trySubmit.value && paymentController.metodeDD == null ? "Mohon untuk memilih channel Anda" : null,
                  onChange: (int newValueMetode) {
                    paymentController.metodeDD = newValueMetode;
                  },
                  items: paymentController.channelController.value.map<DropdownMenuItem<int>>((PaymentChannels value) {
                    return DropdownMenuItem<int>(
                      value: value.id,
                      child: Text(value.name!),
                    );
                  }).toList(),
                );
              })
            ],
          ),
        ),
      );
    });
  }
}