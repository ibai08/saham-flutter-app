import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:saham_01_app/maintenance.dart';
import 'package:saham_01_app/models/entities/user.dart';
import 'package:saham_01_app/splashScreen.dart';
import 'package:get/get.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:saham_01_app/utils/store/appstate.dart';
import 'package:saham_01_app/models/entities/inbox.dart';
import 'package:saham_01_app/utils/store/reducer.dart';
import 'package:saham_01_app/utils/store/reducer/operation.dart';
import 'package:saham_01_app/utils/store/reducer/route.dart';
import 'package:saham_01_app/utils/store/route.dart';
import 'package:saham_01_app/views/widgets/badgeCountNotif.dart';
import 'package:saham_01_app/views/widgets/dialogConfirmation.dart';
import 'package:redux/redux.dart';
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

  store = Store<AppState>(reducer,
      initialState: AppState(
        user: UserInfo.init(),
        homeTab: HomeTab.home,
      ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Saham XYZ App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      getPages: [
        GetPage(name: '/', page: () => const MyHomePage()),
        GetPage(name: '/home', page: () => const MyHomePage()),
        GetPage(name: '/maintenance', page: () => MaintenanceView()),
        // GetPage(name: '/update-app', page: () => UpdateVersionView()),
      ],
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final _layoutPage = [
    Home(),
    // SignalDashboard(),
    // NewSignalsTab(),
    // InboxTabListTile(),
    // Setting()
  ];

  void _onTapItem(int index) {
    // Navigator.popUntil(context, ModalRoute.withName("/forms/editprofile"));
    if (store!.state.homeTab == HomeTab.values[index]) {
      StatefulWidget temp = _layoutPage[index];
      if (temp is ScrollUpWidget) {
        (temp as ScrollUpWidget).onResetTab();
      }
    }
    // FirebaseCrashlytics.instance.log("Home Screen: ${HomeTab.values[index]}");
    // store.dispatch(RouteReducer(
    //     operation: Operation.bringToHome, payload: HomeTab.values[index]));
  }

  // UserInfo user;
  // Widget iconProfile;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //   this.initDynamicLinks();
  //   InboxModel.instance.updateInboxCountAsync();
  //   Future.delayed(Duration(seconds: 0)).then((value) async {
  //     if (Theme.of(context).platform == TargetPlatform.android) {
  //       await updateCfgAsync(ConfigKey.installReferrer, "Android");
  //       await initReferrerDetails();
  //     } else {
  //       await updateCfgAsync(ConfigKey.installReferrer, "iOS");
  //     }
  //   });
  // }

  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initReferrerDetails() async {
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     ReferrerDetails referrerDetails =
  //         await AndroidPlayInstallReferrer.installReferrer;
  //     updateCfgAsync(
  //         ConfigKey.installReferrer, referrerDetails.installReferrer);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // void handleDeepLink(Uri deepLink) async {
  //   if (deepLink != null) {
  //     // Navigator.pushNamed(context, deepLink.path);
  //     try {
  //       List<String> paths = deepLink.pathSegments;
  //       updateCfgAsync(ConfigKey.installReferrer, deepLink.toString());
  //       if (paths.length > 0) {
  //         switch (paths[0]) {
  //           case "channels":
  //             if (paths.length >= 2) {
  //               if (int.tryParse(paths[1]) != null) {
  //                 store.dispatch(RouteReducer(
  //                     operation: Operation.pushNamed,
  //                     payload: {
  //                       "route": "/dsc/channels/",
  //                       "arguments": int.parse(paths[1])
  //                     }));
  //                 return;
  //               }

  //               switch (paths[1]) {
  //                 case "new":
  //                   if (paths.length > 2) {
  //                     if (paths[2] == "signal") {
  //                       store.dispatch(RouteReducer(
  //                           operation: Operation.bringToHome,
  //                           payload: HomeTab.newSignal));
  //                       break;
  //                     }
  //                   }
  //                   store.dispatch(RouteReducer(
  //                       operation: Operation.pushNamed,
  //                       payload: {"route": "/dsc/channels/new"}));
  //                   break;
  //                 case "my":
  //                   store.dispatch(RouteReducer(
  //                       operation: Operation.pushNamed,
  //                       payload: {"route": "/dsc/channels/info"}));
  //                   break;
  //                 default:
  //                   store.dispatch(RouteReducer(
  //                       operation: Operation.bringToHome,
  //                       payload: HomeTab.signal));
  //                   break;
  //               }
  //               return;
  //             } else {
  //               store.dispatch(RouteReducer(
  //                   operation: Operation.bringToHome, payload: HomeTab.signal));
  //               return;
  //             }
  //             break;
  //           case "verify-email":
  //             if (paths.length >= 2 && paths[1] is String) {
  //               store.dispatch(RouteReducer(
  //                   operation: Operation.bringToHome, payload: HomeTab.home));
  //               store.dispatch(RouteReducer(
  //                   operation: Operation.pushNamed,
  //                   payload: {"route": "/forms/login", "arguments": paths[1]}));
  //             }
  //             break;
  //           case "aff":
  //             if (paths.length >= 2 && int.tryParse(paths[1]) != null) {
  //               if (store.state.user.id > 0) {
  //                 await UserModel.instance.logout();
  //               }
  //               updateCfgAsync(ConfigKey.installAff, paths[1]);

  //               store.dispatch(RouteReducer(
  //                   operation: Operation.bringToHome, payload: HomeTab.home));
  //               store.dispatch(RouteReducer(
  //                   operation: Operation.pushNamed,
  //                   payload: {"route": "/forms/register"}));
  //             }
  //             break;
  //           case "livechat":
  //             store.dispatch(RouteReducer(
  //                 operation: Operation.bringToHome, payload: HomeTab.home));
  //             store.dispatch(RouteReducer(
  //                 operation: Operation.pushNamed,
  //                 payload: {"route": "/livechat/"}));
  //             break;
  //         }
  //       }
  //     } catch (x) {
  //       FirebaseCrashlytics.instance.log('Dynamic Link Error: ${x.message}');
  //     }

  //     if (deepLink.hasQuery &&
  //         deepLink.queryParameters.containsKey("launch") &&
  //         deepLink.queryParameters["launch"] == "1") {
  //       launchURL(deepLink.toString());
  //     }
  //   }
  // }

  // void initDynamicLinks() async {
  //   final PendingDynamicLinkData data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri deepLink = data?.link;

  //   handleDeepLink(deepLink);

  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //     final Uri deepLink = dynamicLink?.link;
  //     handleDeepLink(deepLink);
  //   }, onError: (OnLinkErrorException e) async {
  //     FirebaseCrashlytics.instance.log('onLink Error: ${e.message}');
  //   });
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   switch (state) {
  //     case AppLifecycleState.detached:
  //       print("detached");
  //       break;
  //     case AppLifecycleState.inactive:
  //       print("inactive");
  //       break;
  //     case AppLifecycleState.paused:
  //       print("paused");
  //       break;
  //     case AppLifecycleState.resumed:
  //       print("resumed");
  //       break;
  //     default:
  //       break;
  //   }
  // }

  double bottomMenuSize = 24;

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeTab>(
        converter: (store) => store.state.homeTab,
        builder: (context, tab) {
          Widget badgeCount = StoreConnector<AppState, InboxCount>(
              converter: (store) => store.state.inboxCountTag,
              builder: (context, inboxCount) {
                try {
                  int total = inboxCount.total;
                  FlutterAppBadger.isAppBadgeSupported().then((value) {
                    if (value) {
                      FlutterAppBadger.updateBadgeCount(total);
                    }
                  });

                  return Positioned(
                      right: 0,
                      top: 0,
                      child: BadgeCountNotif(inboxCount: total));
                } catch (ex) {
                  return SizedBox();
                }
              });
          return WillPopScope(
            onWillPop: () async {
              if (tab != HomeTab.home) {
                store!.dispatch(RouteReducer(
                    operation: Operation.bringToHome, payload: HomeTab.home));
                return false;
              } else {
                bool result = await showDialog(
                    context: context,
                    builder: (ctx) {
                      return DialogConfirmation(
                        title: "Peringatan",
                        desc: "Anda yakin ingin keluar dari aplikasi?",
                        caps: "KELUAR",
                      );
                    });
                return result;
              }
            },
            child: Scaffold(
              body: _layoutPage.elementAt(tab.index),
              bottomNavigationBar: SizedBox(
                height: Platform.isIOS ? 95 : 75,
                child: BottomNavigationBar(
                  elevation: 28,
                  backgroundColor: Colors.white,
                  fixedColor: AppColors.primaryGreen,
                  unselectedItemColor: Colors.grey[600],
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                  selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                  selectedFontSize: 12,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/icon/light/home.png',
                        width: bottomMenuSize,
                        height: bottomMenuSize,
                      ),
                      activeIcon: Image.asset(
                        'assets/icon/light/home-active.png',
                        width: bottomMenuSize,
                        height: bottomMenuSize,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                        icon: Image.asset(
                          'assets/icon/light/signal.png',
                          width: bottomMenuSize,
                          height: bottomMenuSize,
                        ),
                        activeIcon: Image.asset(
                          'assets/icon/light/signal-active.png',
                          width: bottomMenuSize,
                          height: bottomMenuSize,
                        ),
                        label: 'Signal'),
                    BottomNavigationBarItem(
                      icon: Container(
                        height: 25,
                        child: OverflowBox(
                          maxHeight: 80,
                          child: Container(
                            margin: EdgeInsets.only(top: 15),
                            padding: EdgeInsets.all(7),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primaryYellow),
                            child: Image.asset(
                              'assets/icon/light/ois.png',
                            ),
                          ),
                        ),
                      ),
                      activeIcon: Container(
                        height: 25,
                        child: OverflowBox(
                          maxHeight: 80,
                          child: Container(
                            margin: EdgeInsets.only(top: 15),
                            padding: EdgeInsets.all(7),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primaryGreen),
                            child: Image.asset(
                              'assets/icon/light/ois.png',
                            ),
                          ),
                        ),
                      ),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        children: <Widget>[
                          Image.asset(
                            'assets/icon/light/inbox.png',
                            width: bottomMenuSize,
                            height: bottomMenuSize,
                          ),
                          badgeCount
                        ],
                      ),
                      activeIcon: Stack(
                        children: <Widget>[
                          Image.asset(
                            'assets/icon/light/inbox-active.png',
                            width: bottomMenuSize,
                            height: bottomMenuSize,
                          ),
                          badgeCount
                        ],
                      ),
                      label: 'Inbox',
                    ),
                    BottomNavigationBarItem(
                        icon: Image.asset(
                          'assets/icon/light/akun.png',
                          width: bottomMenuSize,
                          height: bottomMenuSize,
                        ),
                        activeIcon: Image.asset(
                          'assets/icon/light/akun-active.png',
                          width: bottomMenuSize,
                          height: bottomMenuSize,
                        ),
                        label: store!.state.user.id < 1 ? "Akun" : "Saya"),
                  ],
                  type: BottomNavigationBarType.fixed,
                  currentIndex: tab.index,
                  onTap: _onTapItem,
                ),
              ),
            ),
          );
        });
  }
}
