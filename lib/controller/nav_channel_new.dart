import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import 'app_state_controller.dart';

import '../views/widgets/image_from_network.dart';

final AppStateController appStateController = Get.put(AppStateController());

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
                                padding: const EdgeInsets.only(left: 1.5),
                                height: 50,
                                child: controller.users.value.username != null && controller.users.value.username != 'null' ? RichText(
                                  text: TextSpan(
                                    text: 'Hai, ',
                                    style: TextStyle(
                                        color: AppColors.lightBlack2, fontSize: 20, fontFamily: 'Manrope', fontWeight: FontWeight.w400),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: controller.users.value.username == "" || controller.users.value.username == null ? controller.users.value.fullname : controller.users.value.username,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ) : RichText(
                                  text: TextSpan(
                                    text: 'Selamat Datang',
                                    style: TextStyle(
                                        color: AppColors.lightBlack2, fontSize: 20, fontFamily: 'Manrope', fontWeight: FontWeight.w400),
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
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(
                                          'assets/icon/light/Notif.png',
                                          fit: BoxFit.fitWidth),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        controller.users.value.fullname != null && controller.users.value.fullname != 'null' ? Get.toNamed('/more/profile') : () {};
                                      },
                                      child: SizedBox(
                                        
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
            backgroundColor: AppColors.lightGrey2,
            automaticallyImplyLeading: false,
            shadowColor: AppColors.white);
}
