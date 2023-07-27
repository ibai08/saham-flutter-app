import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/function/showAlert.dart';
import 'package:saham_01_app/models/entities/user.dart';
import 'package:saham_01_app/models/user.dart';
import 'package:saham_01_app/views/appbar/navmain.dart';
import 'package:saham_01_app/views/widgets/dialogLoading.dart';
import 'package:saham_01_app/views/widgets/listItemProfile.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  List<Widget> prepareWidget(UserInfo user) {
    List<Widget> silverlist = [];
    double iconSize = 22;

    if (user.id > 0) {
      silverlist = [
        ListItemSettings(
          context: context,
          onTap: () {
            Navigator.pushNamed(context, '/more/profile');
          },
          icon: Image.asset(
            "assets/icon/light/profile.png",
            width: iconSize,
            height: iconSize,
          ),
          text: "Profil Saya",
        ),
        ListItemSettings(
          context: context,
          onTap: () {
            Navigator.pushNamed(context, '/more/channel');
          },
          icon: Image.asset(
            "assets/icon/light/copy-signal.png",
            width: iconSize,
            height: iconSize,
          ),
          text: "XYZ Copy Signal",
        ),
        ListItemSettings(
          context: context,
          onTap: () {
            // Navigator.pushNamed(context, '/more/mrg');
            showAlert(context, LoadingState.warning, "Coming Soon");
          },
          icon: Image.asset(
            // "assets/icon/brands/mrg.png",
            'assets/logo-black.png',
            width: iconSize,
            height: iconSize,
          ),
          // text: "Maxrich Group",
          text: "ABC",
        ),
        ListItemSettings(
          context: context,
          onTap: () {
            // Navigator.pushNamed(context, '/more/askap');
            showAlert(context, LoadingState.warning, "Coming Soon");
          },
          icon: Image.asset(
            // "assets/icon/brands/mmb.png",
            'assets/logo-black.png',
            width: iconSize,
            height: iconSize,
          ),
          text: "DEFGHIJK",
        ),
        // ListItemSettings(
        //   context: context,
        //   onTap: () {
        //     Navigator.pushNamed(context, '/post/news');
        //   },
        //   icon: Image.asset(
        //     "assets/icon/light/news.png",
        //     width: iconSize,
        //     height: iconSize,
        //   ),
        //   text: "News & Events",
        // ),
        // ListItemSettings(
        //   context: context,
        //   onTap: () {
        //     webView.open(url: Uri.parse(remoteConfig.getString("url_panduan")));
        //   },
        //   icon: Image.asset(
        //     "assets/icon/light/panduan.png",
        //     width: iconSize,
        //     height: iconSize,
        //   ),
        //   text: "Panduan",
        // ),
        // ListItemSettings(
        //   context: context,
        //   onTap: () {
        //     Navigator.pushNamed(context, '/contacts/');
        //   },
        //   icon: Image.asset(
        //     "assets/icon/light/call.png",
        //     width: iconSize + 5,
        //     height: iconSize + 5,
        //   ),
        //   text: "Hubungi Kami",
        // ),
        // ListItemSettings(
        //   context: context,
        //   onTap: () {
        //     webView.open(url: Uri.parse(getMainSite()));
        //   },
        //   icon: Image.asset(
        //     "assets/icon/light/web.png",
        //     width: iconSize,
        //     height: iconSize,
        //   ),
        //   text: "Kunjungi Website",
        // ),
        ListItemSettings(
          context: context,
          onTap: () {
            Navigator.pushNamed(context, '/refresh/');
          },
          icon: Image.asset(
            "assets/icon/light/refresh.png",
            width: iconSize,
            height: iconSize,
          ),
          text: "Bersihkan Cache",
        ),
        // settings["mode"] == "production"
        //     ? SizedBox()
        //     : ListItemSettings(
        //         context: context,
        //         icon: Icon(
        //           Icons.developer_board,
        //           size: iconSize,
        //         ),
        //         onTap: () async {
        //           // Navigator.pushNamed(context, '/dev/');
        //           Navigator.pushNamed(context, '/forms/afterverify');
        //         },
        //         text: "TEST DEV ONLY",
        //       ),
        ListItemSettings(
          context: context,
          icon: Image.asset(
            "assets/icon/light/logout.png",
            width: iconSize,
            height: iconSize,
          ),
          onTap: () async {
            // DialogLoading dlg = DialogLoading();
            // showDialog(
            //   barrierDismissible: false,
            //   context: context,
            //   builder: (context){
            //     return dlg;
            //   }
            // );
            // await Future.delayed(Duration(milliseconds: 600));
            // await UserModel.instance.clearUserToken();
          },
          text: "Keluar",
        ),
      ];
    } else {
      silverlist = [
        ListItemSettings(
          context: context,
          onTap: () {
            Navigator.pushNamed(context, '/forms/login');
          },
          icon: Image.asset(
            "assets/icon/light/login.png",
            width: iconSize,
            height: iconSize,
          ),
          text: "Login",
        ),
        ListItemSettings(
          context: context,
          onTap: () {
            Navigator.pushNamed(context, '/forms/register');
          },
          icon: Image.asset(
            "assets/icon/light/register.png",
            width: iconSize,
            height: iconSize,
          ),
          text: "Daftar",
        ),
      ];
    }

    return silverlist;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavMain(
          currentPage: "Settings",
          backPage: () async {
             appStateController?.setAppState(Operation.bringToHome, HomeTab.home);
            },
        ),
        body: GetX<AppStateController>(
            builder: (controller) {
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Column(children: prepareWidget(controller.users.value)),
                    // Align(
                    //   alignment: Alignment.topCenter,
                    //   child: Container(
                    //     margin: EdgeInsets.only(top: 25),
                    //     child: Text(
                    //       "Find us on",
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: 16,
                    //           color: ConstColor.darkGrey),
                    //     ),
                    //   ),
                    // ),
                    // SocialMedia(),
                    // VersionWidget()
                  ],
                ),
              );
            }));
  }
}