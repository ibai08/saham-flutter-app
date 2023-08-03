import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/interface/scrollUpWidget.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/signal.dart';
import 'package:saham_01_app/views/appbar/navChannelNew.dart';
import 'package:saham_01_app/views/appbar/navmain.dart';
import 'package:saham_01_app/views/pages/form/login.dart';
import 'package:saham_01_app/views/widgets/info.dart';
import 'package:saham_01_app/views/widgets/signalListWidgetNew.dart';
import 'package:saham_01_app/views/widgets/signalShimmer.dart';

class SignalDashboardController extends GetxController with GetSingleTickerProviderStateMixin {
  late RefreshController refreshController ;
  late TabController _tabController;
  ScrollController _scrollController = ScrollController();
  late Level medal;
  late List<Widget> tabBodies;
  final AppStateController appStateController = Get.put(AppStateController());

  void onTabChanged() {
    if (tabBodies[_tabController.index] is ScrollUpWidget) {
      _onResetTabChild = (tabBodies[_tabController.index] as ScrollUpWidget).onResetTab;
    }
  }

  onResetTabs() {
    _onResetTabChild();
  }

  Function _onResetTabChild = () {};


  void onInit() {
    super.onInit();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      if (appStateController.users.value.id < 1 || appStateController.users.value.verify!) {
        return;
      } else if (appStateController.users.value.id > 0 && appStateController.users.value.isProfileComplete()) {
        Get.toNamed("/forms/editprofile");
      }
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(onTabChanged);
    _scrollController = ScrollController();

    print("hello: ${_onResetTabChild}");

    tabBodies = <Widget>[
      ListSignalWidget(),
      Text("test")
    ];

    if (tabBodies[_tabController.index] is ScrollUpWidget) {
      _onResetTabChild = (tabBodies[_tabController.index] as ScrollUpWidget).onResetTab;
    }

  }

  List<Widget> getTabTitle() {
    return const <Widget>[
      Tab(
        child: Text(
          "Channel",
          style: TextStyle(fontFamily: 'Manrope'),
        ),
      ),
      Tab(
        child: Text(
          "Signal",
          style: TextStyle(fontFamily: 'Manrope'),
        ),
      )
    ];
  }

  void onCLose() {
    _tabController.removeListener(onTabChanged);
    _tabController.dispose();
    super.onClose();
  }
}

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
          controller: signalDashboardController._scrollController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              Container(
                child: SliverAppBar(
                  backgroundColor: const Color.fromRGBO(242, 246, 247, 1),
                  expandedHeight: 10,
                  // flexibleSpace: NavChannelNew(
                  //   context: context,
                  //   state: NavChannelNewState.basic,
                  //   popTo: '/search/channels/pop',
                  // ),
                  bottom: TabBar(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    labelColor: Colors.black,
                    unselectedLabelStyle: const TextStyle(fontSize: 16),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    indicatorWeight: 1,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: AppColors.blueGem,
                    tabs: signalDashboardController.getTabTitle(),
                    controller: signalDashboardController._tabController,
                  ),
                ),
              )
            ];
          },
          body: TabBarView(
            children: signalDashboardController.tabBodies,
            controller: signalDashboardController._tabController,
          ),
        ),
      ),
    );
  }

  @override
  onResetTab() {
    signalDashboardController._onResetTabChild;
  }

  @override
  RefreshController get refreshController => throw UnimplementedError();
}

class ListSignalWidgetController extends GetxController {
  RxList<SignalCardSlim> _dataSignal = RxList<SignalCardSlim>();

  final RefreshController refreshController = RefreshController(initialRefresh: false);

  RxInt filter = 0.obs;
  RxInt page = 0.obs;
  Rx<Level?> medal = Rx<Level?>(null);
  RxInt loadingFilter = 0.obs;

  Future<void> initializePageSignalAsync({bool clearCache = false}) async {
    try {
      _dataSignal.clear();
      List<SignalCardSlim>? recentSignal = await SignalModel.instance.getRecentSignalAsync(filter: filter.value);
      _dataSignal.addAll(recentSignal!);
      var result = await getMedal();
      medal.value = result;
    } catch (err) {
      throw(err.toString());
    }
  }

  void _onRefreshSignal() async {
    await initializePageSignalAsync(clearCache: true);
    refreshController.refreshCompleted();
  }

  void _onLoadSignal() async {
    try {
      List<SignalCardSlim>? recentSignal = await SignalModel.instance.getRecentSignalAsync(offset: _dataSignal.length, filter: filter.value);
      recentSignal = recentSignal!.where((test) => !recentSignal!.contains(test.signalid)).toList();
      if (recentSignal.length > 0) {
        _dataSignal.addAll(recentSignal);
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (x) {
      refreshController.loadNoData();
    }

    filter.value = filter.value;
  }

  Future<Level> getMedal({bool clearCache = false}) async {
    return ChannelModel.instance.getMedalList(clearCache: clearCache);
  }

  onResetTab() {
    refreshController.position?.moveTo(0, duration: const Duration(milliseconds: 600));
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      initializePageSignalAsync();
    });
  }
} 

class ListSignalWidget extends GetWidget<ListSignalWidgetController> implements ScrollUpWidget {
  ListSignalWidget({Key? key}) : super(key: key);

  final ListSignalWidgetController controller = Get.put(ListSignalWidgetController());

  @override
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
          if (controller._dataSignal.isEmpty) {
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
                    onRefresh: controller._onRefreshSignal,
                    onLoading: controller._onLoadSignal,
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
                          controller._dataSignal,
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

  final RefreshController refreshController = RefreshController(initialRefresh: false);
}