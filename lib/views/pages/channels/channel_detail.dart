import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/app_state_controller.dart';
import 'package:saham_01_app/controller/channel_detail_controller.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/core/string.dart';
import 'package:saham_01_app/function/show_alert.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/pages/channels/details/list_active_new.dart';
import 'package:saham_01_app/views/pages/channels/details/list_history_new.dart';
import 'package:saham_01_app/views/pages/channels/details/statistics.dart';
import 'package:saham_01_app/views/pages/channels/details/summary.dart';
import 'package:saham_01_app/views/widgets/channel_power.dart';
import 'package:saham_01_app/views/widgets/dialog_loading.dart';
import 'package:saham_01_app/views/widgets/heading_channel_info.dart';
import 'package:saham_01_app/views/widgets/info.dart';

import '../../../controller/signal_tab_controller.dart';
import '../../../function/subscribe_channel.dart';

class ChannelDetailNew extends StatelessWidget {
  final ChannelDetailController controller = Get.put(ChannelDetailController());
  final ListChannelWidgetController listChannelWidgetController = Get.find();
  final AppStateController appStateController = Get.find();

  final arguments = Get.arguments;

  ChannelDetailNew({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = const [
      Tab(
        text: "SUMMARY",
      ),
      Tab(
        text: "ACTIVE SIGNAL",
      ),
      Tab(
        text: "HISTORY SIGNAL",
      ),
      Tab(
        text: "STATISTICS",
      )
    ];
    if (arguments != null) {
      controller.channel.value = arguments['channelId'];
      controller.getChannel();
    }

    controller.tabController = TabController(length: 4, vsync: controller);

    return Obx(() {
      void onTapItem(int index) {
        controller.tabIndex.value = index;
        controller.tabController.index = index;
      }
      if (controller.getChannelComplete.value == false && controller.hasError.value == false) {
        return const Scaffold(
          body: Center(
            child: Text(
              "Tunggu ya..!!",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
        );
      }
      if (controller.hasError.value == true) {
        if (controller.errorMessage.value == "ResultNotFoundError") {
          return const Center(
            child: Text(
              "Maaf..data tidak ditemukan",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
              ),
            ),
          );
        }
        return Info(
          onTap: controller.refreshChannel,
          title: "Error",
          desc: controller.errorMessage.value,
        );
      }

      List<Widget> tabView = [
        SummaryChannels(),
        ListActiveSignal(),
        ListHistorySignal(),
        StatisticsChannel()
      ];

      controller.tabController.animateTo(controller.tabIndex.value);
      return Obx(() {
        int tabViews = 780;
        Widget? btnSubs1;
        Widget? btnSubs2;
        Widget? btnSubs3;
        Widget? btnSubs4;
        if (controller.channelDetail.price != null) {
          if (controller.channelDetail.price! > 1) {
            controller.price.value = numberShortener(controller.channelDetail.price!.floor());
          } else {
            controller.price.value = "FREE";
          }
        }

        if (controller.channelDetail.profit != null) {
          controller.channelProfit.value = controller.channelDetail.profit!;
        }

        if (tabViews < MediaQuery.of(context).size.width) {
          controller.isTab.value = true;
        }

        double minWidth = !controller.isTab.value ? MediaQuery.of(context).size.width / 2 : 0;
        if (controller.channelDetail.name == appStateController.users.value.username) {
          controller.paddingBtn.value = 15;
          controller.btn.value = 1;
          btnSubs1 = TextButton(
            onPressed: () {
              Get.toNamed('/dsc/channels/new', arguments: {
                "channel": controller.channelDetail,
                "appStateController": appStateController.users.value
              });
            },
            child: const Text(
              "Edit Channel",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primaryYellow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(horizontal: 10)
            ),
          );
        } else if (controller.channelDetail.subscribed == true) {
          controller.paddingBtn.value = 15;
          int maxDay = remoteConfig.getInt("ois_can_extend_subs_days");
          DateTime subExp = controller.channelDetail.subsExpired!;
          DateTime now = DateTime.now();
          if (controller.channelDetail.price! > 0 && now.isAfter(subExp.subtract(Duration(days: maxDay)))) {
            controller.btn.value = 2;
            btnSubs2 = PopupMenuButton<String>(
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: minWidth),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.darkGrey,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Unsubscribe",
                          style: TextStyle(color: Colors.white)
                        ),
                        WidgetSpan(
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 16,
                            color: Colors.white,
                          )
                        )
                      ]
                    ),
                  ),
                ),
              ),
              onSelected: (value) {
                switch (value) {
                  case "1":
                    subcribeChannel(controller.channelDetail, context, controller.refreshController);
                    break;
                  case "2":
                    confirmPayment(controller.channelDetail, context, controller.refreshController);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: "1",
                  child: Text("Unsubscribe"),
                ),
                const PopupMenuItem<String>(
                  value: "2",
                  child: Text("Extend Subscription"),
                )
              ],
            );
          } else {
            controller.btn.value = 3;
            btnSubs3 = ConstrainedBox(
              constraints: BoxConstraints(minWidth: minWidth),
              child: TextButton(
                onPressed: () {
                  subcribeChannel(controller.channelDetail, context, controller.refreshController);
                },
                child: const Text(
                  "Unsubscribe",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)
                  ),
                  backgroundColor: Colors.grey[400],
                  padding: const EdgeInsets.only(left: 20, right: 20),
                ),
              ),
            );
          }
        } else {
          controller.paddingBtn.value = 0;
          controller.btn.value = 4;
          btnSubs4 = Obx(() {
            return ConstrainedBox(
              constraints: BoxConstraints(minWidth: minWidth),
              child: TextButton(
                onPressed: () {
                  subcribeChannel(controller.channelDetail, context, controller.refreshController);
                },
                child: Text(
                  controller.channelDetail.isPrivate == true ? "Subscribe with TOKEN" : "Subscribe | " + controller.price.value,
                  style: const TextStyle(
                    color: Colors.white
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20)
                ),
              )
            );
          });
        }

        Widget btnChannel = Obx(() {
          return Container(
          height: 40,
          margin: const EdgeInsets.only(right: 15),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              controller.btn.value == 1 ? btnSubs1! : controller.btn.value == 2 ? btnSubs2! : controller.btn.value == 3 ? btnSubs3! : btnSubs4!,
              controller.channelDetail.username == appStateController.users.value.username ? const Padding(
                padding: EdgeInsets.only(left: 12.0),
              ) : const Text("")
            ],
          ));
        });
          return Scaffold(
            appBar: NavTxt.getx(
              title: controller.titleObs,
              tap: () {
                Get.back();
                listChannelWidgetController.refreshController.requestRefresh(needMove: false);
              },
            ),
            body: NestedScrollView(
              controller: controller.scrollController,
              body: tabView.elementAt(controller.tabIndex.value),
              headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    leading: const IconButton(
                      color: Colors.transparent,
                      onPressed: null,
                      icon: SizedBox(),
                    ),
                    backgroundColor: Colors.white,
                    pinned: true,
                    floating: true,
                    snap: true,
                    iconTheme: const IconThemeData(color: Colors.black),
                    forceElevated: boxIsScrolled,
                    expandedHeight: 780 < MediaQuery.of(context).size.width ? 220 : 285,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: SmartRefresher(
                        controller: controller.refreshController,
                        enablePullDown: true,
                        enablePullUp: false,
                        onRefresh: controller.refreshChannel,
                        child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: HeadingChannelInfo(
                                  trailing: Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      children: [
                                        if (controller.channelDetail.username != appStateController.users.value.username)
                                          if (controller.channelDetail.subscribed == true)
                                            IconButton(
                                              onPressed: () async {
                                                String textAlert = "";
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    return DialogLoading();
                                                  }
                                                );
                                                if (controller.channelDetail.mute == false) {
                                                  textAlert = "tidak";
                                                }
                                                await ChannelModel.instance.muteChannel(
                                                  channelid: controller.channelDetail.id,
                                                  mute: controller.channelDetail.mute
                                                );
                                                controller.refreshController.requestRefresh(needMove: false);
                                                Get.back();
                                                showAlert(
                                                  context, 
                                                  LoadingState.success,
                                                  "Anda ${textAlert}akan menerima notifikasi signal dari channel ini"
                                                );
                                              },
                                              icon: Icon(
                                                controller.channelDetail.mute == true ? Icons.notifications_off : Icons.notifications_active,
                                                color: controller.channelDetail.mute == true ? Colors.grey[600] : AppColors.primaryGreen,
                                                size: 28,
                                              ),
                                            ),
                                        if (controller.isTab.value) btnChannel
                                      ],
                                    ),
                                  ),
                                  isLarge: true,
                                  avatar: controller.channelDetail.avatar,
                                  level: controller.medal.value,
                                  medals: controller.channelDetail.medals,
                                  title: controller.channelDetail.name,
                                  subscriber: controller.channelDetail.subscriber,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (!controller.isTab.value) btnChannel,
                              if (!controller.isTab.value) const SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ChannelPower(
                                      title: numberShortener(controller.channelProfit.value.floor() * 10000),
                                      subtitle: "Profit",
                                    ),
                                  ),
                                  Expanded(
                                    child: ChannelPower(
                                      title: "${controller.channelDetail.weekAge}",
                                      subtitle: "Minggu",
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                      ),
                    ),
                    bottom: TabBar(
                      isScrollable: true,
                      labelColor: AppColors.primaryGreen,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                      ),
                      unselectedLabelColor: AppColors.darkGrey,
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                      ),
                      indicatorColor: AppColors.primaryGreen,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 3,
                      tabs: tabs,
                      controller: controller.tabController,
                      onTap: onTapItem,
                    ),
                  )
                ];
              },
            ),
          );
        }
      );
    });
  }
}