import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/homeTabController.dart';
import '../../models/entities/ois.dart';
import '../../views/pages/home.dart';
import '../../views/widgets/homeSignalJustMadeProfitShimmer.dart';
import '../../views/widgets/recentSignalListWidget.dart';

class RecentProfitSignalWidgetNew extends StatelessWidget {
  final List<SignalInfo>? data;
  final Level? medal;

  RecentProfitSignalWidgetNew({Key? key, this.data, this.medal})
      : super(key: key);

  final HomeTabController homeTabController = Get.put(HomeTabController());

  @override
  Widget build(BuildContext context) {
    print("data: ${data}");
    // final HomeTabController homeTabController = Get.put(HomeTabController());
    homeTabController.setSignals(data!);

    return GetX<HomeTabController>(
      builder: (controller) {
        if (controller.signalList.isEmpty) {
          return const HomeSignalJustMadeProfitShimmer();
        }
        return Container(
          child: controller.signalList.isNotEmpty
              ? RecommendedSignal(
                  listSignalData: controller.signalList,
                  medal: medal!,
                )
              : const SizedBox(),
        );
      },
    );
    // return Container(
    //   child: StreamBuilder<List<SignalInfo>>(
    //       stream: ss
    //       builder: (context, snapshot) {
    //         if (snapshot.hasError) {
    //           return SizedBox();
    //         }
    //         if (snapshot.data == null) {
    //           return HomeSignalJustMadeProfitShimmer();
    //         }
    //         return snapshot.data.length > 0
    //             ? RecommendedSignal(
    //                 medal: widget.medal,
    //                 listSignalData: snapshot.data,
    //               )
    //             : SizedBox();
    //       }),
    // );
  }
}

class RecommendedSignal extends StatelessWidget {
  const RecommendedSignal({
    Key? key,
    @required this.listSignalData,
    @required this.medal,
  }) : super(key: key);

  final List<SignalInfo>? listSignalData;
  final Level? medal;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitlePartHome(
          title: "Signal yang baru saja profit",
        ),
        RecentSignalListWidget(listSignalData, medal),
      ],
    );
  }
}
