// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import '../../models/entities/ois.dart';
import '../../views/widgets/signalDetailWithHeader.dart';

class RecentSignalListWidget extends StatefulWidget {
  final List<SignalInfo>? listSignal;
  final Level? medal;
  const RecentSignalListWidget(this.listSignal, this.medal, {Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecentSignalListWidget();
}

class _RecentSignalListWidget extends State<RecentSignalListWidget> {
  Widget listSignalView(List<SignalInfo>? signal, Level? medal) {
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: signal?.length,
          itemBuilder: (context, i) {
            return SignalDetailWithHeaderNew(
              subscriber: signal?[i].channel?.subscriber,
              level: medal,
              medals: signal?[i].channel?.medals,
              title: signal?[i].channel?.title,
              username: signal?[i].channel?.username ?? "-",
              channelId: signal?[i].channel?.id,
              id: signal?[i].id,
              symbol: signal?[i].symbol,
              createdAt: signal?[i].createdAt,
              profit: signal?[i].profit,
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) =>
      listSignalView(widget.listSignal, widget.medal);
}
