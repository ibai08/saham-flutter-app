import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class ChannelPower extends StatelessWidget {
   ChannelPower({
    Key? key,
    this.title,
    this.subtitle, this.isGreen,
  }) : super(key: key);

  final String? title;
  final String? subtitle;
  final bool? isGreen;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        subtitle!,
        softWrap: false,
        style: TextStyle(
            fontSize: 12,
            color: AppColors.darkGrey2,
            fontWeight: FontWeight.w300,
            fontFamily: 'Manrope'),
        textAlign: TextAlign.start,
      ),
      subtitle: Text(title!,
          style: TextStyle(
              fontSize: 20,
              color: isGreen == true ? AppColors.primaryGreen : AppColors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Manrope'),
          textAlign: TextAlign.start),
    );
  }
}
