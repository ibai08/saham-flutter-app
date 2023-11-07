// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/app_state_controller.dart';
import 'package:saham_01_app/controller/mrg_controller.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/prompt_text.dart';

import '../../../widgets/btn_with_icon.dart';

class Mrg extends StatelessWidget {
  final MrgController mrgController = Get.put(MrgController());
  final AppStateController appStateController = Get.find();

  Mrg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white3,
      appBar: NavTxt(
        title: "Maxrich Group",
      ),
      body: GetX<MrgController>(
        init: MrgController(),
        builder: (mrgController) {
          return !mrgController.isLoading.value ? Obx(() {
        mrgController.refreshList(appStateController.userMrg.value);
        return SmartRefresher(
          controller: mrgController.refreshController,
          onRefresh: mrgController.onRefresh,
          enablePullDown: true,
          enablePullUp: false,
          child: ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsetsDirectional.only(top: 15),
                height: 90,
                width: double.infinity,
                foregroundDecoration: BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.0),
                      mrgController.col.value
                    ],
                    stops: const [
                      0.0,
                      0.17,
                      0.83,
                      0.99
                    ]
                  )
                ),
                child: ListView(
                  controller: mrgController.scrollController,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  scrollDirection: Axis.horizontal,
                  children: appStateController.userMrg.value.mrgid == 0 ? [
                    BtnWithIcon(
                      title: "Open Acc",
                      icon: Icons.folder_open,
                      color: AppColors.primaryGreen,
                      txtColor: Colors.white,
                      tap: () {
                        Get.toNamed("/mrg/openacc");
                      },
                    )
                  ] : [
                    BtnWithIcon(
                      title: "Req. Account",
                      image: Image.asset(
                        "assets/icon-requestacc.png",
                        width: 30,
                        height: 30,
                      ),
                      color: AppColors.primaryGreen,
                      txtColor: Colors.white,
                      tap: () {
                        Get.toNamed("/mrg/requestacc");
                      },
                    ),
                    BtnWithIcon(
                      title: "Deposit",
                      image: Image.asset(
                        "assets/icon-deposit.png",
                        width: 30,
                        height: 30,
                      ),
                      color: AppColors.darkGreen,
                      txtColor: Colors.white,
                      tap: () {
                        Get.toNamed("/mrg/deposit");
                      },
                    ),
                    remoteConfig.getInt("mrg_contest_show") == 1 ? BtnWithIcon(
                      title: "Trading Contest",
                      icon: Icons.stars,
                      color: Colors.grey[300],
                      txtColor: Colors.grey[800],
                      tap: () {
                        Navigator.pushNamed(
                            context, '/mrg/contest');
                      },
                    ) : const SizedBox(),
                    BtnWithIcon(
                      title: "Demo Account",
                      image: Image.asset(
                        "assets/icon-demoacc.png",
                        width: 30,
                        height: 30,
                      ),
                      color: AppColors.lightGrey2,
                      txtColor: Colors.grey[800],
                      tap: () {
                        Get.toNamed("/mrg/demo");
                      },
                    ),
                    BtnWithIcon(
                      title: "Withdrawal",
                      image: Image.asset(
                        "assets/icon-withdrawal.png",
                        width: 30,
                        height: 30,
                      ),
                      color: AppColors.lightGrey2,
                      txtColor: Colors.grey[800],
                      tap: () {
                        Get.toNamed("/mrg/withdraw");
                      },
                    ),
                  ]
                ),
              ),
              appStateController.userMrg.value.mrgid! > 0 ? Container(
                margin: const EdgeInsets.only(top: 15),
                child: PromptText(
                  title: "Kartu Identitas",
                  desc: "Kami membutuhkan foto identitas Anda untuk keperluan Withdrawal Anda.",
                  textBtn: "Upload/Ganti Kartu Identitas",
                  url: () {
                    Get.toNamed("/mrg/uploadid");
                  },
                ),
              ) : const Text(""),
              Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey2,
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: ExpansionTile(
                    title: Text(
                      "Daftar Real Account",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkGreen2,
                        fontSize: 18
                      ),
                    ),
                    iconColor: AppColors.darkGreen2,
                    children: appStateController.userMrg.value.realAccounts?.length != 0 ? mrgController.listRealAccount : [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: const Text(
                            "Anda Belum Memiliki Account MRG",
                            textAlign: TextAlign.left),
                      ),
                    ],
                  ),
                ),
              ),
              Theme(
                data: ThemeData().copyWith(
                  dividerColor: Colors.transparent
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 15
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey2,
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: ExpansionTile(
                    iconColor: AppColors.darkGreen2,
                    title: Text(
                      "Daftar Transaksi Terbaru",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: AppColors.darkGreen2
                      ),
                    ),
                    children: appStateController.userMrg.value.transactions?.length != 0 ? mrgController.listHistory : [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: const Text(
                            "Anda Belum Memiliki Riwayat Transaksi",
                            textAlign: TextAlign.left),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        );
      }) : const Center(
        child: CircularProgressIndicator(),
      );
        },
      )
    );
  }
}