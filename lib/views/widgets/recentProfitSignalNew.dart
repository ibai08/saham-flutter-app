import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/homeTabController.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/views/pages/home.dart';
import 'package:saham_01_app/views/widgets/homeSignalJustMadeProfitShimmer.dart';
import 'package:saham_01_app/views/widgets/recentSignalListWidget.dart';

// class SignalController extends GetxController {
//   final RxList<SignalInfo> signalList = RxList<SignalInfo>();

//   void setSignals(List<SignalInfo> signals) {
//     signalList.clear();
//     signalList.addAll(signals);
//   }
// }

class RecentProfitSignalWidgetNew extends StatelessWidget {
  final List<SignalInfo>? data;
  final Level? medal;

  const RecentProfitSignalWidgetNew({Key? key, this.data, this.medal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("data: ${data}");
    final HomeTabController homeTabController = Get.put(HomeTabController());
    final ss = homeTabController.setSignals(data!);

    return FutureBuilder<List<SignalInfo>>(
      future: homeTabController.setSignals(data!),
      builder: (context, AsyncSnapshot<List<SignalInfo>> snapshot) {
        if (snapshot.data!.isEmpty) {
          return const HomeSignalJustMadeProfitShimmer();
        }
        return Container(
          child: snapshot.data!.isNotEmpty
              ? RecommendedSignal(
                  listSignalData: snapshot.data,
                  medal: medal!,
                )
              : const SizedBox(),
        );
      },
      // ),
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
          title: "Signal yang baru saja profit",
        ),
        RecentSignalListWidget(listSignalData, medal),
      ],
    );
  }
}
