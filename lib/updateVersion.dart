import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:package_info/package_info.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:saham_01_app/widget/btnBlock.dart';

import 'utils/remoteConfig.dart';
// import 'function/launchUrl.dart';

class UpdateVersionView extends StatefulWidget {
  @override
  _UpdateVersionViewState createState() => _UpdateVersionViewState();
}

class _UpdateVersionViewState extends State<UpdateVersionView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  StreamController<PackageInfo> _currVersionController = StreamController();

  void _onRefresh() async {
    Navigator.of(context).pushReplacementNamed('/');
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((x) async {
      try {
        _currVersionController.add(await PackageInfo.fromPlatform());
      } catch (ex) {
        _currVersionController.addError(ex);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Image.asset(
                // "assets/icon/brands/tf.png",
                "assets/logo-gray.png",
                width: 60,
              )),
              SizedBox(
                height: 15,
              ),
              Text(
                "Update Tersedia",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Sejak terakhir kamu perbarui, aplikasi XYZ makin sempurna. Kamu perlu memperbarui aplikasi ini.",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              StreamBuilder<PackageInfo>(
                  stream: _currVersionController.stream,
                  builder: (context, snapshot) {
                    // if (snapshot.hasData) {
                    //   PackageInfo packageInfo = snapshot.data;
                    //   return RichText(
                    //     textAlign: TextAlign.center,
                    //     text: TextSpan(
                    //       style: TextStyle(color: Colors.grey[900]),
                    //       children: [
                    //         TextSpan(
                    //           text: "Versi aplikasimu saat ini: ",
                    //         ),
                    //         TextSpan(
                    //             text: "${packageInfo.version}",
                    //             style: TextStyle(
                    //               fontWeight: FontWeight.w600,
                    //             )),
                    //       ],
                    //     ),
                    //   );
                    // }
                    return SizedBox();
                  }),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: Colors.grey[900]),
                  children: [
                    TextSpan(
                      text: "Versi terbaru: ",
                    ),
                    TextSpan(
                        text:
                            "${remoteConfig.getString('force_update_version_string')}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // BtnBlock(
              //   onTap: () {
              //     launchURL(remoteConfig.getString("play_store_url"));
              //   },
              //   title: "Perbarui Sekarang",
              // ),
            ],
          ),
        ),
      ),
    ));
  }
}
