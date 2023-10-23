import 'package:flutter/material.dart';
import '../../models/entities/ois.dart';
import 'signal_thumb_new.dart';

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
  const SignalListWidget(this.listSignal, this.medal, {Key? key}) : super(key: key);

  Widget listSignalView(List<SignalCardSlim> signal, Level medal) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
    );
  }

  @override
  Widget build(BuildContext context) => listSignalView(listSignal!, medal!);
}
