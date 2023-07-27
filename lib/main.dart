import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_storage/get_storage.dart';
import 'package:saham_01_app/config/tab_list.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/core/getStorage.dart';
// import 'package:saham_01_app/controller/homeTabController.dart';
import 'package:saham_01_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:saham_01_app/maintenance.dart';
import 'package:saham_01_app/models/askap.dart';
import 'package:saham_01_app/models/entities/user.dart';
import 'package:saham_01_app/models/inbox.dart';
import 'package:saham_01_app/models/mrg.dart';
import 'package:saham_01_app/models/user.dart';
import 'package:saham_01_app/splashScreen.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/views/pages/market.dart';
import 'package:saham_01_app/views/pages/setting.dart';
import 'package:saham_01_app/views/widgets/dialogConfirmation.dart';
// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
// import 'package:redux/redux.dart';
// import 'package:saham_01_app/updateVersion.dart';
import 'interface/scrollUpWidget.dart';
import 'views/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'traders-family-app',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // store = Store<AppState>(reducer,
  //     initialState: AppState(
  //       user: UserInfo.init(),
  //       homeTab: HomeTab.home,
  //     ));

  try {
    RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(hours: 1));
    remoteConfig = RemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    String mixpanelToken = remoteConfig.getString("mixpanel_token");
    // if (mixpanelToken != '') {
    //   mixpanel =
    //       await Mixpanel.init(mixpanelToken, optOutTrackingDefault: false);
    //   mixpanel.track(MixpanelEvent.appOpen);
    // }

    // await StorageHelper.instance.init();
    await UserModel.instance.refreshController();
    await InboxModel.instance.updateInboxCountAsync();
    // // fetch and dispatch redux on background for mrg and askap
    MrgModel.fetchUserData().catchError((onError) {
      print("MrgModel.fetchUserData: $onError");
    });
    AskapModel.fetchUserData().catchError((onError) {
      print("AskapModel.fetchUserData: $onError");
    });
  } catch (x) {
    print("Main: $x");
  }
  

  runApp(const MyApp());
}

// class AppStateController extends GetxController {
//   final _storage = GetStorage();

//   final Rx<AppState> _state = AppState(
//     user: UserInfo.init(),
//     homeTab: HomeTab.home
//   ).obs;
// }

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Saham XYZ App',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: AppColors.black),
          contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.2,
              color: AppColors.darkGrey4,
            ),
          )
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/home', page: () => const  MyHomePage()),
        GetPage(name: '/homepage', page: () => Home()),
        GetPage(name: '/maintenance', page: () => MaintenanceView()),
        // GetPage(name: '/update-app', page: () => UpdateVersionView()),
      ],
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put<AppStateController>(AppStateController());
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver, TickerProviderStateMixin {
  final _layoutPage = [
    Home(),
    MarketPage(),
    Setting()
    // SignalDashboard(),
    // NewSignalsTab(),
    // InboxTabListTile(),
    // Setting()
  ];

  TabController _tabController;
  final appStateController = Get.find<AppStateController>();

  void _onTapItem(int index) {
    final appStateController = Get.find<AppStateController>();
    if (appStateController.currentTab == HomeTab.values[index]) {
      StatefulWidget temp = _layoutPage[index];
      if (temp is ScrollUpWidget) {
        (temp as ScrollUpWidget).onResetTab();
      }
    }
    // FirebaseCrashlytics.instance.log("Home Screen: ${HomeTab.values[index]}");
    appStateController.setHomeTab(HomeTab.values[index]);
  }

  // void _onTapItem(int index) {
  //   // Navigator.popUntil(context, ModalRoute.withName("/forms/editprofile"));
  //   if (store!.state.homeTab == HomeTab.values[index]) {
  //     StatefulWidget temp = _layoutPage[index];
  //     if (temp is ScrollUpWidget) {
  //       (temp as ScrollUpWidget).onResetTab();
  //     }
  //   }
  //   // FirebaseCrashlytics.instance.log("Home Screen: ${HomeTab.values[index]}");
  //   // store.dispatch(RouteReducer(
  //   //     operation: Operation.bringToHome, payload: HomeTab.values[index]));
  // }
  

  // UserInfo user;
  // Widget iconProfile;

  @override
  void initState() {
    super.initState();
    // _homeTabController = Get.put(HomeTabController());
    _tabController = TabController(length: tabViews.length, vsync: this);
  }


  double bottomMenuSize = 24;

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return GetX<AppStateController>(
      builder: (controller) {
      
      final tab = controller.homeTab.value;
      _tabController.animateTo(tab.index);
      return WillPopScope(
        onWillPop: () async {
          if (tab != HomeTab.home) {
            appStateController.setAppState(Operation.bringToHome, HomeTab.home);
            return false;
          } else {
            bool result = await showDialog(
              context: context,
              builder: (ctx) {
                return const DialogConfirmation(
                  title: 'Peringatan',
                  desc: 'Anda yakin ingin keluar dari aplikasi',
                  caps: 'KELUAR',
                );
              }
            );
            return result;
          }
        },
        child: Scaffold(
          body: _layoutPage.elementAt(tab.index),
          bottomNavigationBar: Container(
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                // indicatorPadding: EdgeInsets.all(5.0),
                indicatorColor: Colors.blue,
                indicator: BoxDecoration(
                  border: const Border(
                    top: BorderSide(color: Color(0xFF350699), width: 3.0),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2E2AFF).withOpacity(0.1),
                      const Color(0xFF2E2AFF).withOpacity(0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                tabs: tabViews,
                onTap: _onTapItem,
              ),
            ),
          ),
        ));
      }
    );
  }
}
