// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class PromptText extends StatelessWidget {
  const PromptText({
    Key? key,
    this.title,
    this.desc,
    this.textBtn,
    this.url,
  }) : super(key: key);

  final title;
  final desc;
  final textBtn;
  final url;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        margin: const EdgeInsets.only(top: 2, bottom: 15, left: 15, right: 15),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 7,
            ),
            Text(desc,
                style: TextStyle(fontSize: 12, color: AppColors.darkGrey)),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: url,
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.primaryGreen,
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    textBtn,
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  )),
            )
          ],
        ),
      );
}
