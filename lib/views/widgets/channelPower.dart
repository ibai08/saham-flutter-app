import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class ChannelPower extends StatelessWidget {
  const ChannelPower({
    Key? key,
    this.title,
    this.subtitle,
  }) : super(key: key);

  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        subtitle!,
        softWrap: false,
        style: TextStyle(
            fontSize: 18,
            color: AppColors.grey,
            fontWeight: FontWeight.w600),
        textAlign: TextAlign.start,
      ),
      subtitle: Text(title!,
          style: const TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.start),
    );
  }
}