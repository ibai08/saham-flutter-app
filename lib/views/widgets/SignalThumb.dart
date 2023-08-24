import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../models/entities/ois.dart';
import '../../models/ois.dart';
import '../../models/signal.dart';
import '../../views/widgets/headingChannelInfo.dart';

class SignalThumb extends StatelessWidget {
  const SignalThumb(
      {Key? key,
      this.title,
      this.channelId,
      this.createdAt,
      this.symbol,
      this.expired,
      this.id,
      this.subscriber,
      @required this.medals,
      @required this.level,
      this.avatar})
      : super(key: key);

  final String? title;
  final int? channelId;
  final String? createdAt;
  final String? symbol;
  final int? expired;
  final int? subscriber;
  final int? id;
  final int? medals;
  final Level? level;
  final String? avatar;

  @override
  Widget build(BuildContext context) {
    if (level == null || level?.level == null) {
      return const SizedBox();
    }
    var m = DateTime.parse(createdAt!).add(const Duration(hours: 7));
    var dateExp = m.add(Duration(seconds: expired!));
    String expiredAt = "Expired";
    if (dateExp.isAfter(DateTime.now())) {
      var diff = dateExp.millisecondsSinceEpoch -
          DateTime.now().millisecondsSinceEpoch;
      double timeLeft = diff / (60 * 60 * 1000);
      if (timeLeft.floor() == 0) {
        timeLeft = diff / (60 * 1000);
        expiredAt = timeLeft.floor().toString() + ' Minutes';
      } else {
        if (timeLeft > 24) {
          expiredAt = (timeLeft / 24).floor().toString() + ' Days';
        } else {
          expiredAt = timeLeft.floor().toString() + ' Hours';
        }
      }
    } else if (expired == 0) {
      expiredAt = "Tidak ada Expired";
    }
    String postedDate = DateFormat('dd MMM yyyy HH:mm').format(m) + " WIB";
    return FutureBuilder<List>(
      future: SignalModel.instance.getSignalTradeByMe(id!),
      builder: (context, snapshot) => Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.white),
        child: Column(
          children: <Widget>[
            HeadingChannelInfo(
              isMedium: true,
              avatar: avatar,
              level: level,
              medals: medals,
              title: title,
              subscriber: subscriber,
              onTap: () {
                OisModel.instance
                    .logActions(
                        channelId: channelId,
                        actionName: "view",
                        stateName: "signal")
                    .then((x) {})
                    .catchError((err) {});
                Navigator.pushNamed(context, '/dsc/channels/',
                    arguments: channelId);
              },
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 5, left: 15, right: 15, bottom: 10),
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Submitted',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: Text(postedDate,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              padding:
                  const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 8),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 225, 230, 232),
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Text('Instrument',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14)),
                      ),
                      Expanded(
                        child: Text(
                          symbol ?? '',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[500],
                  ),
                  Row(
                    children: <Widget>[
                      const Expanded(
                        flex: 3,
                        child: Text('Expired At',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14)),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(expiredAt,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/dsc/signal/', arguments: id);
                },
                style: TextButton.styleFrom(
                  backgroundColor: snapshot.hasData && snapshot.data!.isNotEmpty
                      ? Colors.blueAccent[700]
                      : AppColors.accentGreen,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.all(12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
                child: const Text(
                  "VIEW SIGNAL",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
