import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/views/widgets/channel_avatar.dart';

import '../../models/entities/ois.dart';

class HeadChannelRow extends StatelessWidget {
  final String avatar;
  final Level? level;
  final int medals;
  final String title;
  final bool isLarge;
  final bool isMedium;
  final Widget? trailing;
  final Function? onTap;
  final int index;

  const HeadChannelRow({
    Key? key,
    required this.avatar,
    this.level,
    required this.medals,
    required this.title,
    this.isLarge = false,
    this.isMedium = false,
    this.trailing,
    this.index = 1,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (level == null || level?.level == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: onTap == null ? null : onTap!(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                        child: ChannelAvatar(
                          width: isLarge ? 60 : isMedium ? 50 : 40,
                          imageUrl: avatar == "" || avatar == " " ? null : avatar,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                             fontWeight: FontWeight.w600,
                             fontSize: isLarge ? 18 : isMedium ? 16 : 14
                            ),
                          ),
                          Text(
                            "${level?.level?[level!.level!.indexWhere((x) => (medals >= x.minMedal! && medals <= x.maxMedal!))].name}",
                             style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w600,
                              fontSize: 12
                            ),
                          )
                        ]
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}