// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/constants/app_route.dart';
import 'package:saham_01_app/controller/app_state_controller.dart';
import 'package:saham_01_app/controller/my_channel_controller.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/info.dart';
import 'package:saham_01_app/views/widgets/text_prompt.dart';

import '../../../models/entities/ois.dart';
import '../../widgets/channel_avatar.dart';

class MyChannels extends StatelessWidget {
  final MyChannelController controller = Get.put(MyChannelController());

  MyChannels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.find<AppStateController>().users.value.id > 0 && !Get.find<AppStateController>().users.value.isProfileComplete() && Get.find<AppStateController>().users.value.verify == true) {
      Get.offAndToNamed("/forms/editprofile");
    } else if (Get.find<AppStateController>().users.value.id < 1 || Get.find<AppStateController>().users.value.verify == false) {
      Get.offAndToNamed("/forms/login");
    }
    return Scaffold(
      appBar: NavTxt(
        title: "Channel Saya",
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
                  onChanged:  (_) async {
                    controller.search(_);
                  },
                  decoration: InputDecoration(
                    hintText: "Cari Channel",
                    prefixIcon: Icon(Icons.search),
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
              Obx(() {
                if (controller.oisStream.value == null && !controller.hasError.value) {
                  return const Center(
                    child: Text(
                      "Mohon menunggu..",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                    )
                  );
                }
                if (controller.hasError.value) {
                  return Info(onTap: controller.onRefresh);
                }
                return Container(
                  height: MediaQuery.of(context).size.height - 150,
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    controller: controller.refreshController,
                    onRefresh: controller.onRefresh,
                    child: controller.oisStream.value?.listMyChannel?.length == 0 ? TextPrompt(
                      title: "CHANNEL TIDAK DITEMUKAN",
                      desc: "Buat Channel Anda untuk mulai membuat signal",
                      cta: "Buat Channel",
                      fn: () {
                        Get.toNamed(AppRoutes.newChannels);
                      },
                    ) : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.oisStream.value?.listMyChannel?.length,
                      itemBuilder: (context, i) {
                        return ChannelListTile(
                          channelCard: controller.oisStream.value?.listMyChannel?[i],
                        );
                      },
                    ),
                  ),
                );
              })
            ],
          ),
        )
    );
  }
}

class ChannelListTile extends StatelessWidget {
  ChannelListTile({
    Key? key,
    this.channelCard,
  }) : super(key: key);

  final ChannelCardSlim? channelCard;

  @override
  Widget build(BuildContext context) {
    final GlobalKey _menuKey = new GlobalKey();
    var format = NumberFormat("#,##0", "en_US");
    String priceFormatted = "Rp " + format.format(channelCard?.price);
    if (channelCard != null) {
      if (channelCard!.price! < 1) {
        priceFormatted = "FREE";
      }
    } 
    
    return GestureDetector(
      onTap: () {
        dynamic state = _menuKey.currentState;
        state.showButtonMenu();
      },
      child: Container(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 15,
          left: 10,
        ),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)],
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: ChannelAvatar(
                imageUrl: channelCard?.avatar,
              ),
              trailing: PopupMenuButton<String>(
                key: _menuKey,
                onSelected: (value) {
                  switch (value) {
                    case '1':
                      Navigator.pushNamed(context, "/dsc/signal/new",
                          arguments: channelCard?.id);
                      break;
                    case '2':
                      Navigator.pushNamed(context, "/dsc/channels/",
                          arguments: channelCard?.id);
                      break;
                    case '3':
                      Navigator.pushNamed(context, "/dsc/channels/new",
                          arguments: channelCard);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: "1",
                    child: Text('Buat Signal'),
                  ),
                  const PopupMenuItem<String>(
                    value: "2",
                    child: Text('Lihat Channel'),
                  ),
                  const PopupMenuItem<String>(
                    value: "3",
                    child: Text('Ubah Channel'),
                  ),
                ],
              ),
              title: Text(
                channelCard?.name.toString() ?? "",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    priceFormatted,
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  Container(
                      color: AppColors.primaryGreen,
                      width: 36.0,
                      height: 3.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person_pin,
                        color: Colors.grey[700],
                        size: 16,
                      ),
                      Text(
                        " ${channelCard?.subscriber} Subscriber",
                        style: const TextStyle(color: Colors.black),
                      )
                    ],
                  )),
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      Icon(Icons.show_chart, color: Colors.grey[700], size: 16),
                      Text(" ${channelCard?.signals} Signals",
                          style: const TextStyle(
                            color: Colors.black,
                          ))
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}