// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/views/widgets/channelAvatar.dart';

class HeadingChannelInfoNew extends StatelessWidget {
  const HeadingChannelInfoNew(
      {Key? key,
      @required this.avatar,
      @required this.level,
      @required this.medals,
      @required this.title,
      @required this.subscriber,
      this.isLarge = false,
      this.isMedium = false,
      this.trailing,
      this.onTap})
      : super(key: key);

  final String? avatar;
  final Level? level;
  final int? medals;
  final String? title;
  final int? subscriber;
  final Function? onTap;
  final bool? isLarge;
  final bool? isMedium;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    if (level == null || level?.level == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        onTap ?? null;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    width: 300,
                    child: Row(
                      children: [
                        ChannelAvatar(
                          width: isLarge!
                              ? 60
                              : isMedium!
                                  ? 50
                                  : 40,
                          imageUrl: avatar),
                        const SizedBox(
                          width: 2,
                        ),
                        Image.asset(
                            'assets/icon/medal/${level?.level?[level!.level!.indexWhere((x) => (medals! >= x.minMedal! && medals! <= x.maxMedal!))].name!.toLowerCase()}.png',
                            width: isLarge!
                                ? 50
                                : isMedium!
                                    ? 40
                                    : 35,
                            height: isLarge!
                                ? 50
                                : isMedium!
                                    ? 40
                                    : 35),
                        const SizedBox(
                          width: 2,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$title",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: isLarge!
                                        ? 18
                                        : isMedium!
                                            ? 16
                                            : 14),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              RichText(
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  style: TextStyle(
                                      color: AppColors.darkGrey,
                                      fontSize: isLarge!
                                          ? 12
                                          : isMedium!
                                              ? 11
                                              : 10),
                                  children: [
                                    TextSpan(
                                        text:
                                            "${level?.level?[level!.level!.indexWhere((x) => (medals! >= x.minMedal! && medals! <= x.maxMedal!))].name}",
                                        style: TextStyle(
                                            color: AppColors.primaryGreen,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12)),
                                    TextSpan(
                                      text: "  |  $subscriber Subscriber",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ),
                ),
                Container(
                  height: 24,
                  width: 24,
                  child: Image.asset(
                    "assets/icon/light/arrow-right.png",
                    height: 24,
                    width: 24,
                  ),
                ),
                SizedBox(
                  width: trailing == null ? 0 : 30,
                ),
                
              ],
            ),
            Positioned(
                right: 0,
                child: trailing == null
                    ? const SizedBox()
                    : Container(
                        child: trailing,
                      )),
          ],
        ),
      ),
    );
  }
}