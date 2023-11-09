import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/constants/app_colors.dart';

import '../../../appbar/navtxt.dart';
import '../../../widgets/badge.dart';
import '../../../widgets/pull_left_right.dart';

class PaymentDetails extends StatelessWidget {
  final Map<String, dynamic> paymentDetail = {
    "id": "PY000000009",
    "channel_name": "Nama Channel",
    "channel_author": "Channel Author",
    "time": "21:38",
    "date": "2019-06-24",
    "payment_method": "BCA Virtual Account",
    "amount": 25000,
    "unit": 3,
    "fee": 7500,
  };

  PaymentDetails({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int totalPayment = paymentDetail["amount"] * paymentDetail["unit"];
    num total = totalPayment - paymentDetail["fee"];
    return Scaffold(
      appBar: NavTxt(
        title: "Payment Detail",
      ),
      body: ListView(
        shrinkWrap: true,
        padding:const EdgeInsets.symmetric(vertical: 10),
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Badge(
                    size: 14,
                    text: "Payment Success",
                    bgColor: AppColors.primaryGreen,
                  ),
                ]),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              title: Text(paymentDetail["channel_name"]),
              subtitle: Text("By: " + paymentDetail["channel_author"]),
              leading: Image.asset("assets/tf-icon.png"),
            ),
          ),
         const Divider(),
          Container(
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Detail Transaksi:"),
                  PullLeftRight(
                    title: "Time",
                    desc: paymentDetail["time"],
                  ),
                  PullLeftRight(
                    title: "Date",
                    desc: paymentDetail["date"],
                  ),
                  PullLeftRight(
                    title: "Transaction ID",
                    desc: paymentDetail["id"],
                  ),
                ],
              )),
          const Divider(),
          Container(
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Payment Detail:"),
                  PullLeftRight(
                    title: "Payment Method",
                    desc: paymentDetail["payment_method"],
                  ),
                  PullLeftRight(
                    title: "Billing Amount",
                    desc: NumberFormat.currency(symbol: "Rp ", decimalDigits: 0)
                        .format(123213),
                  ),
                  PullLeftRight(
                    title: "Unit",
                    desc: paymentDetail["unit"].toString(),
                  ),
                  PullLeftRight(
                    isBoldTitle: true,
                    title: "Total Payment",
                    desc: "Rp " + totalPayment.toString(),
                  ),
                  const Divider(),
                  PullLeftRight(
                    title: "Fee Amount",
                    desc: "(Rp " + paymentDetail["fee"].toString() + ")",
                  ),
                  PullLeftRight(
                    title: "Amount",
                    desc: "Rp " + total.toString(),
                  ),
                ],
              )),
          const Divider(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigator.pop(context);
                Get.back();
              },
              child: const Text("Kembali"),
            ),
          )
        ],
      ),
    );
  }
}