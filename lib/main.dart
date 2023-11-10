// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:saham_01_app/constants/app_route.dart';
import 'package:saham_01_app/controller/signal_tab_controller.dart';
import 'package:saham_01_app/remote_config.dart';
import 'package:saham_01_app/splash_screen_new.dart';
import 'package:saham_01_app/views/pages/add_new_signal.dart';
import 'package:saham_01_app/views/pages/channels/channel_detail.dart';
import 'package:saham_01_app/views/pages/channels/form/new_channel.dart';
import 'package:saham_01_app/views/pages/channels/form/payment.dart';
import 'package:saham_01_app/views/pages/channels/form/payment_status.dart';
import 'package:saham_01_app/views/pages/channels/form/paymet_detail.dart';
import 'package:saham_01_app/views/pages/channels/form/withdraws.dart';
import 'package:saham_01_app/views/pages/channels/my_channels.dart';
import 'package:saham_01_app/views/pages/channels/my_subscribers.dart';
import 'package:saham_01_app/views/pages/channels/my_subscription.dart';
import 'package:saham_01_app/views/pages/channels/signal_detail.dart';
import 'package:saham_01_app/views/pages/form/forgot.dart';
import 'package:saham_01_app/views/pages/form/register.dart';
import 'package:saham_01_app/views/pages/more/mrg/mrg.dart';
import 'package:saham_01_app/views/pages/more/ois/ois_dashboard.dart';
import 'package:saham_01_app/views/pages/more/profile/forms/edit_password.dart';
import 'package:saham_01_app/views/pages/more/profile/profile.dart';
import 'package:saham_01_app/views/pages/refresh_page.dart';
import 'package:saham_01_app/views/pages/search/search_domisili.dart';
import '../../constants/app_colors.dart';
import 'controller/app_state_controller.dart';
import 'controller/growth_chart_controller.dart';
import '../../core/analytics.dart';
import '../../core/config.dart';
import 'core/get_storage.dart';
import '../../firebase_options.dart';
import 'package:flutter/material.dart';
import '../../maintenance.dart';
import '../../models/user.dart';
import 'package:get/get.dart';
import 'update_version.dart';
import 'views/pages/channels/search_channel.dart';
import 'views/pages/form/edit_profile.dart';
import '../../views/pages/form/login.dart';
import '../../views/pages/market.dart';
import 'views/pages/search/search_channels_pop.dart';
import '../../views/pages/setting.dart';
import 'views/pages/signal_page.dart';
import 'views/widgets/dialog_confirmation.dart';
// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
// import 'package:redux/redux.dart';
// import '../../updateVersion.dart';
import 'controller/check_internet_controller.dart';
import 'controller/home_tab_controller.dart';
import 'views/pages/home.dart';
import 'views/widgets/get_alert.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'traders-family-app',
    options: DefaultFirebaseOptions.currentPlatform,
  );
   Get.put(AppStateController());
   Get.put(NewHomeTabController());
   Get.put(CheckInternetController());
  // Get.put(DialogLoadingController());
  Get.put(GrowthChartController());
  Get.put(HomeTabController());
  Get.put(DialogController());

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
    // MrgModel.fetchUserData().catchError((onError) {
    //   print("MrgModel.fetchUserData: $onError");
    // });
    // AskapModel.fetchUserData().catchError((onError) {
    //   print("AskapModel.fetchUserData: $onError");
    // });
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

  runApp(const NewMyApp());
}

// class AppStateController extends GetxController {
//   final _storage = GetStorage();

//   final Rx<AppState> _state = AppState(
//     user: UserInfo.init(),
//     homeTab: HomeTab.home
//   ).obs;
// }

class NewMyApp extends StatelessWidget {
  const NewMyApp({Key? key}) : super(key: key);

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
          ),
        ),
        fontFamily: 'Manrope',
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: AppRoutes.home, page: () =>  NewHomePage()),
        // GetPage(name: '/homes', page: () => const HomePage(), binding: HomeBinding()),
        GetPage(name: AppRoutes.remoteConfig, page: () => const RemoteConfigView()),
        GetPage(name: '/homepage', page: () => Home()),
        GetPage(name: AppRoutes.channelSignal, page: () => SignalDashboard()),
        GetPage(name: AppRoutes.maintenance, page: () => const MaintenanceView()),
        GetPage(name: AppRoutes.updateApp, page: () => UpdateVersionView()),
        GetPage(name: AppRoutes.refresh, page: () => RefreshPage()),

        GetPage(name: AppRoutes.login, page: () => Login()),
        GetPage(name: AppRoutes.register, page: () => Register()),
        GetPage(name: AppRoutes.editProfile, page: () => const EditProfile()),
        GetPage(name: AppRoutes.editPassword, page: () => EditPassword()),
        GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPassWord()),
        GetPage(name: AppRoutes.profile, page: () => Profile()),
        GetPage(name: AppRoutes.copySignal, page: () => OisDashboard()),
        GetPage(name: AppRoutes.dashboard2, page: () => OisDashboard()),
        GetPage(name: AppRoutes.newChannels, page: () => NewChannels()),

        GetPage(name: AppRoutes.searchChannelsPop, page: () => SearchChannelsPop()),
        GetPage(name: AppRoutes.searchDomisili, page: () => SearchDomisili()),

        GetPage(name: AppRoutes.searchChannelsTab, page: () => SearchChannelsTab()),
        GetPage(name: AppRoutes.channelDetail, page: () => ChannelDetailNew()),
        GetPage(name: AppRoutes.newSignal, page: () => AddNewSignal()),
        GetPage(name: AppRoutes.signalDetail, page: () => SignalDetail()),
        GetPage(name: AppRoutes.myChannel, page: () => MyChannels()),
        GetPage(name: AppRoutes.subscribers, page: () => MySubscribers()),
        GetPage(name: AppRoutes.mySubscription, page: () => MySubscription()),
        GetPage(name: AppRoutes.withdraw, page: () => Withdraw()),

        GetPage(name: AppRoutes.mrg, page: () => Mrg()),

        GetPage(name: AppRoutes.channelPayment, page: () => Payment()),
        GetPage(name: AppRoutes.paymentDetail, page: () => PaymentDetails()),
        GetPage(name: AppRoutes.paymentStatus, page: () => PaymentStatus())
      ],
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewHomePage extends StatelessWidget {
  final NewHomeTabController newHomeTabController = Get.find();
  final AppStateController appStateController = Get.find();

  final layoutPage = [
    Home(),
    SignalDashboard(),
    AddNewSignal(),
    const MarketPage(),
    Setting(),
  ];
  

  NewHomePage({Key? key}) : super(key: key);

  void onTapItem(int index) {
    // if(appStateController.homeTab.value == HomeTab.values[index]) {
    //   Widget temp = newHomeTabController.layoutPage[index];
    //   if (temp is ScrollUpWidget) {
    //     (temp as ScrollUpWidget).onResetTab();
    //   }
    // print("udah if");
    // print("udah firebase");
    // print("udah setstate");
    // }
    if (index != 1 && HomeTab.values[index] != HomeTab.signal) {
      var controller = Get.find<SignalDashboardController>();
      var controller2 = Get.find<ListChannelWidgetController>();
      controller.tabController.animateTo(0, duration: const Duration(microseconds: 500));
      controller2.sort.value = 0;
      controller2.onRefreshChannel();
    }
    FirebaseCrashlytics.instance.log("Home Screen: ${HomeTab.values[index]}");
    newHomeTabController.tab.value = HomeTab.values[index];
    // appStateController.setAppState(Operation.bringToHome, HomeTab.values[index]);
  }


  @override
  Widget build(BuildContext context) {
    double fontSizes(BuildContext context) {
      var size = MediaQuery.of(context).size.width;
      if (size <= 320.0) {
        return 7;
      }
      if (size <= 375.0) {
        return 9;
      }
      if (size <= 400.0) {
        return 10;
      }
      if (size <= 600.0) {
        return 11;
      }
      if (size <= 900.0) {
        return 13;
      }
      if (size > 900.0) {
        return 15;
      }
      return 0;
    }

    List<Tab> tabViews = [
      Tab(
        icon: Image.asset(
          'assets/icon/bottomNavBar/home.png',
          width: 24,
          height: 24,
        ),
        child: Text("Beranda", style: TextStyle(fontSize: fontSizes(context))),
      ),
      Tab(
        icon: Image.asset(
          'assets/icon/bottomNavBar/compass 1.png',
          width: 24,
          height: 24,
        ),
        child: Text("Jelajahi", style: TextStyle(fontSize: fontSizes(context))),
      ),
      Tab(
        icon: Image.asset(
          'assets/icon/bottomNavBar/plus-circle 1.png',
          width: 24,
          height: 24,
        ),
        child: Text("Signal", style: TextStyle(fontSize: fontSizes(context))),
      ),
      Tab(
        icon: Image.asset(
          'assets/icon/bottomNavBar/bar-chart.png',
          width: 24,
          height: 24,
        ),
        child: Text("Market", style: TextStyle(fontSize: fontSizes(context))),
      ),
      Tab(
        icon: Image.asset(
          'assets/icon/bottomNavBar/user 1.png',
          width: 24,
          height: 24,
        ),
        child: Text("Profile", style: TextStyle(fontSize: fontSizes(context))),
      ),
    ];
      return Obx(() {
        print(MediaQuery.of(context).size.width);
          return WillPopScope(
            onWillPop: () async {
              if (newHomeTabController.tab.value == HomeTab.home) {
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
                  });
                return result;
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.light,
              body: layoutPage.elementAt(newHomeTabController.tab.value.index),
              bottomNavigationBar: Container(
                height: 90,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0)
                  ),
                ),
                child: TabBar(
                  controller: newHomeTabController.tabController,
                  padding: const EdgeInsets.all(0),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
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
                  onTap: onTapItem,
                ),
              ),
            ),
          );
        }
      );
  }
}
