import 'package:flutter/material.dart';

class LogoDom extends StatelessWidget {
  const LogoDom({Key? key, this.pad})
      : super(
          key: key,
        );
  final double? pad;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(pad ?? 0),
        child: Center(
            child: Image.asset(
          "assets/icon-forgot-password.png",
          scale: 3,
        )),
      );
}
