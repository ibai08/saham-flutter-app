// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class BtnBlock extends StatelessWidget {
  const BtnBlock({
    Key? key, this.title, this.onTap, this.rounded, this.isWhite, this.padding, this.margin, this.width, this.icon, this.textSize
  }) : super(key: key);

  final String? title;
  final Function? onTap;
  final bool? rounded;
  final bool? isWhite;
  final double? padding;
  final double? margin;
  final double? width;
  final Widget? icon;
  final double? textSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: padding ?? 12),
          backgroundColor: isWhite == true ? AppColors.white3 : AppColors.primaryGreen,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: AppColors.primaryGreen),
            borderRadius: BorderRadius.circular(rounded == true ? 30 : 4),
          )
        ),
        onPressed: () {
          onTap!();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null ?  Padding(
              padding: const EdgeInsets.only(left: 65),
              child: icon,
            ) : const SizedBox(),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: icon != null ? 50 : 0),
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: textSize ?? 16,
                    color: isWhite == true ? AppColors.primaryGreen : Colors.white
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}