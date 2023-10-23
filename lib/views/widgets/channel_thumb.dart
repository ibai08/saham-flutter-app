// ignore_for_file: unrelated_type_equality_checks, empty_catches

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/app_state_controller.dart';
import 'package:saham_01_app/controller/signal_tab_controller.dart';
import 'package:saham_01_app/core/string.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/ois.dart';
import 'package:saham_01_app/models/user.dart';
import 'package:saham_01_app/views/widgets/heading_channel_info_new.dart';
import 'package:saham_01_app/views/widgets/channel_power.dart';

import '../../function/subscribe_channel.dart';

class ChannelThumb extends StatelessWidget {
  final int? id;
  final String? username;
  final double? price;
  final String? name;
  final double? post;
  final double? profit;
  final double? pips;
  final String? avatar;
  final bool? subscribed;
  final int? subscriber;
  final double? width;
  final double? marginBottom;
  final String? from;
  final String? search;
  final Level? level;
  final int? medals;

  final AppStateController appStateController = Get.find();
  final ListChannelWidgetController controller = Get.find();

  ChannelThumb({
    Key? key,
    this.id,
    this.username,
    this.name,
    this.price,
    this.post,
    this.profit,
    this.pips,
    this.avatar,
    this.subscribed,
    this.subscriber,
    this.width,
    this.marginBottom,
    this.from,
    @required this.level,
    @required this.medals,
    this.search,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Rx<ChannelCardSlim>? channelStream = ChannelCardSlim().obs;
    ChannelCardSlim channel = ChannelCardSlim(
      id: id,
      avatar: avatar,
      name: name,
      pips: pips,
      price: price,
      profit: profit! * 10000,
      postPerWeek: post,
      subscribed: subscribed,
      subscriber: subscriber,
      username: username,
    );

    // Initialize the channelStream
    channelStream?.value = channel;

    // Watch the channel cache and update the channelStream accordingly
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      channelStream?.value = channel;
      Rx<String?>? data =
          await channel.watchChannelCache(appStateController.users.value.id);
      if (data != null && data.isNotEmpty!) {
        try {
          Map boxData = jsonDecode(data.value!);
          if (boxData.containsKey("data")) {
            channelStream?.value = ChannelCardSlim.fromMap(boxData["data"]);
            // print(channelStream?.value.price);
          }
        } catch (_) {
        }
      }
      // print("profit bersih: ${channel.profit}");
    });

    if (level?.level == null) {
      return const SizedBox();
    }

    return Obx(() {
      ChannelCardSlim? tChannel = channel;

      RxString btnLabel = 'Subcsribe for FREE'.obs;
      Rx<Color> btnColor = AppColors.blueGem.obs;
      Rx<Color> txtcolor = Colors.white.obs;

      if (tChannel.username == appStateController.users.value.username) {
        btnLabel.value = "LIHAT CHANNEL";
        btnColor.value = Colors.grey[300]!;
        txtcolor.value = Colors.grey[800]!;
        // print("1");
      } else if (tChannel.subscribed != null && tChannel.subscribed == true) {
        btnLabel.value = "Subscribed";
        btnColor.value = Colors.grey[300]!;
        txtcolor.value = Colors.grey[800]!;
        // print("2");
      } else if (tChannel.isPrivate == true) {
        btnLabel.value = "Subscribe with TOKEN";
        // print("3");
      } else if (tChannel.price != null) {
        if (tChannel.price == 0) {
          // print("kena yang ini");
          btnLabel.value = 'Subcsribe for FREE';
        } else if (tChannel.price! > 0) {
          btnLabel.value = "Subscribe for Rp " +
              NumberFormat("#,###", "ID").format(tChannel.price);
        }
        // print("ini kena");
      } // } else {
      //   print("gak kena apa apa");
      //   print("tchannel.price: ${tChannel?.price}");
      // }

      // print("btnlabel: $btnLabel");
      // print("profit: ${tChannel.profit}");

      return Container(
        width: width ?? double.infinity,
        margin: EdgeInsets.only(
          top: 0,
          bottom: marginBottom ?? 15,
          left: 10,
          right: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: AppColors.white,
        ),
        child: Column(
          children: <Widget>[
            HeadingChannelInfoNew(
              onTap: () {
                OisModel.instance
                    .logActions(
                      channelId: tChannel.id,
                      actionName: "view",
                      stateName: from!,
                    )
                    .then((x) {})
                    .catchError((err) {});
                Get.toNamed('/dsc/channels/', arguments: {
                  "channelId": tChannel.id
                });
              },
              isMedium: false,
              avatar: avatar,
              useMedal: false,
              level: level,
              medals: medals,
              title: name,
              subscriber: subscriber,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                height: 0.5,
                thickness: 0.5,
                indent: 1,
                endIndent: 0,
                color: Color(0xFFC9CCCF),
              ),
            ),
            const SizedBox(height: 0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: [
                      ChannelPower(
                        title: "+" + numberShortener((tChannel.profit)!.ceil()),
                        subtitle: "Profit",
                        isGreen: true,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ChannelPower(
                    title: numberShortener(tChannel.postPerWeek!.floor()),
                    subtitle: "Post / Week",
                    isGreen: false,
                  ),
                ),
              ],
            ),
            UserModel.instance.hasLogin()
                ? Container(
                    margin: const EdgeInsets.only(
                        top: 6, right: 20, bottom: 20, left: 20),
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        if (tChannel.subscribed!) {
                          OisModel.instance
                              .logActions(
                                channelId: tChannel.id!,
                                actionName: "view",
                                stateName: from!,
                              )
                              .then((x) {})
                              .catchError((err) {});
                          Get.toNamed('/dsc/channels/', arguments: {
                            "channelId": tChannel.id
                          });
                        } else {
                          subcribeChannel(tChannel, context, controller.refreshController);
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: btnColor.value,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.all(12),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                      ),
                      child: Text(
                        btnLabel.value,
                        style: TextStyle(
                          color: txtcolor.value,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          fontFamily: 'Manrope'
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      );
    });
  }
}