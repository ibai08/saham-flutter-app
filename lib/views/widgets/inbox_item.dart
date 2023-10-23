// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/channel.dart';
import '../../models/entities/inbox.dart';
import '../../models/entities/ois.dart';
import 'channel_avatar.dart';

class InboxItem extends StatefulWidget {
  final title;
  final description;
  final status;
  final date;
  final data;
  final InboxType? type;
  const InboxItem(
      {Key? key,
      this.title,
      this.description,
      this.status,
      this.date,
      this.data,
      this.type})
      : super(key: key);
  @override
  _InboxItemState createState() => _InboxItemState();
}

class _InboxItemState extends State<InboxItem> {
  Function? _onTap;
  bool? _bgColor = false;
  void signalOnTap(BuildContext context) {
    Map? tmpData;
    Map? params;

    try {
      params = jsonDecode(widget.data["params"]);
      if (params is Map &&
          params.containsKey("type") &&
          params["type"] == "signal") {
        tmpData = jsonDecode(widget.data["message"]);
        int signalid = 0;
        if (tmpData?["signalid"] is String || tmpData?["signalid"] is int) {
          signalid = int.tryParse(tmpData!["signalid"].toString()) ?? 0;
        }
        _onTap = () {
          Navigator.pushNamed(context, '/dsc/signal/', arguments: {
            "signalid": signalid,
            "inboxid": widget.data["id"],
            "baca": widget.status
          });
        };
        return;
      }
    } catch (xerr) {
      print(xerr);
    }
    _onTap = () {};
  }

  @override
  Widget build(BuildContext context) {
    var lightG;
    if (widget.status == 0) {
      lightG = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          shape: BoxShape.circle,
        ),
      );
    }

    Widget image = Image.asset("assets/icons-news.png");

    Map? params = jsonDecode(widget.data["params"]);
    if (params is Map && params.containsKey("broker")) {
      switch (params["broker"]) {
        case "mrg":
          image = Image.asset(
            'assets/logo-black.png',
          );
          // image = Image.asset("assets/icon-mini-mrg.png");
          break;
        case "askap":
          // image = Image.asset("assets/icon-mini-askap.png");
          image = Image.asset(
            'assets/logo-black.png',
          );
          break;
      }
    }

    switch (widget.type) {
      case InboxType.wptfpost:
        try {
          Map message = jsonDecode(widget.data["message"]);
          _onTap = () {
            Navigator.pushNamed(context, '/inbox/wptfpost', arguments: {
              "inboxid": widget.data["id"],
              "postid": message["postId"]
            });
          };
        } catch (xerr) {
          _onTap = () {};
        }
        break;
      case InboxType.html:
        _onTap = () {
          Navigator.pushNamed(context, '/inbox/html', arguments: widget.data);
        };
        break;
      case InboxType.signal:
        Map? tmpData;
        Map? params;

        int channelId = 0;
        try {
          params = jsonDecode(widget.data["params"]);
          if (params is Map &&
              params.containsKey("type") &&
              params["type"] == "signal") {
            tmpData = jsonDecode(widget.data["message"]);
            if (tmpData?["channel_id"] is String ||
                tmpData?["channel_id"] is int) {
              channelId = int.tryParse(tmpData!["channel_id"].toString()) ?? 0;
            }
          }
        } catch (_) {}
        image = channelId > 0
            ? FutureBuilder<ChannelCardSlim>(
                future: ChannelModel?.instance.getDetail(channelId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ChannelAvatar(
                      width: 47,
                      imageUrl: snapshot.data!.avatar!,
                    );
                  }
                  return const ChannelAvatar(
                    width: 47,
                  );
                },
              )
            : const ChannelAvatar();
        signalOnTap(context);
        break;
      case InboxType.payment:
        try {
          image = Image.asset("assets/icons-payment.png");
          Map message = jsonDecode(widget.data["message"]);
          _onTap = () {
            Navigator.pushNamed(context, '/dsc/payment/status', arguments: {
              "inboxid": widget.data["id"],
              "billNo": message["billNo"]
            });
          };
        } catch (xerr) {
          _onTap = () {};
        }
        break;
      default:
        break;
    }

    return MaterialButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        _onTap;
      },
      onLongPress: () {
        setState(() {
          _bgColor = _bgColor! ? false : true;
        });
      },
      color: _bgColor! ? Colors.lightGreen[200] : Colors.white,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border:
                Border(bottom: BorderSide(color: Colors.grey[400]!, width: 1))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: image,
                    padding: const EdgeInsets.only(top: 5),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 12,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 10, bottom: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.title,
                            softWrap: false,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.description,
                            style: const TextStyle(fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            widget.date,
                            style: const TextStyle(fontSize: 12),
                            softWrap: false,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          lightG ?? const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
