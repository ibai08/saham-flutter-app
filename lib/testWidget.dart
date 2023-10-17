import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/beta/controller/home_controller.dart';
import 'package:saham_01_app/config/tab_list.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/views/widgets/dialogConfirmation.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          if (controller.tab.value != HomeTab.home) {
            Get.back();
            controller.tab.value = HomeTab.home;
            controller.tabController.animateTo(0,duration: const  Duration(milliseconds: 200),curve:Curves.easeIn);
            return false;
          } else {
            bool result = await showDialog(
              context: context,
              builder: (ctx) {
                return const DialogConfirmation(
                  title: "Peringatan",
                  desc: "Anda yakin ingin keluar dari aplikasi",
                  caps: "Keluar",
                );
              }
            );
            return result;
          }
        },
        child: Scaffold(
          body: Navigator(
            key: Get.nestedKey(1),
            initialRoute: '/beranda',
            onGenerateRoute: controller.onGenerateRoute,
          ),
          bottomNavigationBar: Container(
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: TabBar(
                controller: controller.tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  border: const Border(
                    top: BorderSide(
                      color: Color(0xFF350699),
                      width: 3.0
                    )
                  ),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2E2AFF).withOpacity(0.1),
                      const Color(0xFF2E2AFF).withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.clamp
                  ),
                ),
                tabs: tabViews,
                onTap: controller.changePage,
              ),
            ),
          ),
        ),
      );
    });
  }
}