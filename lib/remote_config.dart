import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/views/widgets/btn_block.dart';
// import 'package:saham_01_app/views/widgets/toast.dart';

import 'views/widgets/get_alert.dart';

class RemoteConfigView extends StatefulWidget {
  const RemoteConfigView({Key? key}) : super(key: key);

  @override
  State<RemoteConfigView> createState() => _RemoteConfigViewState();
}

class _RemoteConfigViewState extends State<RemoteConfigView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final DialogController dialogController = Get.find();

  void _onRefresh() async {
    try {
      await _refreshController.requestRefresh();
      await Future.delayed(const Duration(milliseconds: 500));
      await remoteConfig.fetchAndActivate();
      _refreshController.refreshCompleted();
    } catch (e) {
      //TODOs: ganti getalert
      await dialogController.showToast("Terjadi kesalahan, periksa koneksi internet anda dan coba lagi", "TUTUP");
      // showToast(
      //     context,
      //     "Terjadi kesalahan, periksa koneksi internet anda dan coba lagi",
      //     "TUTUP");
      _refreshController.refreshCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.white,
              statusBarIconBrightness: Brightness.dark),
        ),
        body: SafeArea(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Image.asset(
                    "assets/icon-no-connections.png",
                    width: 60,
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Terjadi Kesalahan",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Terjadi kesalahan saat mendapatkan data, mohon periksa koneksi internet dan coba lagi",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BtnBlock(
                    onTap: () async {
                      _onRefresh();
                    },
                    title: "Refresh data",
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
