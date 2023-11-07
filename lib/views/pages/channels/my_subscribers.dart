// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/mysubscriber_controller.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/info.dart';

class MySubscribers extends StatelessWidget {
  final MySubscriberController controller = Get.put(MySubscriberController());

  MySubscribers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavTxt(
        title: "My Subscriber",
      ),
      body: Container(
        color: AppColors.white,
        height: double.infinity,
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              height: 80,
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                onChanged: controller.filterSubs,
                controller: controller.filterUsername,
                decoration: InputDecoration(
                  hintText: "Cari Subscriber",
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.lightGrey),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  filled: true
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 160,
              child: GetX<MySubscriberController>(
                init: MySubscriberController(),
                builder: (controllers) {
                  if (controllers.subsController.value != null || controllers.subsController.value != []) {
                    if (controllers.hasLoad.value == false) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    else if (controllers.subsController.value.length == 0) {
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
                        children: controller.subsController.value.map((subscriber) => TileSubscriber(subscriber: subscriber)).toList(),
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

class TileSubscriber extends StatelessWidget {
  final ChannelSubscriber subscriber;

  const TileSubscriber({Key? key, required this.subscriber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String subsDate = DateFormat('dd MMM yyyy HH:mm').format(subscriber.subsDate!.toLocal());
    return GestureDetector(
      onTap: () {
        Get.toNamed('/dsc/channels/', arguments: subscriber.channelId);
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 1, color: Colors.grey[400]!)),
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
                    Text(
                      subscriber.username ?? "",
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Text("Channel: " + subscriber.title!),
                    Text("Subscribe Date: " + subsDate),
                  ],
                ),
              ),
            ),
            const Expanded(
              flex: 2,
              child: SizedBox(
                  height: 50, width: 50, child: Icon(Icons.chevron_right)
              )
            )
          ],
        ),
      ),
    );
  }
}