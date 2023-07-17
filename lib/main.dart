import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:saham_01_app/config/tab_list.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/homeTabController.dart';
import 'package:saham_01_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:saham_01_app/maintenance.dart';
import 'package:saham_01_app/models/entities/user.dart';
import 'package:saham_01_app/splashScreen.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/utils/store/appstate.dart';
import 'package:saham_01_app/utils/store/route.dart';
import 'package:saham_01_app/views/pages/market.dart';
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

  // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // store = Store<AppState>(reducer,
  //     initialState: AppState(
  //       user: UserInfo.init(),
  //       homeTab: HomeTab.home,
  //     ));

  
  Get.put(HomeTabController());
  runApp(const MyApp());
}

class AppStateController extends GetxController {
  final _storage = GetStorage();

  final Rx<AppState> _state = AppState(
    user: UserInfo.init(),
    homeTab: HomeTab.home
  ).obs;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver, TickerProviderStateMixin {
  final _layoutPage = [
    Home(),
    MarketPage()
    // SignalDashboard(),
    // NewSignalsTab(),
    // InboxTabListTile(),
    // Setting()
  ];

  late TabController _tabController;
  late HomeTabController _homeTabController;

  void _onTapItem(int index) {
    if (_homeTabController.currentTab == HomeTab.values[index]) {
      StatefulWidget temp = _layoutPage[index];
      if (temp is ScrollUpWidget) {
        (temp as ScrollUpWidget).onResetTab();
      }
    }
    // FirebaseCrashlytics.instance.log("Home Screen: ${HomeTab.values[index]}");
    _homeTabController.setHomeTab(HomeTab.values[index]);
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
    _homeTabController = Get.put(HomeTabController());
    _tabController = TabController(length: tabViews.length, vsync: this);
  }


  double bottomMenuSize = 24;

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return GetX<HomeTabController>(
      builder: (controller) {
      
      final tab = controller.homeTab.value;
      _tabController.animateTo(tab.index);
      return WillPopScope(
        onWillPop: () async {
          if (tab != HomeTab.home) {
            Get.until((route) => Get.currentRoute == '/home');
            return false;
          } else {
            bool result = await showDialog(
              context: context,
              builder: (ctx) {
                return DialogConfirmation(
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
