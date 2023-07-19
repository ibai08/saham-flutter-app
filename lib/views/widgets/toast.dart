import 'package:flutter/material.dart';

void showToast(
    BuildContext context, String strToast, String labelSnackBarAction) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.hideCurrentSnackBar();
  scaffold.showSnackBar(
    SnackBar(
      content: Text(strToast),
      action: SnackBarAction(
          textColor: Colors.blue,
          label: labelSnackBarAction,
          onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
  Future.delayed(const Duration(seconds: 2), () {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  });
}