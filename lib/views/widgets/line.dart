import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class Line extends StatelessWidget {
  const Line({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.grey,
      height: 1,
    );
  }
}
