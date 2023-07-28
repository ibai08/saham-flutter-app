// import 'package:flutter/material.dart';

// class Home extends StatelessWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/core/getStorage.dart';

import '../../interface/scrollUpWidget.dart';
import '../appbar/navmain.dart';

class Home extends StatefulWidget implements ScrollUpWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();

  @override
  void onResetTab() {
    refreshController.position
        ?.moveTo(0, duration: const Duration(milliseconds: 600));
  }

  @override
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  bool internet = false;
  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internet = true;
        print('connected');
      }
    } on SocketException catch (_) {
      internet = false;
      print('not connected');
    }
  }

  // SharedBoxHelper boxs = SharedHelper.instance.getBox(BoxName.signal);

  // void init() async {
  //   Map<String, dynamic> value = await boxs.getAll();
  //   print(value);
  // }

  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      // await initializePageAsync();
      // await getEventPage();
      // init();
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  Widget prepareHome() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: widget.refreshController,
      // onLoading: _onLoad,
      // onRefresh: _onRefresh,
      child: ListView(
        padding: const EdgeInsets.only(top: 20),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          TotalBalance(),
          const SizedBox(height: 20),
          ChannelTranding(),
          const SizedBox(height: 20),
          NewProfitSignal()

        ],
      ),
      // child: ListView(
      //   padding: EdgeInsets.only(top: 20),
      //   physics: BouncingScrollPhysics(),
      //   scrollDirection: Axis.vertical,
      //   children: <Widget>[
      //     ShrtApp(),
      //     MostConsistentChannel(
      //         medal: medal, futureList: getMostConsistentChannels()),
      //     NewUpdateWidget(),
      //     StoreProvider<AppState>(
      //         store: store,
      //         child: StoreConnector<AppState, UserInfo>(
      //             converter: (store) => store.state.user,
      //             builder: (context, user) {
      //               return Column(
      //                 mainAxisSize: MainAxisSize.max,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: store.state.user.id > 0
      //                     ? [
      //                         CheckTFPoint(),
      //                         PointReminder(),
      //                       ]
      //                     : [SizedBox()],
      //               );
      //             })),
      //     TooltipPanduanPrompt(),
      //     SizedBox(
      //       height: 35,
      //     ),
      //     SliderEventWidget(data: _listPromo),
      //     Container(
      //       margin: EdgeInsets.only(top: 25),
      //       child: RecentProfitSignalWidget(
      //         data: closedSignal,
      //         medal: medal,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: NavMain(
        currentPage: 'HomePage',
        username: "Gopay Kai",
      ),
      body: prepareHome(),
      backgroundColor: AppColors.light,
    );
  }

  @override
  bool wantKeepAlive = true;
}

class TotalBalance extends StatelessWidget {
  const TotalBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            // ==> BOX TOTAL BALANCE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Total Balance",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        "Rp5,000,000.00",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.6,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    "assets/Lotus Logo.png",
                    width: 61,
                    height: 46,
                  ),
                ),
              ],
            ),
            // ==> BOX BUYING POWER
            Container(
              decoration: BoxDecoration(
                  color: AppColors.purplePrimary, borderRadius: const BorderRadius.only(bottomLeft: const Radius.circular(8), bottomRight: const Radius.circular(8))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Buying Power",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          "Rp1,345,000.00",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.6,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 15),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.greenLight,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/icon/light/plus.png", width: 16, height: 16),
                          const SizedBox(width: 5),
                          const Text(
                            "Deposite",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChannelTranding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==> JUDUL CHANNEL TRANDING
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: const Text(
            "Channel Tranding",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.8, fontFamily: 'Manrope'),
          ),
        ),
        const SizedBox(height: 10),
        // ==> BOX CHANNEL TRANDING
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                width: 250,
                height: 165,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(const Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    // ==> NAMA USER DAN LEVEL DAN SUBSCRIBER // ==> AVATAR USER
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            child: CircleAvatar(
                              child: Image.asset(
                                "assets/default-channel-icon.jpg",
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Tanjiro Kamado",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Manrope'),
                                ),
                                const Text(
                                  "Legend | 136 Subscribers",
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Manrope'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // == TRENDING UP USER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/icon/light/trending-up.png"),
                          const SizedBox(width: 8),
                          Text(
                            "+102.8%",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textGreenLight,
                            ),
                          )
                        ],
                      ),
                    ),
                    // ==> BUTTON SUBSCRIBE
                    Container(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF350699),
                          ),
                          child: const Text("Subscribe for Rp300.000", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Manrope')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 250,
                height: 165,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    // ==> NAMA USER DAN LEVEL DAN SUBSCRIBER // ==> AVATAR USER
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            child: CircleAvatar(
                              child: Image.asset(
                                "assets/default-channel-icon.jpg",
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Nezuko Kamado",
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Manrope'),
                                ),
                                const Text(
                                  "Legend | 100 Subscribers",
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Manrope'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // == TRENDING UP USER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/icon/light/trending-up.png"),
                          const SizedBox(width: 8),
                          const Text(
                            "+102.8%",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00B451),
                            ),
                          )
                        ],
                      ),
                    ),
                    // ==> BUTTON SUBSCRIBE
                    Container(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF350699),
                          ),
                          child: const Text("Subscribe for Rp300.000", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Manrope')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 250,
                height: 165,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(const Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    // ==> NAMA USER DAN LEVEL DAN SUBSCRIBER // ==> AVATAR USER
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            child: CircleAvatar(
                              child: Image.asset(
                                "assets/default-channel-icon.jpg",
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Serizawa Tamao",
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Manrope'),
                                ),
                                const Text(
                                  "Legend | 200 Subscribers",
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Manrope'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // == TRENDING UP USER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/icon/light/trending-up.png"),
                          const SizedBox(width: 8),
                          const Text(
                            "+102.8%",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00B451),
                            ),
                          )
                        ],
                      ),
                    ),
                    // ==> BUTTON SUBSCRIBE
                    Container(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF350699),
                          ),
                          child: const Text("Subscribe for Rp300.000", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Manrope')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // ==> BUTTON LIHAT SEMUA
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: InkWell(
            onTap: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Lihat Semua",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 3),
                Image.asset("assets/icon/light/arrow-right.png", width: 12, height: 12)
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ==> BOX SIGNAL BARU SAJA PROFIT
class NewProfitSignal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==> TITLE SIGNAL BARU PROFIT
        const Padding(
          padding: EdgeInsets.only(left: 18, bottom: 10),
          child: Text(
            "Signal baru saja profit",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.8, fontFamily: 'Manrope'),
          ),
        ),
        // ==> BOX SIGNAL BARU PROFIT
        Container(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    // ==> NAMA USER DAN LEVEL DAN SUBSCRIBER // ==> AVATAR USER
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 45,
                                child: CircleAvatar(
                                  child: Image.asset(
                                    "assets/default-channel-icon.jpg",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Tanjiro Kamado",
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Manrope'),
                                    ),
                                    const Text(
                                      "Legend | 136 Subscribers",
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Manrope'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 24,
                            width: 24,
                            child: Image.asset(
                              "assets/icon/light/arrow-right.png",
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ==> DIVIDER GARIS
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        indent: 1,
                        endIndent: 0,
                        color: Color(0xFFC9CCCF),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 175,
                            height: 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("BRIS", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Manrope')),
                                const Text("Bank Syariah Indonesia Tbk.",
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Manrope')),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 175,
                            height: 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("+4.36%",
                                    style: TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Manrope', color: AppColors.textGreenLight)),
                                Text("02 Mei 2023, 11:18 WIB",
                                    style:
                                        TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Manrope', color: AppColors.textGrayLight)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    // ==> NAMA USER DAN LEVEL DAN SUBSCRIBER // ==> AVATAR USER
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 45,
                                child: CircleAvatar(
                                  child: Image.asset(
                                    "assets/default-channel-icon.jpg",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Tanjiro Kamado",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Manrope'),
                                    ),
                                    const Text(
                                      "Legend | 136 Subscribers",
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Manrope'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 24,
                            width: 24,
                            child: Image.asset(
                              "assets/icon/light/arrow-right.png",
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ==> DIVIDER GARIS
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 1,
                        endIndent: 0,
                        color: const Color(0xFFC9CCCF),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 175,
                            height: 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("BRIS", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Manrope')),
                                const Text("Bank Syariah Indonesia Tbk.",
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Manrope')),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 175,
                            height: 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("+4.36%",
                                    style: TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Manrope', color: AppColors.textGreenLight)),
                                Text("02 Mei 2023, 11:18 WIB",
                                    style:
                                        TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Manrope', color: AppColors.textGrayLight)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: InkWell(
            onTap: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Lihat Semua",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 3),
                Image.asset("assets/icon/light/arrow-right.png", width: 12, height: 12)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
