// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../constants/app_colors.dart';
import '../../controller/appStatesController.dart';
import '../../controller/signalTabController.dart';
import '../../function/sortChannelModal.dart';
import '../../interface/scrollUpWidget.dart';
import '../../models/channel.dart';
import '../../models/entities/ois.dart';
import '../../models/signal.dart';
import '../../views/appbar/navChannelNew.dart';
import '../../views/appbar/navmain.dart';
import '../../views/pages/form/login.dart';
import '../../views/widgets/channelListWidget.dart';
import '../../views/widgets/info.dart';
import '../../views/widgets/signalListWidgetNew.dart';
import '../../views/widgets/signalShimmer.dart';

class SignalDashboard extends StatelessWidget implements ScrollUpWidget {
  final SignalDashboardController signalDashboardController =
      Get.put(SignalDashboardController());

  final AppStateController appStateController = Get.put(AppStateController());

  SignalDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("kebuild");
    if (appStateController.users.value.id < 1 &&
        !appStateController.users.value.verify!) {
      return const Login();
    } 
    if (appStateController.users.value.id > 0 &&
        !appStateController.users.value.isProfileComplete()) {
      return Scaffold(
        appBar: NavMain(
          currentPage: "Jelajahi",
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Info(
            caption: "Lengkapi Profil",
            title: "Oops...",
            desc: "Mohon lengkapi profil anda terlebih dahulu",
            onTap: () {
              // Navigator.pushNamed(context, "/forms/editprofile");
              Get.toNamed('/forms/editprofile');
            },
          ),
        ),
      );
    }
    return Scaffold(
      appBar: NavMain(
        currentPage: "Jelajahi",
        backPage: () async {
          appStateController.setAppState(Operation.bringToHome, HomeTab.home);
        },
      ),
      backgroundColor: AppColors.light,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: signalDashboardController.scrollController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              Container(
                child: SliverAppBar(
                  shadowColor: Colors.transparent,
                  pinned: true,
                  floating: true,
                  backgroundColor: AppColors.light,
                  // leadingWidth: 20,
                  expandedHeight: 100,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: NavChannelNew(
                      context: context,
                      state: NavChannelNewState.basic,
                      popTo: '/search/channels/pop',
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(48 + 10),
                    child: Column(
                      children: [
                        TabBar( 
                          padding: const EdgeInsets.only(left: 22.5, right: 22.5, top: 10),
                          labelColor: AppColors.blueGem,
                          unselectedLabelColor: AppColors.darkGrey2,
                          unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Manrope'),
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'Manrope'),
                          indicatorWeight: 0.5,
                          automaticIndicatorColorAdjustment: false,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorColor: AppColors.blueGem,
                          tabs: signalDashboardController.getTabTitle(),
                          controller: signalDashboardController.tabController,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 23, right: 23),
                          height: 1, // Atur tinggi indikator tambahan di sini
                          color: AppColors.darkGrey2,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ];
          },
          body: TabBarView(
            children: signalDashboardController.tabBodies,
            controller: signalDashboardController.tabController,
          ),
        ),
      ),
    );
  }

  @override
  onResetTab() {
    signalDashboardController.onResetTabChild;
  }

  @override
  RefreshController get refreshController => throw UnimplementedError();
}

class ListSignalWidget extends StatelessWidget {
  ListSignalWidget({Key? key}) : super(key: key);

  @override
  final ListSignalWidgetController controller =
      Get.put(ListSignalWidgetController());

  bool wantKeepAlive = true;
  List datas = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          // if (controller._dataSignal.isEmpty) {
          //   return SignalShimmer(
          //     title: "",
          //     onLoad: "1",
          //   );
          // }
          // if (controller._dataSignal.)
          print("controller:controller.dataSignal");
          if (controller.dataSignal.isEmpty) {
            return SignalShimmer(
              title: "",
              onLoad: "1",
            );
          }

          if (controller.internet == false || controller.hasError.value && controller.dataSignal.isEmpty) {
            return Info(
              title: "Network Error",
              desc: "Jaringan Error",
              caption: "Coba Lagi",
              onTap: controller.onRefreshSignal,
            );
          }
          if (controller.dataSignal.length < 1) {
            return Info(
                title: "Oops...",
                desc: "Signal tidak ditemukan",
                caption: "Coba Lagi",
                onTap: () {
                  controller.filter.value = 0;
                  controller.onRefreshSignal();
                });
          }
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    controller: controller.refreshController,
                    onRefresh: controller.onRefreshSignal,
                    onLoading: controller.onLoadSignal,
                    footer: CustomFooter(
                      builder: ((context, mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = const Text("");
                        } else if (mode == LoadStatus.loading) {
                          body = SignalShimmer(
                            onLoad: "0",
                          );
                        } else if (mode == LoadStatus.failed) {
                          body = const Text("Load Failed! Click retry");
                        } else if (mode == LoadStatus.canLoading) {
                          body = const Text("Release to load more");
                        } else {
                          body = const Text("No more data");
                        }
                        return Center(
                          child: body,
                        );
                      }),
                    ),
                    child: ListView(
                      padding:
                          const EdgeInsets.only(top: 15, left: 12, right: 12),
                      children: <Widget>[
                        SignalListWidget(
                            controller.dataSignal, controller.medal.value)
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        })
      ],
    );
  }

}

class ListChannelWidget extends StatelessWidget implements ScrollUpWidget {
  final ListChannelWidgetController controller =
      Get.put(ListChannelWidgetController());
  // @override
  // final RefreshController refreshController = RefreshController(initialRefresh: false);

  ListChannelWidget({Key? key}) : super(key: key);
  bool wantKeepAlive = true;

  @override
  Widget build(BuildContext context) {
    print("index: ${controller.sort.value}");
    return Obx(() {
      
      return Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 14, bottom: 14, left: 22.5, right: 18),
            // padding: const EdgeInsets.only(left: 20),
            child: SortButtonsWidget(
              onSortChanged: (index) {
                print("berubah: ${controller.sort}");
                controller.sort.value = index;
                print("berubah2: ${controller.sort}");
                controller.onRefreshChannel();
                controller.refreshController.requestRefresh(needMove: false);
              },
              activeSortIndex: controller.sort,
            ),
          ),
          (controller.channelStream.value?.length == 0 && controller.dataChannel.value.length == 0 && controller.hasLoad.value == false) || controller.hasLoad.value == false ? SignalShimmer(
            onLoad: "1",
          ) : controller.channelStream.value!.length < 1 && controller.hasLoad.value == true ? Info(
            title: "Oops...",
            desc: "Channel tidak ditemukan",
            caption: "Coba Lagi",
            onTap: controller.onRefreshChannel,
          ) : controller.hasError.value == true ? Info(onTap: controller.onRefreshChannel) :  Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: Container(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    controller: controller.refreshController,
                    onRefresh: controller.onRefreshChannel,
                    onLoading: controller.onLoadChannel,
                    footer: CustomFooter(
                      builder: ((context, mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = const Text("");
                        } else if (mode == LoadStatus.loading) {
                          body = SignalShimmer(
                            title: "",
                            onLoad: "0",
                          );
                        } else if (mode == LoadStatus.failed) {
                          body = const Text("Load Failed! Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = const Text("Release to load more");
                        } else {
                          body = const Text("No more data");
                        }
                        return Container(
                          child: Center(child: body),
                        );
                      }),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 13, right: 13),
                            child: ChannelListWidget(
                              controller.channelStream.value!
                                .map((i) => ChannelModel.instance.getDetail(i, clearCache: true))
                                .toList(),
                              controller.refreshController,
                              controller.medal.value,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ),
                ),
              )
            ],
          )
        ],
      );
    });
  }

  @override
  onResetTab() {
    refreshController.position
        ?.moveTo(0, duration: const Duration(milliseconds: 600));
  }

  @override
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
}
