import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class ListTileHistory extends StatelessWidget {
  const ListTileHistory(
      {this.date,
      this.amount,
      this.status,
      this.type,
      this.no,
      Key? key,
      this.symbol})
      : super(key: key);

  final String? date;
  final double? amount;
  final dynamic status;
  final dynamic type;
  final dynamic no;
  final String? symbol;

  @override
  Widget build(BuildContext context) {
    var statusText;
    switch (status) {
      case 0:
        statusText = Text(
          "Pending",
          style: TextStyle(fontSize: 16.0, color: AppColors.primaryYellow),
        );
        break;
      case 2:
        statusText = const Text(
          "Declined",
          style: TextStyle(fontSize: 16.0, color: Colors.red),
        );
        break;
      case 1:
        statusText = Text(
          "Completed",
          style: TextStyle(fontSize: 16.0, color: AppColors.primaryGreen),
        );
        break;
    }
    var typeText;
    var amountText;
    switch (type) {
      case 0:
      case 1:
        amountText = Text(
          NumberFormat.currency(symbol: symbol, decimalDigits: 0)
              .format(amount),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        );
        typeText = Text(
          "Deposit to $no",
          style: const TextStyle(fontSize: 14.0),
        );
        break;
      case 2:
        amountText = Text(
          NumberFormat.currency(symbol: symbol).format(amount),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        );
        typeText = Text(
          "Withdrawal from $no",
          style: const TextStyle(fontSize: 14.0),
        );
        break;
    }
    var dateText = date?.split(" ");
    dateText?[1] = dateText[1].split(".")[0];

    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[300]!))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                amountText,
                SizedBox(
                  height: 1,
                ),
                statusText,
                typeText,
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(dateText![0]),
                Text(dateText[1]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}