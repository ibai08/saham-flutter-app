import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';

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
              child: new Text(
                inboxCount! > 99 ? "99+" : inboxCount.toString(),
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : SizedBox();
  }
}
