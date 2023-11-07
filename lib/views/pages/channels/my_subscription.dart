// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/my_subscription_controller.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';

import '../../../models/entities/ois.dart';
import '../../widgets/info.dart';

class MySubscription extends StatelessWidget {
  final MySubscriptionController controller = Get.put(MySubscriptionController());

  MySubscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavTxt(
        title: "My Subscription",
      ),
      body: Container(
        height: double.infinity,
        color: AppColors.white,
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              height: 80,
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                onChanged: controller.filterSubs,
                controller: controller.filterChannel,
                decoration: InputDecoration(
                  hintText: "Cari Channel",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  fillColor: AppColors.lightGrey2,
                  contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.lightGrey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 135,
              child: GetX<MySubscriptionController>(
                init: MySubscriptionController(),
                builder: (controllers) {
                  if (controllers.mySubsController.value != null || controllers.mySubsController.value != []) {
                    if (controllers.hasLoad.value == false) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    else if (controllers.mySubsController.value.length == 0) {
                      return Info(
                        title: "Oops..",
                        desc: "Subscriber tidak ditemukan atau channel Anda belum memiliki subscriber",
                        caption: "Refresh",
                        image: Image.asset(
                          "assets/icon-mysubscription.png",
                          width: 50,
                          height: 50,
                        ),
                        onTap: () {
                          controllers.onRefresh();
                        },
                      );
                    }
                    return SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: false,
                      controller: controllers.refreshController,
                      onRefresh: controllers.onRefresh,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: controller.mySubsController.value.map((channel) => TileChannelsSubs(channel: channel, tapCallback: controller.tapCallback)).toList(),
                      ),
                    );
                  } else if (controllers.hasError.value) {
                    return Info(
                      title: "Terjadi Error",
                      desc: controllers.errorMessage.value,
                      caption: "Refresh",
                      image: Image.asset(
                        "assets/icon-mysubscription.png",
                        width: 50,
                        height: 50,
                      ),
                      onTap: () {
                        controllers.onRefresh();
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TileChannelsSubs extends StatelessWidget {
  TileChannelsSubs({required this.channel, this.tapCallback});

  final Function? tapCallback;
  final ChannelCardSlim channel;
  final DateFormat formatter = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    return channel.subscribed!
        ? GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(context, '/dsc/channels/',
                  arguments: channel.id);
              if (tapCallback != null) {
                tapCallback!();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 1, color: Colors.grey[400]!)),
                  color: Colors.white),
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                                text: channel.name,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                                children: <InlineSpan>[
                                  TextSpan(
                                      text: channel.price! > 0.0
                                          ? " (PAID)"
                                          : " (FREE)",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: channel.price! > 0.0
                                              ? Colors.red
                                              : Colors.grey))
                                ]),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Text("Subscribe Date: " +
                              formatter.format(channel.subsDate!.toLocal())),
                          Text(channel.subsExpired!.isBefore(DateTime.now())
                              ? "EXPIRED"
                              : "Expires in: " +
                                  (channel.price! > 0
                                      ? (channel.subsExpired
                                                  !.difference(DateTime.now())
                                                  .inDays <
                                              2
                                          ? "less than 1 day"
                                          : channel.subsExpired
                                                  !.difference(DateTime.now())
                                                  .inDays
                                                  .toString() +
                                              " days")
                                      : "Unlimited")),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      width: 50,
                      child: channel.mute!
                          ? Icon(Icons.notifications_off)
                          : Icon(
                              Icons.notifications), //Icon(Icons.chevron_right),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
  }
}
