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

import '../../interface/scrollUpWidget.dart';
import '../appbar/navmain.dart';

class Home extends StatefulWidget implements ScrollUpWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();

  @override
  void onResetTab() {
    refreshController.position
        ?.moveTo(0, duration: Duration(milliseconds: 600));
  }

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

  @override
  void initState() {
    Future.delayed(Duration(microseconds: 0)).then((_) async {
      // await initializePageAsync();
      // await getEventPage();
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  Widget prepareHome() {
    return Text("data");
    // return SmartRefresher(
    //   enablePullDown: true,
    //   enablePullUp: true,
    //   controller: widget.refreshController,
    //   onLoading: _onLoad,
    //   onRefresh: _onRefresh,
    //   child: ListView(
    //     padding: EdgeInsets.only(top: 20),
    //     physics: BouncingScrollPhysics(),
    //     scrollDirection: Axis.vertical,
    //     children: <Widget>[
    //       ShrtApp(),
    //       MostConsistentChannel(
    //           medal: medal, futureList: getMostConsistentChannels()),
    //       NewUpdateWidget(),
    //       StoreProvider<AppState>(
    //           store: store,
    //           child: StoreConnector<AppState, UserInfo>(
    //               converter: (store) => store.state.user,
    //               builder: (context, user) {
    //                 return Column(
    //                   mainAxisSize: MainAxisSize.max,
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: store.state.user.id > 0
    //                       ? [
    //                           CheckTFPoint(),
    //                           PointReminder(),
    //                         ]
    //                       : [SizedBox()],
    //                 );
    //               })),
    //       TooltipPanduanPrompt(),
    //       SizedBox(
    //         height: 35,
    //       ),
    //       SliderEventWidget(data: _listPromo),
    //       Container(
    //         margin: EdgeInsets.only(top: 25),
    //         child: RecentProfitSignalWidget(
    //           data: closedSignal,
    //           medal: medal,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: NavMain(),
      body: prepareHome(),
      backgroundColor: AppColors.light,
    );
  }

  @override
  bool wantKeepAlive = true;
}
