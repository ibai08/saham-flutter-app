// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class BadgeCountNotif extends StatelessWidget {
  const BadgeCountNotif({Key? key, this.inboxCount}) : super(key: key);

  final int? inboxCount;

  @override
  Widget build(BuildContext context) {
    return inboxCount != null && inboxCount! > 0
        ? Container(
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 15,
            width: 15,
            child: Center(
              child: Text(
                inboxCount! > 99 ? "99+" : inboxCount.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : const SizedBox();
  }
}
