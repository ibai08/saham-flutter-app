import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class Line extends StatelessWidget {
  const Line({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.grey,
      height: 1,
    );
  }
}