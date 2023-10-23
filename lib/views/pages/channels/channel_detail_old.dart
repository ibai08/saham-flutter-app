// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/controller/list_active_controller_old.dart';
import 'package:saham_01_app/controller/list_history_controller_old.dart';
import '../../../constants/app_colors.dart';
import '../../../controller/app_state_controller.dart';
import '../../../controller/channel_detail_controller_old.dart';
import '../../../controller/channel_profile_controller.dart';
import '../../../controller/summary_channels_controller_old.dart';
import '../../../core/config.dart';
import '../../../core/string.dart';
import '../../../function/show_alert.dart';
import '../../../function/subscribe_channel.dart';
import '../../../models/channel.dart';
import '../../../models/entities/ois.dart';
import '../../../views/appbar/navtxt.dart';
import '../../../views/pages/channels/details/contact.dart';
import 'details/list_active.dart';
import 'details/list_history.dart';
import 'details/statistics_old.dart';
import 'details/summary_old.dart';
import '../../widgets/channel_power.dart';
import '../../widgets/dialog_loading.dart';
import '../../widgets/heading_channel_info.dart';
import '../../../views/widgets/info.dart';

class ChannelDetail extends StatelessWidget {
  final ChannelDetailController controller = Get.put(ChannelDetailController());
  final ChannelProfileController channelProfilecontroller = Get.put(ChannelProfileController());
  final AppStateController appStateController = Get.find();

  ChannelDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    // print("Ini controller.channel: ${controller.channel}");
    // print("ini channel detail: ${controller.channelDetail}");
    // print("ini yang summary: ${summaryChannelsController.channel}");
    // print("ini error: ${ModalRoute.of(context)?.settings.arguments}");
    if (ModalRoute.of(context)?.settings.arguments is int) {
      controller.channel = ModalRoute.of(context)?.settings.arguments as int;
      
      SummaryChannelsController summaryChannelsController =
          Get.put(SummaryChannelsController());
      summaryChannelsController.updateChannelValue(controller.channel);
      // ListActiveController listActiveController = Get.put(ListActiveController());
      // ListHistoryController listHistoryController = Get.put(ListHistoryController());
      // StatisticsChannelController statisticsChannelController = Get.put(StatisticsChannelController());
      controller.getChannel();
      // if (controller.isInit.value) {
      //   ChannelProfileController channelProfilecontroller =
      //   Get.put(ChannelProfileController());
      //   channelProfilecontroller.channel?.value = controller.channelDetail;
      //   print("ini turasdasdasda: ${controller.channelDetail.name}");
      // }
      // listActiveController.channels.value = controller.channel;
    }
    List<Widget> tabsView = [
      SummaryChannels(controller.channel,
          controller.channelObs?.value?.createdTime ?? DateTime(0)),
    ];

    controller.tabController =
    TabController(length: 4, vsync: controller);

          if (channelProfilecontroller.channel == null || controller.isLoad.value) {
            // print(controller.channelObs == null || summaryController.hasLoad.value == false);
            return const Center(
              child: Text(
                "Tunggu ya..!!",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            );
          }
          if (controller.hasError.value) {
            if (controller.hasError.value
                .toString()
                .contains("ResultNotFoundError")) {
              return const Center(
                child: Text(
                  "Maaf.. data tidak ditemukan",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              );
            }
            // print("kena");
            return Info(onTap: controller.refreshChannel);
          }
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
            ),
          ];
          if (controller.channelDetail.username !=
                  appStateController.users.value.username &&
              controller.channelDetail.isPrivate == true &&
              controller.channelDetail.subscribed == true) {
            controller.tabController =
                TabController(length: 1, vsync: controller);
            tabs = const [
              Tab(
                text: "CONTACT",
              )
            ];
          }
          if (controller.channelDetail.username !=
                  appStateController.users.value.username &&
              controller.channelDetail.isPrivate == true &&
              controller.channelDetail.subscribed == true) {
            tabsView = [ContactChannel(controller.channelDetail)];
          }
          void onTapItem(int index) {
            controller.tabIndex.value = index;
            controller.tabController.index = index;
            if (controller.tabController.index == 1) {
              ListActiveController listActiveController = Get.put(ListActiveController());
              listActiveController.channels.value = controller.channel;
              if (listActiveController.isInit.value) {
                tabsView.add(
                ListActiveSignal(
                controller.channel,
                controller.channelObs?.value?.subscribed != null ||
                    controller.channelObs?.value?.username ==
                        appStateController.users.value.username),
              );
              }
            }
            if (controller.tabController.index == 2) {
              ListHistoryController listHistoryController = Get.put(ListHistoryController());
              listHistoryController.channels.value = controller.channel;
              if (listHistoryController.isInit.value) {
                tabsView.add(
                ListHistorySignal(
                controller.channel,
                controller.channelObs?.value?.subscribed != null ||
                    controller.channelObs?.value?.username ==
                        appStateController.users.value.username),
              );
              }
            } 
            if (controller.tabController.index == 3) {
              tabsView.add(
                StatisticsChannel(controller.channel)
              );
            } 
          }
    
    return Obx(
      () => Scaffold(
          appBar: NavTxt.getx(
            title: controller.titleObs,
          ),
          body:  NestedScrollView(
            controller: controller.scrollController,
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
                  expandedHeight:
                      780 < MediaQuery.of(context).size.width ? 220 : 285,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: SmartRefresher(
                      controller: controller.refreshController,
                      enablePullDown: true,
                      enablePullUp: false,
                      onRefresh: controller.refreshChannel,
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: ChannelProfile(
                          channel: controller.channelDetail,
                          refreshController: controller.refreshController,
                        ),
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    isScrollable: true,
                    labelColor: AppColors.primaryGreen,
                    labelStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                    unselectedLabelColor: AppColors.darkGrey,
                    unselectedLabelStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
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
            body: tabsView.elementAt(controller.tabIndex.value)
          )
          ),
    );
  }
}

class ChannelProfile extends StatelessWidget {
  final ChannelCardSlim channel;
  final RefreshController? refreshController;
  ChannelProfile({Key? key, required this.channel, this.refreshController}) : super(key: key);

  final AppStateController appStateController = Get.find();
  final ChannelProfileController controller = Get.find();

  double paddingBtn = 0;
  List<Widget> listWidget = [];
  Widget btnSubs = const SizedBox();
  int tabView = 780;

  RxString price = "0".obs;

  RxDouble channelProfit = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    controller.setChannel(channel);
    
    if (channel.price != null) {
      if (channel.price! > 1) {
        price.value = numberShortener(channel.price!.floor());
      } else {
        price.value = "FREE";
      }
    }
    bool isTab = false;
    if (channel.profit != null) {
      channelProfit.value = channel.profit!;
    }
    if (tabView < MediaQuery.of(context).size.width) {
      isTab = true;
    }
    double minWidth = !isTab ? MediaQuery.of(context).size.width / 2 : 0;
    if (channel.username == appStateController.users.value.username) {
      paddingBtn = 15;
      btnSubs = TextButton(
        onPressed: () {
          Get.toNamed('/dsc/channels/new', arguments: {
            "channel": channel,
            "appStateController": appStateController.users.value
          });
        },
        child:
            const Text("Edit Channel", style: TextStyle(color: Colors.white)),
        style: TextButton.styleFrom(
            backgroundColor: AppColors.primaryYellow,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(horizontal: 20)),
      );
    } else if (channel.subscribed == true) {
      paddingBtn = 15;
      int maxDay = remoteConfig.getInt("ois_can_extend_subs_days");
      DateTime subsExp = channel.subsExpired!;
      DateTime now = DateTime.now();
      if (channel.price! > 0 &&
          now.isAfter(subsExp.subtract(Duration(days: maxDay)))) {
        btnSubs = PopupMenuButton<String>(
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
                        style: TextStyle(color: Colors.white)),
                    WidgetSpan(
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onSelected: (value) {
            switch (value) {
              case "1":
                subcribeChannel(channel, context, refreshController!);
                break;
              case "2":
                confirmPayment(channel, context, refreshController!);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: "1", child: Text("Unsubscribe")),
            const PopupMenuItem<String>(
              value: "2",
              child: Text('Extend Subscription'),
            ),
          ],
        );
      } else {
        btnSubs = ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth),
          child: TextButton(
              onPressed: () {
                subcribeChannel(channel, context, refreshController!);
              },
              child: const Text(
                "Unsubscribe",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                backgroundColor: Colors.grey[400],
                padding: const EdgeInsets.only(left: 20, right: 20),
              )),
        );
      }
    } else {
      paddingBtn = 0;
      btnSubs = Obx(
        () => ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth),
          child: TextButton(
              onPressed: () {
                subcribeChannel(channel, context, refreshController!);
              },
              child: Text(
                channel.isPrivate == true
                    ? "Subscribe with TOKEN"
                    : "Subscribe  |  " + price.value,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              )),
        ),
      );
    }

    Widget btnChannel = Container(
      height: 40,
      // alignment: Alignment.topRight,
      margin: const EdgeInsets.only(right: 15),
      child: ListView(
        // padding: EdgeInsets.only(left: paddingBtn),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          btnSubs,
          channel.username == appStateController.users.value.username
              ? const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                )
              : const Text(""),
        ],
      ),
    );

    return Obx(() {
      if (controller.isInit.value == false || channel.medals == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
        return Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: HeadingChannelInfo(
                  trailing: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        if (controller.channel?.value?.username !=
                            appStateController.users.value.username)
                          if (channel.subscribed == true)
                            IconButton(
                              onPressed: () async {
                                String txtAlert = "";
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return DialogLoading();
                                    });
                                if (channel.mute == false) {
                                  txtAlert = "tidak ";
                                }
                                await ChannelModel.instance.muteChannel(
                                    channelid: channel.id, mute: channel.mute);
                                refreshController?.requestRefresh(
                                    needMove: false);
                                Navigator.pop(context);
                                showAlert(context, LoadingState.success,
                                    "Anda ${txtAlert}akan menerima notifikasi signal dari channel ini");
                              },
                              icon: Icon(
                                channel.mute == true
                                    ? Icons.notifications_off
                                    : Icons.notifications_active,
                                color: channel.mute == true
                                    ? Colors.grey[600]
                                    : AppColors.primaryGreen,
                                size: 28,
                              ),
                            ),
                        if (isTab) btnChannel,
                      ],
                    ),
                  ),
                  isLarge: true,
                  avatar: channel.avatar,
                  level: controller.medal.value,
                  medals: channel.medals,
                  title: channel.name,
                  subscriber: channel.subscriber),
            ),
            const SizedBox(
              height: 10,
            ),
            if (!isTab) btnChannel,
            if (!isTab)
              const SizedBox(
                height: 20,
              ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ChannelPower(
                      title: numberShortener(channelProfit.value.floor() * 10000),
                      subtitle: "Profit"),
                ),
                Expanded(
                  child: ChannelPower(
                    title: "${channel.weekAge}",
                    subtitle: "Minggu",
                  ),
                ),
              ],
            )
          ],
        );
      }
    );
  }
}
