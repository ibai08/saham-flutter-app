import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class SortButton extends StatelessWidget {
  const SortButton({
    Key? key,
    @required this.text,
    @required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  final String? text;
  final Function? onTap;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: TextButton(
        onPressed: () {
          onTap!();
        },
        child: Text("$text"),
        style: TextButton.styleFrom(
            backgroundColor: isActive! ? Colors.green[50] : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: isActive! ? AppColors.primaryGreen : Colors.grey,
                    width: 1))),
      ),
    );
  }
}
