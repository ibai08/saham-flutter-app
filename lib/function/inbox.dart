// ignore_for_file: avoid_print, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/entities/inbox.dart';
import '../../views/widgets/inboxItem.dart';

List<Widget> prepareInboxItem(Map data, {InboxType? type}) {
  List<Widget> items = [];
  try {
    data.forEach((k, v) {
      Map params = jsonDecode(v["params"]);
      if (params["type"] == "signal" &&
          v["message"] != null &&
          v["created"] is int &&
          (type == null || type == InboxType.signal)) {
        items.add(getSignalInboxItem(k, v));
      } else if (params["type"] == "html" &&
          v["message"] != null &&
          v["created"] is int &&
          (type == null || type == InboxType.html)) {
        items.add(getHtmlInboxItem(k, v));
      } else if (params["type"] == "wptfpost" &&
          v["message"] != null &&
          v["created"] is int &&
          (type == null || type == InboxType.wptfpost)) {
        items.add(getWpTFInboxItem(k, v));
      } else if (params["type"] == "payment" &&
          v["message"] != null &&
          v["created"] is int &&
          (type == null || type == InboxType.payment)) {
        items.add(getPaymentInboxItem(k, v));
      }
    });
  } catch (xerr) {
    print("prepareInboxItem: $xerr");
  }
  return items;
}

Widget getHtmlInboxItem(
  dynamic keyMap,
  dynamic valueMap,
) {
  var m = DateTime.fromMillisecondsSinceEpoch(valueMap["created"] * 1000);
  String formattedDate = DateFormat('dd MMM yyyy').format(m);
  return Container(
    child: InboxItem(
      type: InboxType.html,
      date: formattedDate,
      title: valueMap["title"],
      status: valueMap["baca"],
      data: valueMap,
      description: valueMap["description"],
    ),
  );
}

Widget getWpTFInboxItem(dynamic keyMap, dynamic valueMap) {
  var m = DateTime.fromMillisecondsSinceEpoch(valueMap["created"] * 1000);
  String formattedDate = DateFormat('dd MMM yyyy').format(m);
  return Container(
    child: InboxItem(
      type: InboxType.wptfpost,
      date: formattedDate,
      title: valueMap["title"],
      status: valueMap["baca"],
      data: valueMap,
      description: valueMap["description"],
    ),
  );
}

Widget getSignalInboxItem(dynamic keyMap, dynamic valueMap) {
  var m = DateTime.fromMillisecondsSinceEpoch(valueMap["created"] * 1000);
  String formattedDate = DateFormat('dd MMM yyyy').format(m);
  return Container(
    child: InboxItem(
      date: formattedDate,
      description: valueMap["title"].toString(),
      title: valueMap["description"].toString(),
      status: valueMap["baca"],
      data: valueMap,
      type: InboxType.signal,
    ),
  );
}

Widget getPaymentInboxItem(dynamic keyMap, dynamic valueMap) {
  var m = DateTime.fromMillisecondsSinceEpoch(valueMap["created"] * 1000);
  String formattedDate = DateFormat('dd MMM yyyy').format(m);
  return Container(
    child: InboxItem(
      date: formattedDate,
      description: valueMap["title"].toString(),
      title: valueMap["description"].toString(),
      status: valueMap["baca"],
      data: valueMap,
      type: InboxType.payment,
    ),
  );
}
