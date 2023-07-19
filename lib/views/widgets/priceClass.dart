import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceClass extends StatelessWidget {
  PriceClass(
      {Key? key, @required this.batch, @required this.price, this.discount})
      : super(key: key);
  final String? batch;
  final double? price;
  final double? discount;

  final NumberFormat formatDecimal = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    Widget textPrice = Text("IDR " + formatDecimal.format(price),
        style: const TextStyle(fontSize: 16));
    if (discount != null && discount! > 0) {
      textPrice = Column(
        children: <Widget>[
          Text(
            "( IDR " + formatDecimal.format(price) + " )",
            style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                fontSize: 12,
                color: Colors.red),
          ),
          Text(
            "IDR " + formatDecimal.format(discount),
            style: const TextStyle(fontSize: 16),
          )
        ],
      );
    }
    return Column(children: <Widget>[
      Text(
        batch!,
        style: TextStyle(color: Colors.green[700]),
      ),
      const SizedBox(
        height: 5,
      ),
      textPrice
    ]);
  }
}