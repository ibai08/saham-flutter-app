// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../controller/app_state_controller.dart';
import '../widgets/image_from_network.dart';

// class NavMain extends AppBar {
//   NavMain({Key? key, Widget? title})
//       : super(
//             key: key,
//             title: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Image.asset(
//                   'assets/icon/brands/tf-teks.png',
//                   width: 180,
//                 ),
//               ],
//               mainAxisAlignment: MainAxisAlignment.center,
//             ),
//             elevation: 2,
//             systemOverlayStyle: SystemUiOverlayStyle(
//                 statusBarColor: AppColors.white,
//                 statusBarIconBrightness: Brightness.dark),
//             iconTheme: IconThemeData(color: AppColors.black),
//             centerTitle: true,
//             backgroundColor: AppColors.white,
//             shadowColor: AppColors.white);
// }

final AppStateController appStateController = Get.find();

class NavMain extends AppBar {
  NavMain(
      {Key? key,
      Widget? title,
      String? username,
      String? currentPage,
      Function? backPage})
      : super(
            key: key,
            toolbarHeight: currentPage == "HomePage" ? 80 : 50,
            title: currentPage == "HomePage"
                ? GetBuilder<AppStateController>(
                    init: AppStateController(),
                    builder: (controller) {
                      return Column(
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(left: 5),
                                height: 50,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Hai, ',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: username,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(right: 5),
                                // height: 50,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(
                                          'assets/icon/light/Notif.png',
                                          fit: BoxFit.fitWidth),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 35,
                                      height: 35,
                                      child: CircleAvatar(
                                        child: ImageFromNetwork(
                                          controller.users.value.avatar,
                                          defaultImage: Image.asset(
                                              'assets/default-channel-icon.jpg'),
                                          // defaultImage: Image.asset(
                                          //   'assets/'
                                          // ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    })
                : Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 5, right: 10),
                        height: 50,
                        // decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
                        child: InkWell(
                          onTap: () {
                            backPage!();
                          },
                          child: Image.asset(
                            "assets/icon/light/arrow-left.png",
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        // decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
                        child: Text(
                          currentPage!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.white,
                statusBarIconBrightness: Brightness.dark),
            iconTheme: IconThemeData(color: AppColors.black),
            backgroundColor: AppColors.light,
            automaticallyImplyLeading: false,
            shadowColor: AppColors.white);
}
