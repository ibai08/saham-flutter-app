import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/entities/ois.dart';
import '../../views/widgets/signalThumbNew.dart';

// class SignalListWidgetController extends GetxController {
//   final RxList<SignalCardSlim> listSignal = RxList<SignalCardSlim>();
//   final Rx<Level?> medal = Rx<Level?>(null);

//   void initialize(List<SignalCardSlim> signal, Level medalData) {
//     listSignal.addAll(signal);
//     medal.value = medalData;
//   }
// }

class SignalListWidget extends StatelessWidget {
  final List<SignalCardSlim>? listSignal;
  final Level? medal;
  SignalListWidget(this.listSignal, this.medal);

  Widget listSignalView(List<SignalCardSlim> signal, Level medal) {
    print(signal[0].expired);
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: signal.length,
        itemBuilder: (context, i) {
          return SignalThumbNew(
            level: medal,
            medals: signal[i].medals,
            subscriber: signal[i].subs,
            title: signal[i].channelName,
            expired: signal[i].expired,
            channelId: signal[i].channelId,
            id: signal[i].signalid,
            createdAt: signal[i].createdAt,
            symbol: signal[i].symbol,
            avatar: signal[i].channelAvatar,
            op: signal[i].op,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => listSignalView(listSignal!, medal!);
}
