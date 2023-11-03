// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/app_state_controller.dart';
import 'package:saham_01_app/controller/ois_dashboard_controller.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/btn_with_icon.dart';
import 'package:saham_01_app/views/widgets/info.dart';
import 'package:saham_01_app/views/widgets/tile_box_copy_signal.dart';

import '../../../widgets/list_tile_summary.dart';

class OisDashboard extends StatelessWidget {
  final OisDashboardController controller = Get.put(OisDashboardController());
  final AppStateController appStateController = Get.find();

  OisDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (appStateController.users.value.id > 0 && appStateController.users.value.isProfileComplete() != false && appStateController.users.value.verify == true) {
    //   Get.offAndToNamed("/forms/editprofile", arguments: {
    //     "route": "/dsc/channels/info",
    //     "arguments": Get.arguments
    //   });
    // } else if (appStateController.users.value.id < 1 || appStateController.users.value.verify != true) {
    //   Get.offAndToNamed("/forms/login", arguments: {
    //     "route": "/dsc/channels/info",
    //     "arguments": Get.arguments
    //   });
    // }
    return Scaffold(
      backgroundColor: AppColors.white3,
      appBar: NavTxt(
        title: "XYZ Copy Signal",
      ),
      body: Obx(() {
        if (controller.oisStream.value == null && !controller.hasError.value) {
          return const Center(
            child: Text(
              "Tunggu ya..!!",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)
            ),
          );
        }
        if (controller.hasError.value) {
          return Center(
            child: Info(
              title: "Error",
              desc: controller.errorMessage.value,
              caption: "Refresh",
              onTap: controller.onRefresh,
            ),
          );
        }
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 10),
            shrinkWrap: true,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 15),
                height: 90,
                width: double.infinity,
                child: ListView(
                  padding: const EdgeInsets.only(left: 7, right: 15),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: (controller.oisStream.value?.totalChannel == 0) ? [
                    BtnWithIcon(
                      title: "Buat Channel",
                      image: Image.asset(
                        "assets/icon-buatchannel-small.png",
                        width: 30,
                        height: 30,
                      ),
                      color: AppColors.primaryGreen,
                      txtColor: Colors.white,
                      tap: () {
                        Get.toNamed("/dsc/channels/new");
                      },
                    )
                  ] : <Widget>[
                    BtnWithIcon(
                       title: "Channel Saya",
                      image: Image.asset(
                        "assets/icon-channel-small.png",
                        width: 30,
                        height: 30,
                      ),
                      color: AppColors.lightGrey2,
                      txtColor: Colors.grey[800],
                      tap: () {
                        Get.toNamed('/dsc/channels/my');
                      }
                    ),
                    BtnWithIcon(
                      title: "Buat Channel",
                      image: Image.asset(
                        "assets/icon-buatchannel-small.png",
                        width: 30,
                        height: 30,
                      ),
                      color: AppColors.primaryGreen,
                      txtColor: Colors.white,
                      tap: () {
                        Get.toNamed('/dsc/channels/new');
                      },
                    ),
                    BtnWithIcon(
                      title: "Buat Signal",
                      // icon: Icons.show_chart,
                      image: Image.asset(
                        "assets/icon-buatsignal-small.png",
                        width: 30,
                        height: 30,
                      ),
                      color: AppColors.darkGreen,
                      txtColor: Colors.white,
                      tap: () {
                        Get.toNamed('/dsc/signal/new');
                      },
                    ),
                    BtnWithIcon(
                      title: "Subscribers",
                      image: Image.asset(
                        "assets/icon-subscriber-small.png",
                        width: 30,
                        height: 30,
                      ),
                      color: AppColors.lightGrey2,
                      txtColor: Colors.grey[800],
                      tap: () async {
                        Get.toNamed("/dsc/subscribers");
                      },
                    ),
                    remoteConfig.getInt("can_paid_channel") == 1 ? BtnWithIcon(
                      title: "Cash Out",
                      image: Image.asset(
                        "assets/icon-earning-small.png",
                        width: 30,
                        height: 30,
                      ),
                      color: AppColors.lightGrey2,
                      txtColor: Colors.grey[800],
                      tap: () async {
                        var result = (await Get.toNamed('/dsc/withdraw')) ??
                            false;
                        if (result) {
                          controller.refreshController.requestRefresh(
                              needMove: false);
                        }
                      },
                    ) : const SizedBox()
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                child: const Text(
                  "Channel Info",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TileBoxCopySignal(
                            leading: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey2,
                                borderRadius: const BorderRadius.all(Radius.circular(4))
                              ),
                              child: Image.asset(
                                "assets/icon-channel-small.png",
                                width: 25,
                                height: 25,
                              ),
                            ),
                            title: "Total Channel",
                            subtitle: controller.oisStream.value?.totalChannel.toString(),
                          ),
                        ),
                        Expanded(
                          child: TileBoxCopySignal(
                            leading: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey2,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              child: Image.asset(
                                "assets/icon-totalsignal-small.png",
                                width: 25,
                                height: 25,
                              ),
                            ),
                            title: "Total Signal",
                            subtitle: controller.oisStream.value?.totalSignal.toString(),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TileBoxCopySignal(
                            leading: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey2,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              child: Image.asset(
                                "assets/icon-subscriber-small.png",
                                width: 25,
                                height: 25,
                              ),
                            ),
                            title: "Total Subscriber",
                            subtitle:
                                controller.oisStream.value?.totalSubscriber.toString(),
                          ),
                        ),
                        Expanded(
                          child: TileBoxCopySignal(
                            title: "Earnings",
                            subtitle: "Rp " +
                                NumberFormat("#,###", "ID")
                                    .format(controller.oisStream.value?.totalBalance),
                            totalBalance: controller.oisStream.value?.totalBalance,
                            leading: controller.oisStream.value!.totalActiveBalance! <
                                    controller.oisStream.value!.totalBalance!
                                ? GestureDetector(
                                    child:
                                        const Icon(Icons.info_outline, size: 20),
                                    onTap: () {
                                      showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15),
                                              ),
                                              elevation: 0.0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20,
                                                        horizontal: 20),
                                                decoration:
                                                    BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 10.0,
                                                      offset: Offset(
                                                          0.0, 10.0),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    const Text(
                                                      "Earnings",
                                                      style: TextStyle(
                                                        fontSize: 22.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              "Active Earnings",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  height:
                                                                      1.3),
                                                            )),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              "Rp ${NumberFormat('#,###', 'ID').format(controller.oisStream.value?.totalActiveBalance)}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: const TextStyle(
                                                                  height:
                                                                      1.3),
                                                            ))
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              "New Earnings",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  height:
                                                                      1.3),
                                                            )),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              "Rp ${NumberFormat('#,###', 'ID').format(controller.oisStream.value!.totalBalance! - controller.oisStream.value!.totalActiveBalance!)}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: const TextStyle(
                                                                  height:
                                                                      1.3),
                                                            ))
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              "Earnings",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height:
                                                                      1.3),
                                                            )),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              "Rp ${NumberFormat('#,###', 'ID').format(controller.oisStream.value!.totalBalance)}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  height:
                                                                      1.3),
                                                            ))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGrey2,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    child: Image.asset(
                                      "assets/icon-earning-small.png",
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ]
                )
              ),
              Theme(
                data:
                    ThemeData().copyWith(dividerColor: Colors.transparent),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey2,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ExpansionTile(
                    iconColor: AppColors.darkGreen2,
                    title: Text(
                      "Bank Info",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: AppColors.darkGreen2),
                    ),
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: controller.bankNameCon,
                                decoration: const InputDecoration(
                                    labelText: 'Bank',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w600),
                                    border: InputBorder.none),
                                keyboardType: TextInputType.text,
                                readOnly: true,
                              ),
                              TextFormField(
                                controller: controller.bankUsernameCon,
                                decoration: const InputDecoration(
                                    labelText: 'Atas Nama',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w600),
                                    border: InputBorder.none),
                                keyboardType: TextInputType.emailAddress,
                                readOnly: true,
                              ),
                              TextFormField(
                                controller: controller.bankNoCon,
                                decoration: const InputDecoration(
                                    labelText: 'No. Rekening',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w600),
                                    border: InputBorder.none),
                                keyboardType: TextInputType.number,
                                readOnly: true,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              Theme(
                data:
                    ThemeData().copyWith(dividerColor: Colors.transparent),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey2,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    color: AppColors.lightGrey2,
                    child: ExpansionTile(
                      iconColor: AppColors.darkGreen2,
                      title: Text(
                        "Riwayat Transaksi",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: AppColors.darkGreen2),
                      ),
                      children: <Widget>[
                        Container(
                          child:
                            controller.oisStream.value?.transactionPayment.length != 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount: controller.oisStream.value?.transactionPayment.length,
                                  itemBuilder: (context, i) {
                                    return ListTileSummary(
                                      date: controller.oisStream.value?.transactionPayment[i].tgl,
                                      comm: controller.oisStream.value?.transactionPayment[i].comm,
                                      adminFee: controller.oisStream.value?.transactionPayment[i].adminFee,
                                      amount: controller.oisStream.value?.transactionPayment[i].jumlah,
                                      type: controller.oisStream.value?.transactionPayment[i].type,
                                      no: controller.oisStream.value?.transactionPayment[i].username.toString(),
                                      status:controller.oisStream.value?.transactionPayment[i].status,
                                      tid: controller.oisStream.value?.transactionPayment[i].reff.toString(),
                                      description: controller.oisStream.value?.transactionPayment[i].description.toString(),
                                    );
                                  },
                                )
                              : Column(
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 15),
                                      child: const Text(
                                          "Belum ada riwayat transaksi",
                                          textAlign: TextAlign.left),
                                    ),
                                  ],
                                ))
                              ,
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                  child: const Text(
                    "Subscription Info",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey2,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed("/dsc/subscriptions");
                  },
                  child: const ListTile(
                    title: Text(
                      "My Subscription",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}