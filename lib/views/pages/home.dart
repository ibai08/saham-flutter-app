import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/interface/click_listener.dart';
import 'package:saham_01_app/library/dynamic_widgets/dynamic_widget.dart';
import '../../controller/home_tab_controller.dart';

import '../../constants/app_colors.dart';
import '../../controller/app_state_controller.dart';
import '../../controller/check_internet_controller.dart';
import '../../controller/nav_channel_new.dart';
import '../../core/analytics.dart';
import '../../core/string.dart';
import '../../function/show_alert.dart';
import '../../function/subscribe_channel.dart';
import '../../models/entities/ois.dart';
import '../../models/entities/user.dart';
import '../../models/ois.dart';
import '../widgets/channel_avatar.dart';
import '../widgets/dialog_loading.dart';
import '../widgets/home_top_rank_shimmer.dart';
import '../widgets/recent_profit_signal_new.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final HomeTabController homeTabController = Get.find();
  final CheckInternetController checkInet = Get.find();
  final AppStateController appStateController = Get.find();
  final NewHomeTabController newHomeTabController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () { return Scaffold(
        appBar: NavMain(
          currentPage: 'HomePage',
          username: "Gopay Kai",
        ),
        body: prepareHome(context),
        backgroundColor: AppColors.light,
      );
   });
  }

  Widget prepareHome(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: homeTabController.refreshController,
      onRefresh: homeTabController.onRefresh,
      onLoading: homeTabController.onLoad,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          // const TotalBalance(),
          // MostConsistentChannel(
          //   futureList:
          //       homeTabController.getMostConsistentChannels(clearCache: false),
          //   medal: homeTabController.medal.value,
          // ),
          const SizedBox(height: 20),
          FutureBuilder(
            future: buildWidgetFromJson(context),
            builder: (context, snapshot) {
              var connectionState = snapshot.connectionState;
              if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              } else if (connectionState == ConnectionState.active || connectionState == ConnectionState.waiting) {
                return Center(
                  child: MostConsistentChannelShimmer(sH: screenHeight,),
                );
              } else {
                return Container(
                  child: snapshot.data as Widget,
                );
              }
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 18),
            child: RecentProfitSignalWidgetNew(
              data: homeTabController.closedSignal.isNotEmpty
                  ? homeTabController.closedSignal
                  : [],
              medal: homeTabController.medal.value,
            ),
          ),
          // NewProfitSignal(),
          // const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<Widget?> buildWidgetFromJson(BuildContext buildContext) async {
    var response = await rootBundle.loadString('assets/json/coba.json');
    await Future.delayed(const Duration(seconds: 2));
    return DynamicWidgetBuilder.build(response, buildContext, DefaultClickListener(buildContext));
  }
}

class TotalBalance extends StatelessWidget {
  const TotalBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Total Balance",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        "Rp5,000,000.00",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.6,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    "assets/Lotus Logo.png",
                    width: 61,
                    height: 46,
                  ),
                ),
              ],
            ),
            // ==> BOX BUYING POWER
            Container(
              decoration: BoxDecoration(
                  color: AppColors.purplePrimary,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Buying Power",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          "Rp1,345,000.00",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.6,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 15),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.greenLight,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/icon/light/plus.png",
                              width: 16, height: 16),
                          const SizedBox(width: 5),
                          const Text(
                            "Deposite",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MostConsistentChannel extends StatefulWidget {
  const MostConsistentChannel({Key? key, this.futureList, this.medal})
      : super(key: key);
  @override
  _MostConsistentChannel createState() => _MostConsistentChannel();

  final Future<List<ChannelCardSlim>>? futureList;
  final Level? medal;
}

class _MostConsistentChannel extends State<MostConsistentChannel> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<List<ChannelCardSlim>>(
        future: widget.futureList,
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return MostConsistentChannelShimmer(sH: screenHeight);
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 25),
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: ListTile(
                        dense: true,
                        title: Text(
                          "Channel Trending",
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'Manrope'),
                        ),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: snapshot.data!.map((ChannelCardSlim map) {
                    return MostConsistentChannelThumbNew(
                        medal: widget.medal ?? Level(),
                        channel: map,
                        from: "most_consistent");
                  }).toList()),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 19),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed('/channel-signal');
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Lihat Semua",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Manrope'),
                        ),
                        const SizedBox(width: 3),
                        Image.asset("assets/icon/light/arrow-right.png",
                            width: 12, height: 12)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class MostConsistentChannelThumbNew extends StatelessWidget {
  MostConsistentChannelThumbNew({Key? key, this.medal, this.channel, this.from})
      : super(key: key);

  final AppStateController appStateController = Get.find();

  final ChannelCardSlim? channel;
  final Level? medal;
  final String? from;

  final Rx<ChannelCardSlim>? channelInfo = ChannelCardSlim().obs;

  void fetchData() async {
    try {
      channelInfo?.value = channel!;
      String? data = (await channel
          ?.watchChannelCache(appStateController.users.value.id)) as String?;

      if (data != "") {
        Map boxData = jsonDecode(data!);
        if (boxData.containsKey("data")) {
          channelInfo?.value = ChannelCardSlim.fromMap(boxData["data"]);
        }
      }
    } catch (e) {
      channelInfo?.addError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    if (medal?.level == null) {
      return MostConsistentChannelShimmer(sH: screenHeight);
    }
    fetchData();

    return Obx(() {
      UserInfo? user = appStateController.users.value;
      ChannelCardSlim? tChannel = channelInfo?.value;
      tChannel ??= channel;
      // ChannelCardSlim tChannel = snapshot.data;
      String btnLabel = 'Subscribe for FREE';
      Color? btnColor = AppColors.blueGem;
      Color? txtcolor = Colors.white;
      if (tChannel?.username == appStateController.users.value.username) {
        btnLabel = "LIHAT CHANNEL";
        btnColor = Colors.grey[300];
        txtcolor = Colors.grey[800];
      } else if (tChannel!.subscribed!) {
        btnLabel = "Subscribed";
        btnColor = Colors.grey[300];
        txtcolor = Colors.grey[800];
      } else if (tChannel.isPrivate == true) {
        btnLabel = "Subscribe with TOKEN";
      } else if (tChannel.price! > 0) {
        btnLabel = "Subscribe for Rp " +
            NumberFormat("#,###", "ID").format(tChannel.price);
      }

      return GestureDetector(
        onTap: () {
          if (user.id > 0) {
            firebaseAnalytics.logViewItem(items: [
              AnalyticsEventItem(
                itemId: "${channel?.id}",
                itemName: "${channel?.name}",
                itemCategory: "Channel",
                locationId: "Consistent Channel",
              )
            ]).then((_) {}, onError: (err) {});
            OisModel.instance
                .logActions(
                    channelId: channel?.id, actionName: "view", stateName: from)
                .then((x) {})
                .catchError((err) {});
            Get.toNamed('/dsc/channels/',arguments: {
              "channelId": channel?.id
            });
          } else {
            showAlert(context, LoadingState.warning,
                "Anda harus login terlebih dahulu untuk melihat channel",
                thens: (x) {
              Navigator.pushNamed(context, '/forms/login');
            });
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          padding:
              const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
          width: 240,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ChannelAvatar(
                    width: 40,
                    imageUrl: channel?.avatar,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Image.asset(
                    'assets/icon/medal/${medal?.level![medal!.level!.indexWhere((x) => (channel!.medals! >= x.minMedal! && channel!.medals! <= x.maxMedal!))].name!.toLowerCase()}.png',
                    width: 35,
                    height: 35,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${channel?.name}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        RichText(
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              style: TextStyle(
                                  color: AppColors.darkGrey, fontSize: 10),
                              children: [
                                TextSpan(
                                    text:
                                        "${medal!.level![medal!.level!.indexWhere((x) => (channel!.medals! >= x.minMedal! && channel!.medals! <= x.maxMedal!))].name}",
                                    style: TextStyle(
                                      color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9.5,
                                    )),
                                TextSpan(
                                  text:
                                      "  |  ${channel?.subscriber} Subscriber",
                                  style: const TextStyle(fontSize: 9.5),
                                ),
                              ]),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Image.asset("assets/icon/light/trending-up.png"),
                    const SizedBox(width: 8),
                    Text(
                      "+${numberShortener(channel!.profit!.ceil() * 10000)}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGreenLight,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 10, right: 8, bottom: 3, left: 8),
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      if (tChannel!.subscribed!) {
                        OisModel.instance
                            .logActions(
                                channelId: tChannel.id,
                                actionName: "view",
                                stateName: from)
                            .then((x) {})
                            .catchError((err) {});
                        Get.toNamed('/dsc/channels/',arguments: {
                          "channelId": channel?.id
                        });
                      } else {
                        subcribeChannel(tChannel, context, null);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: btnColor,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.all(10),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                    ),
                    child: Text(btnLabel,
                        style: TextStyle(
                            color: txtcolor,
                            fontWeight: FontWeight.w400,
                            fontSize: 13))),
              )
            ],
          ),
        ),
      );
    });
  }
}

class TitlePartHome extends StatelessWidget {
  const TitlePartHome({Key? key, @required this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 19.5, bottom: 10),
      child: Text(
        title!,
        style: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'Manrope'),
        textAlign: TextAlign.left,
      ),
    );
  }
}
