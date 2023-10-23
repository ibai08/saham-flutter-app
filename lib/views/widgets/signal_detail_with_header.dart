// ignore_for_file: avoid_unnecessary_containers

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../config/symbol_config.dart';
import '../../controller/app_state_controller.dart';
import '../../models/entities/ois.dart';
import '../../models/entities/user.dart';
import '../../models/ois.dart';
import 'heading_channel_info_new.dart';

import '../../constants/app_colors.dart';
import '../../core/analytics.dart';

class SignalDetailWithHeaderNew extends StatelessWidget {
  final String? symbol;
  // final String type;
  final int? expired;
  // final int pips;
  // final double tp;
  // final double sl;
  // final double price;
  // final int status;
  final int? channelId;
  final String? createdAt;
  final int? id;
  final String? title;
  final double? profit;
  final String? username;
  final String? closeAt;
  final String? avatar;
  final int? medals;
  final int? subscriber;
  final Level? level;

  final AppStateController appStateController = Get.find();

  SignalDetailWithHeaderNew(
      {Key? key,
      @required this.symbol,
      // @required this.type,
      this.expired,
      // @required this.pips,
      // @required this.tp,
      // @required this.sl,
      // @required this.price,
      // @required this.status
      @required this.title,
      @required this.username,
      @required this.channelId,
      @required this.createdAt,
      this.closeAt,
      @required this.medals,
      @required this.profit,
      this.level,
      this.subscriber,
      @required this.id,
      this.avatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (level == null || level?.level == null) {
      return const SizedBox();
    }
    var m = DateTime.parse(createdAt ?? "").add(const Duration(hours: 7));

    String titleSymbol = symbolConfig.firstWhere(
            (config) => config['symbol'] == symbol,
            orElse: () => {})['title'] ??
        'Data not found';

    String postedDate = DateFormat('dd MMM yyyy HH:mm').format(m) + " WIB";

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.only(left: 5, right: 15, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: AppColors.white),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    UserInfo user = appStateController.users.value;
                    if (user.id > 0) {
                      // firebaseAnalytics.logViewItem(
                      //   itemId: "$id",
                      //   itemName: "$title",
                      //   itemCategory: "Channel",
                      //   itemLocationId: "Recently_profit"
                      // ).then((x) {}).catchError((err) {});

                      firebaseAnalytics.logViewItem(items: [
                        AnalyticsEventItem(
                          itemId: "$id",
                          itemName: "$title",
                          itemCategory: "Channel",
                          locationId: "Recently_profit",
                        )
                      ]).then((_) {}, onError: (err) {});
                      Get.toNamed('/dsc/channels/', arguments: {
                        "channelId": channelId
                      });
                    } else {
                      // showAlert(context, LoadingState.warning, "Anda harus login terlebih dahulu untuk melihat channel", then: (x) {Navigator.pushNamed(context, '/forms/login');});
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      HeadingChannelInfoNew(
                        onTap: () {
                          UserInfo user = appStateController.users.value;
                          if (user.id > 0) {
                            firebaseAnalytics.logViewItem(items: [
                              AnalyticsEventItem(
                                itemId: "$id",
                                itemName: "$title",
                                itemCategory: "Channel",
                                locationId: "Recently Profit",
                              )
                            ]).then((_) {}, onError: (err) {});
                            OisModel.instance
                                .logActions(
                                    channelId: channelId,
                                    actionName: "view",
                                    stateName: "recently_profit")
                                .then((x) {})
                                .catchError((err) {});
                            Get.toNamed('/dsc/channels/', arguments: {
                              "channelId": channelId
                            });
                          } else {
                            // showAlert(context, LoadingState.warning, "Anda harus login terlebih dahulu untuk melihat channel", then: (x) {
                            //   Navigator.pushNamed(context, '/forms/login');
                            // });
                          }
                          // print("jalan ontap");
                        },
                        isMedium: false,
                        avatar: avatar,
                        level: level,
                        medals: medals,
                        title: title,
                        subscriber: subscriber,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          indent: 1,
                          endIndent: 0,
                          color: Color(0xFFC9CCCF),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.all(15.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    symbol ?? "Data not found",
                                    style: const TextStyle(
                                        fontFamily: 'Manrope',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    titleSymbol,
                                    style: const TextStyle(
                                      fontFamily: 'Manrope',
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "+$profit%",
                                    style: TextStyle(
                                        fontFamily: 'Manrope',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryGreen),
                                  ),
                                  Text(
                                    postedDate,
                                    style: const TextStyle(
                                      fontFamily: 'Manrope',
                                      fontSize: 10,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
