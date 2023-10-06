import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TileCopySignal extends StatelessWidget {
  final String name;
  final DateTime date;
  final String account;
  final double lot;
  final int signalId;
  final String symbol;

  const TileCopySignal({Key? key, required this.account, required this.name, required this.date, required this.lot, required this.signalId, required this.symbol}) : super (key: key);

  List<Widget> getExpanded(BuildContext context) {
    var formatter = DateFormat('dd/MMM/yyyy');
    String formatted = formatter.format(date);
    List<Widget> list = [];

    list.add(Expanded(
      flex: 10,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Account no: " + account,
            ),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 1,
            ),
            Text("Instrument: " + symbol),
            Text("Volume (Lot): " + lot.toString()),
            Text("Copy at: " + formatted),
          ],
        ),
      ),
    ));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Colors.grey[400]!)),
          color: Colors.white),
      padding: const EdgeInsets.all(15.0),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getExpanded(context)),
    );
  }
}