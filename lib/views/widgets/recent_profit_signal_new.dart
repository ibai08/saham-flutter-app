import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_tab_controller.dart';
import '../../models/entities/ois.dart';
import '../../views/pages/home.dart';
import 'home_signal_just_made_profit.dart';
import 'recent_signal_list_widget.dart';

class RecentProfitSignalWidgetNew extends StatelessWidget {
  final List<SignalInfo>? data;
  final Level? medal;

  RecentProfitSignalWidgetNew({Key? key, this.data, this.medal})
      : super(key: key);

  final HomeTabController homeTabController = Get.find();

  @override
  Widget build(BuildContext context) {
    homeTabController.setSignals(data!);
    return Obx(() {
        if (homeTabController.signalList.isEmpty || medal == null) {
          return const HomeSignalJustMadeProfitShimmer();
        }
        return Container(
          child: homeTabController.signalList.isNotEmpty
              ? RecommendedSignal(
                  listSignalData: homeTabController.signalList,
                  medal: medal!,
                )
              : const SizedBox(),
        );
      },
    );
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
          title: "Signal baru saja profit",
        ),
        RecentSignalListWidget(listSignalData, medal),
      ],
    );
  }
}
