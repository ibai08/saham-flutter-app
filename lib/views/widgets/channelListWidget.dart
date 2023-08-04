import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/views/widgets/channelThumb.dart';

class ChannelListWidget extends StatelessWidget {
  final List<Future<ChannelCardSlim>>? listChannel;
  final RefreshController? refreshController;
  final Level? medal;
  ChannelListWidget(this.listChannel, this.refreshController , this.medal);

  Widget listChannelView(List<Future<ChannelCardSlim>> channels, Level medal) {
    print("ada medal: $medal");
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: channels.length,
        itemBuilder: (context, i) {
          return FutureBuilder<ChannelCardSlim>(
            future: channels[i],
            builder: (context, snapshot) {
              ChannelCardSlim? channel = snapshot.data;
              print("ada int? : ${channel?.id}");
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
                ) : (snapshot.hasError ? Text("${snapshot.error}") : Text("gak tau"));
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => listChannelView(listChannel!, medal!);
}