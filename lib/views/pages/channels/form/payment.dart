// ignore_for_file: unnecessary_null_comparison, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/controller/payment_controller.dart';
import 'package:saham_01_app/core/webview.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/ois.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/custom_dropdown_button.dart';
import 'package:saham_01_app/views/widgets/get_alert.dart';

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
              }),
              Obx(() {
                if (paymentController.durController.value != null && paymentController.durController.value.length == 1) {
                  paymentController.duration = paymentController.durController.value[0].value!;
                }
                return paymentController.durController.value == null ? const Center(
                  child: CircularProgressIndicator(),
                ) : paymentController.durController.value.length == 1 ? Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Lama Berlangganan',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600
                      ),
                      border: InputBorder.none
                    ),
                    keyboardType: TextInputType.text,
                    readOnly: true,
                    initialValue: "${paymentController.durController.value[0].name}",
                  ),
                ) : DropdownWithLabel(
                  title: "Lama Berlangganan",
                  label: "Pilih Durasi Berlangganan",
                  value: paymentController.duration,
                  error: paymentController.trySubmit.value && paymentController.duration == null ? "Mohon untuk memilih channel Anda" : null,
                  onChange: (int newValuePembayaran) {
                    paymentController.duration = newValuePembayaran;
                  },
                  items: paymentController.durController.value.map<DropdownMenuItem<int>>((PaymentDurationInMonths dur) {
                    return DropdownMenuItem<int>(
                      value: dur.value,
                      child: Text(dur.name!),
                    );
                  }).toList(),
                );
              })
            ],
          ),
        ),
        bottomSheet: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: ListTile(
                  title: Text(
                    "Total Pembayaran",
                    style: TextStyle(
                      fontSize: 14
                    ),
                  ),
                  subtitle: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        sPrice.length > 0 ? Text(
                          (paymentController.duration != null ? NumberFormat.currency(
                            decimalDigits: 0, symbol: "Rp "
                          ).format(paymentController.duration * paymentController.channel.value.price!) : "Rp -").toString(),
                          softWrap: false,
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.red,
                            fontSize: 14
                          ),
                        ) : const SizedBox(height: 15),
                        Text(
                          (paymentController.duration != null ? NumberFormat.currency(
                            decimalDigits: 0,
                            symbol: "Rp "
                          ).format((sPrice.length > 0 ? sPrice[0].price! / sPrice[0].qty! : paymentController.channel.value.price)! * paymentController.duration) : "Rp -").toString(),
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 21,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 20,
                  child: VerticalDivider(
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.only(right: 15),
                  child: ElevatedButton(
                    onPressed: () async {
                      paymentController.trySubmit.value = true;
                      if (paymentController.metodeDD != null && paymentController.duration != null) {
                        Get.find<DialogController>().setProgress(LoadingState.progress, "Mohon Tunggu", null, null, null);
                        try {
                          Map res = await OisModel.instance.confirmPayment(paymentController.channel.value, paymentController.duration, paymentController.metodeDD);

                          Get.back();
                          Get.offAndToNamed('/dsc/payment/status', arguments: {"billNo": res["id"]});
                          webView.open(url: res["url"]);
                        } catch(ex) {
                          print(ex);
                          if (ex is Map && ex.containsKey("bill_no")) {
                            Get.back();
                            Get.offAndToNamed('/dsc/payment/status', arguments: {"billNo": ex["bill_no"]});
                          } else {
                            Get.back();
                            Get.find<DialogController>().setProgress(LoadingState.error, ex.toString(), null, null, null);
                          }
                        }
                      }
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.green[700]),
                    child: const Text(
                      "Bayar",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}