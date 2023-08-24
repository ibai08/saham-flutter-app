// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class OrderedListWidget extends StatelessWidget {
  final String? order;
  final String? text;
  const OrderedListWidget({Key? key, this.order, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text("$order."),
            width: 20,
          ),
          Expanded(
            child: Text(
              "$text",
              style: const TextStyle(fontSize: 14, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
