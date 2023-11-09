// ignore_for_file: prefer_const_constructors, avoid_print, must_call_super

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:saham_01_app/controller/home_tab_controller.dart';
import '../../constants/app_colors.dart';
import '../../controller/app_state_controller.dart';
import '../../core/get_storage.dart';
// import 'package:tradersfamily_app/appbar/navmain.dart';
import '../../views/pages/market/widget/index_saham.dart';
// import 'package:tradersfamily_app/pages/market/widget/slider.dart';
import '../../views/pages/market/widget/grid_sektor_saham.dart';
import '../../views/pages/market/widget/stock_info.dart';
import '../../views/pages/market/widget/top_container.dart';
import '../../views/pages/market/widget/emiten_slider.dart' as emitenslider;

import '../appbar/navmain.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  // final AppStateController appStateController = Get.put(AppStateController());
  final NewHomeTabController newHomeTabController = Get.find();

  // late TabController _tabController;

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: tabViews.length, vsync: this);
  // }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }
  SharedBoxHelper? boxs =
      SharedHelper.instance.getBox(CacheKey.oisSearchHistory);
  GetStorage store = GetStorage();
  void saya() async {
    int n = 5;
    for (var i = 0; i < n; i++) {
      List<String> tets = [];
      for (var j = 0; j < n; j++) {
        tets.add("#");
        print(tets.length);
        break;
      }
      print("");
    }
  }

  @override
  void initState() {
    saya();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: NavMain(
        currentPage: 'Market',
        // backPage: () async {
        //   Get.toNamed();
        // },
        backPage: () async {
          // Get.until(ModalRoute.withName("/home"));
          // appStateController.setAppState(Operation.bringToHome, HomeTab.home);
          newHomeTabController.tab.value = HomeTab.home;
          newHomeTabController.tabController.animateTo(0,duration: Duration(milliseconds: 200),curve:Curves.easeIn);
          // _tabController.index = homeTabController.homeTab.value.index;
          print("berhasil");
        },
      ),
      body: ListView(
        children: <Widget>[
          MarketCard(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
            child: Column(
              children: [
                StockInfoRow(
                  title1: 'Open',
                  value1: '6,704.23',
                  title2: 'Lot',
                  value2: '179.42M',
                  title3: 'High',
                  value3: '6,727.29',
                  title4: 'Value',
                  value4: '7.66T',
                  title5: 'Low',
                  value5: '6,669.24',
                  title6: 'Freq',
                  value6: '12.20M',
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Emiten Berdasarkan Kategori',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.8,
                                fontFamily: 'Manrope'),
                          ),
                        ],
                      ),
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     children: <Widget>[
                      //       EmitenCategory(),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    children: [
                      emitenslider.EmitenCategory(),
                      // SizedBox(width: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Manrope',
                            ),
                          ),
                          const SizedBox(width: 3.5),
                          Image.asset(
                            'assets/icon/light/arrow-right.png',
                            width: 13.5,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'Index Saham',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Manrope'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IndexSaham(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Manrope',
                            ),
                          ),
                          const SizedBox(width: 3.5),
                          Image.asset(
                            'assets/icon/light/arrow-right.png',
                            width: 13.5,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'Sektor Saham',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          GridSektor(
                              'Bahan Baku', 'assets/package.png', '-0.97%'),
                          GridSektor('Primer', 'assets/coffee.png', '-0.35%'),
                          GridSektor('Non Primer', 'assets/tv.png', '-0.97%'),
                          GridSektor('Energi', 'assets/zap.png', '-1.15%'),
                          GridSektor(
                              'Keuangan', 'assets/dollar-sign.png', '-0.37%'),
                          GridSektor('Kesehatan', 'assets/heart.png', '-0.39%'),
                          GridSektor(
                              'Industri', 'assets/idustry.png', '-1.25%'),
                          GridSektor('Prasarana', 'assets/road.png', '+0.03%'),
                          GridSektor('Properti', 'assets/house.png', '-0.36%'),
                          GridSektor('Teknologi', 'assets/cpu.png', '-0.07%'),
                          GridSektor('Transport', 'assets/truck.png', '-1.09%'),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
