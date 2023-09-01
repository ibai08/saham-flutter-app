// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:saham_01_app/remoteConfig.dart';
import 'package:saham_01_app/views/pages/form/register.dart';
import 'package:saham_01_app/views/pages/more/profile/forms/editPassword.dart';
import 'package:saham_01_app/views/pages/more/profile/profile.dart';
import 'package:saham_01_app/views/pages/search/searchDomisili.dart';
import '../../config/tab_list.dart';
import '../../constants/app_colors.dart';
import '../../controller/appStatesController.dart';
import '../../controller/growthChartController.dart';
import '../../controller/signalTabController.dart';
import '../../core/analytics.dart';
import '../../core/config.dart';
import '../../core/firebasecm.dart';
import '../../core/getStorage.dart';
// import '../../controller/homeTabController.dart';
import '../../firebase_options.dart';
import 'package:flutter/material.dart';
import '../../maintenance.dart';
import '../../models/askap.dart';
import '../../models/mrg.dart';
import '../../models/user.dart';
import '../../splashScreen.dart';
import 'package:get/get.dart';
import '../../views/pages/channels/channelDetail.dart';
import '../../views/pages/channels/searchChannels.dart';
import '../../views/pages/form/editProfile.dart';
import '../../views/pages/form/login.dart';
import '../../views/pages/form/verifyEmail.dart';
import '../../views/pages/market.dart';
import '../../views/pages/search/searchChannelspop.dart';
import '../../views/pages/setting.dart';
import '../../views/pages/signalPage.dart';
import '../../views/widgets/dialogConfirmation.dart';
import '../../views/widgets/dialogLoading.dart';
// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
// import 'package:redux/redux.dart';
// import '../../updateVersion.dart';
import 'controller/checkInternetController.dart';
import 'controller/homeTabController.dart';
import 'interface/scrollUpWidget.dart';
import 'views/appbar/navChannelNew.dart';
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
        fetchTimeout: const Duration(seconds: 60),
        minimumFetchInterval: const Duration(hours: 1));
    remoteConfig = FirebaseRemoteConfig.instance;
    print("brshahsh");
    await remoteConfig.fetchAndActivate();
    SharedHelper.instance;

    // String mixpanelToken = remoteConfig!.getString("mixpanel_token");
    // if (mixpanelToken != '') {
    //   mixpanel =
    //       await Mixpanel.init(mixpanelToken, optOutTrackingDefault: false);
    //   mixpanel.track(MixpanelEvent.appOpen);
    // }

    await StorageController.instance.init();
    await UserModel.instance.refreshController();
    // await InboxModel.instance.updateInboxCountAsync();
    // // fetch and dispatch redux on background for mrg and askap
    MrgModel.fetchUserData().catchError((onError) {
      print("MrgModel.fetchUserData: $onError");
    });
    AskapModel.fetchUserData().catchError((onError) {
      print("AskapModel.fetchUserData: $onError");
    });
  } catch (x) {
    print("Main error di: $x");
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: Colors.white, // status bar color
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  firebaseAnalytics.setAnalyticsCollectionEnabled(true);
  firebaseAnalytics.logAppOpen();

  Get.put(CheckInternetController());
  Get.put(DialogLoadingController());
  Get.put(GrowthChartController());
  Get.put(HomeTabController());

  runApp(const MyApp());
}

// class AppStateController extends GetxController {
//   final _storage = GetStorage();

//   final Rx<AppState> _state = AppState(
//     user: UserInfo.init(),
//     homeTab: HomeTab.home
//   ).obs;
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FCM.instance.initializeFcmNotification();
    print("berhasil");
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomeTabController());
    return Builder(
      builder: (context) {
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
              ),
            ),
            fontFamily: 'Manrope',
          ),
          initialRoute: '/',
          getPages: [
            GetPage(name: '/home', page: () => const MyHomePage()),
            GetPage(name: '/remote-config', page: () => RemoteConfigView()),
            GetPage(name: '/homepage', page: () => Home()),
            GetPage(name: '/channel-signal', page: () => SignalDashboard()),
            GetPage(name: '/maintenance', page: () => MaintenanceView()),
            // GetPage(name: '/update-app', page: () => UpdateVersionView()),

            GetPage(name: '/forms/login', page: () => const Login()),
            GetPage(name: '/forms/register', page: () => Register()),
            GetPage(
                name: '/forms/editprofile', page: () => const EditProfile()),
            GetPage(name: '/forms/editpassword', page: () => EditPassword()),
            GetPage(name: '/more/profile', page: () => Profile()),

            GetPage(
                name: '/search/channels/pop', page: () => SearchChannelsPop()),
            GetPage(name: '/search/domisili', page: () => SearchDomisili()),

            GetPage(name: '/dsc/search', page: () => SearchChannelsTab()),
            GetPage(name: '/dsc/channels/', page: () => ChannelDetail())
          ],
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
          initialBinding: BindingsBuilder(() {
            Get.put<AppStateController>(AppStateController());
          }),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final _layoutPage = [
    Home(),
    SignalDashboard(),
    MarketPage(),
    Setting()
    // SignalDashboard(),
    // NewSignalsTab(),
    // InboxTabListTile(),
    // Setting()
  ];

  late TabController _tabController;
  final appStateController = Get.find<AppStateController>();

  void _onTapItem(int index) {
    print("onTapItem");
    print(index);
    final appStateController = Get.find<AppStateController>();
    final listChannelController = Get.find<ListChannelWidgetController>();
    if (appStateController.currentTab == HomeTab.values[index]) {
      Widget temp = _layoutPage[index];
      if (temp is ScrollUpWidget) {
        (temp as ScrollUpWidget).onResetTab();
      }
    }
    if (index != 2) {
      listChannelController.sort.value = 0;
      listChannelController.initializePageChannelAsync();
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
    return GetX<AppStateController>(builder: (controller) {
      final tab = controller.homeTab.value;
      _tabController.animateTo(tab.index);
      return WillPopScope(
          onWillPop: () async {
            if (tab != HomeTab.home) {
              appStateController.setAppState(
                  Operation.bringToHome, HomeTab.home);
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
                  });
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
    });
  }
}
