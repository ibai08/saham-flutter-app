// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/entities/ois.dart';
import 'channel_thumb.dart';
// import 'signal_shimmer.dart';

class ChannelListWidget extends StatelessWidget {
  final List<Future<ChannelCardSlim>> listChannel;
  final RefreshController? refreshController;
  final Level? medal;
 const ChannelListWidget(this.listChannel, this.refreshController, this.medal, {Key? key}) : super(key: key);

  Widget listChannelView(List<Future<ChannelCardSlim>> channels, Level? medal) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: channels.length,
      itemBuilder: (context, i) {
        return FutureBuilder<ChannelCardSlim>(
          future: channels[i],
          builder: (context, snapshot) {
            ChannelCardSlim? channel = snapshot.data;
            return snapshot.hasData
                ? ChannelThumb(
                    level: medal,
                    id: channel?.id,
                    name: channel?.name,
                    username: channel?.username,
                    price: channel?.price,
                    pips: channel?.pips,
                    post: channel?.postPerWeek,
                    profit: channel?.profit,
                    avatar: channel?.avatar,
                    subscribed: channel?.subscribed,
                    subscriber: channel?.subscriber,
                    medals: channel?.medals,
                    from: "recommend",
                  )
                : (snapshot.hasError
                    ? Text("${snapshot.error}")
                    : SizedBox());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => listChannelView(listChannel, medal);
}
