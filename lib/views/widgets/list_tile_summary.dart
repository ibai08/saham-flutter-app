// ignore_for_file: prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/models/entities/ois.dart';

class ListTileSummary extends StatelessWidget {
  final String? tid;
  final String? no;
  final String? description;
  final double? amount;
  final double? comm;
  final double? adminFee;
  final DateTime? date;
  final TransactionStatus? status;
  final TransactionType? type;

  const ListTileSummary({Key? key, this.tid, this.no, this.description, this.amount, this.comm, this.adminFee, this.date, this.status, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statusText;
    Color tidWidgetColor = Colors.green[700]!;
    switch (status) {
      case TransactionStatus.waiting:
        statusText = Text(
          "Waiting",
          style: TextStyle(
            fontSize: 16.0,
            color: AppColors.primaryYellow
          ),
        );
        break;
      case TransactionStatus.refused:
        statusText = const Text(
          "Refused",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.red
          ),
        );
        break;
      case TransactionStatus.success:
        statusText = Text(
          "Success",
          style: TextStyle(
            fontSize: 16.0,
            color: AppColors.primaryGreen
          ),
        );
        break;
      default:
        break;
    }
    var typeText;
    var amountText;
    switch (type) {
      case TransactionType.subscribePayment:
        amountText = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              NumberFormat.currency(symbol: "Rp ", decimalDigits: 0).format(amount),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0
              ),
            ),
            Text(
              '(System Fee: ${NumberFormat.currency(symbol: "-RP ", decimalDigits: 0).format(comm != null ? comm : 0)})',
              style: const TextStyle(
                fontSize: 12
              ),
            ),
            Text(
              '(Bank Adm.: ${NumberFormat.currency(symbol: "-Rp ", decimalDigits: 0).format(adminFee != null ? adminFee: 0)})',
              style: const TextStyle(
                fontSize: 12
              ),
            )
          ],
        );
        typeText = Text(
          "Payment from $no",
          style: const TextStyle(fontSize: 12),
        );
        break;
      case TransactionType.withdraw:
        amountText = Text(
          NumberFormat.currency(symbol: "-Rp ", decimalDigits: 0)
              .format(amount),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        );
        typeText = Text(
          "Cash Out to $no",
          style: const TextStyle(fontSize: 12),
        );
        tidWidgetColor = Colors.blue[700]!;
        break;
      case TransactionType.reward:
        amountText = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              NumberFormat.currency(symbol: "Rp ", decimalDigits: 0)
                  .format(amount),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            )
          ],
        );
        typeText = Text(
          description!,
          style: const TextStyle(fontSize: 12),
        );
        break;
      default:
        break;
    }

    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[300]!))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                amountText,
                const SizedBox(
                  height: 1,
                ),
                statusText,
                typeText,
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  DateFormat('dd MMM yyyy').format(date!),
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  "Id Transaksi:",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  tid!,
                  style: TextStyle(color: tidWidgetColor, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}