import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/controller/signalTabController.dart';
import 'package:saham_01_app/function/sortChannelModal.dart';
import 'package:saham_01_app/interface/scrollUpWidget.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/signal.dart';
import 'package:saham_01_app/views/appbar/navChannelNew.dart';
import 'package:saham_01_app/views/appbar/navmain.dart';
import 'package:saham_01_app/views/pages/form/login.dart';
import 'package:saham_01_app/views/widgets/channelListWidget.dart';
import 'package:saham_01_app/views/widgets/info.dart';
import 'package:saham_01_app/views/widgets/signalListWidgetNew.dart';
import 'package:saham_01_app/views/widgets/signalShimmer.dart';


class SignalDashboard extends GetWidget<SignalDashboardController> implements ScrollUpWidget {
  final SignalDashboardController signalDashboardController = Get.put(SignalDashboardController());

  final AppStateController appStateController = Get.put(AppStateController());

  SignalDashboard({Key? key}) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
    if (appStateController.users.value.id < 1 && !appStateController.users.value.verify!) {
      return const Login();
    } else if (appStateController.users.value.id > 0 && !appStateController.users.value.isProfileComplete()) {
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
              Navigator.pushNamed(context, "/forms/editprofile");
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
                  backgroundColor: const Color.fromRGBO(242, 246, 247, 1),
                  expandedHeight: 10,
                  flexibleSpace: NavChannelNew(
                    context: context,
                    state: NavChannelNewState.basic,
                    popTo: '/search/channels/pop',
                  ),
                  bottom: TabBar(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    labelColor: Colors.black,
                    unselectedLabelStyle: const TextStyle(fontSize: 16),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    indicatorWeight: 1,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: AppColors.blueGem,
                    tabs: signalDashboardController.getTabTitle(),
                    controller: signalDashboardController.tabController,
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

 

class ListSignalWidget extends GetWidget<ListSignalWidgetController> implements ScrollUpWidget {
  ListSignalWidget({Key? key}) : super(key: key);

  @override
  final ListSignalWidgetController controller = Get.put(ListSignalWidgetController());

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
          if (controller.dataSignal.isEmpty) {
            return const SignalShimmer(
              title: "",
              onLoad: "1",
            );
          }
          // if (controller._dataSignal.length < 1) {
          //   return Info(
          //     title: "Oops...",
          //     desc: "Signal tidak ditemukan",
          //     caption: "Coba Lagi",
          //     onTap: () {
          //       controller.filter = 0 as RxInt;
          //       controller._onRefreshSignal();
          //     }
          //   );
          // }
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
                          body = const SignalShimmer(
                            onLoad: "0",
                          );
                        } else if (mode ==  LoadStatus.failed) {
                          body = const Text("Load Failed! Click retry");
                        } else if (mode == LoadStatus.canLoading) {
                          body = const Text("Release to load more");
                        } else {
                          body = const Text("No more data");
                        }
                        return Container(
                          child: Center(
                            child: body,
                          ),
                        );
                      }),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.only(top: 15, left: 12, right: 12),
                      children: <Widget>[
                        SignalListWidget(
                          controller.dataSignal,
                          controller.medal.value
                        )
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

  @override
  onResetTab() {
    refreshController.position?.moveTo(0, duration: const Duration(milliseconds: 600));
  }

  @override
  final RefreshController refreshController = RefreshController(initialRefresh: false);
}

class ListChannelWidget extends GetWidget<ListChannelWidgetController> {
  @override
  final ListChannelWidgetController controller = Get.put(ListChannelWidgetController());

  bool wantKeepAlive = true;
  

  @override
  Widget build(BuildContext context) {
    // print("channel: ${controller.dataChannel}");
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20),
          child: SortButtonsWidget(
            activeSortIndex: controller.sort.value,
            onSortChanged: (index) {
              controller.sort.value = index;
              controller.initializePageChannelAsync();
              controller.refreshController.requestRefresh(needMove: false);
            },
          ),
        ),
        Obx(() {
          if (controller.dataChannel.isEmpty) {
            return const SignalShimmer(
              title: "",
              onLoad: "1",
            );
          }
          return Column(
            children: [
              SizedBox(
                height: 45,
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
                          body = Text("");
                        } else if (mode == LoadStatus.loading) {
                          body = SignalShimmer(
                            title: "",
                            onLoad: "0",
                          );
                        } else if (mode == LoadStatus.failed) {
                          body = Text("Load Failed! Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("release to load more");
                        } else {
                          body = Text("No more Data");
                        }
                        return Container(
                          child: Center(child: body),
                        );
                      }),
                    ),
                    child: ListView(
                      padding: EdgeInsets.only(top: 10, left: 13, right: 13),
                      children: <Widget>[
                        ChannelListWidget(
                          controller.dataChannel.map((i) => ChannelModel.instance.getDetail(i, clearCache: true)).toList(),
                          controller.refreshController,
                          controller.medal.value
                        )
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