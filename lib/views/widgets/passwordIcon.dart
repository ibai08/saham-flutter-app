import 'package:flutter/material.dart';

class PasswordIcon extends StatelessWidget {
  final bool? seePass;
  const PasswordIcon({Key? key, this.seePass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      seePass!
          ? 'assets/icon/light/eye-off.png'
          : 'assets/icon/light/eye-on.png',
      width: 20,
      height: 20,
    );
  }
}
