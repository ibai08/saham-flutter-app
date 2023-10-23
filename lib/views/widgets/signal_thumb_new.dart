import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/views/widgets/heading_channel_info_new.dart';
import '../../constants/app_colors.dart';
import '../../models/entities/ois.dart';
import '../../models/ois.dart';
import '../../models/signal.dart';

import '../../config/symbol_config.dart';

class SignalThumbNew extends StatelessWidget {
  const SignalThumbNew({
    Key? key,
    this.title,
    this.channelId,
    this.createdAt,
    this.symbol,
    this.expired,
    this.id,
    this.subscriber,
    @required this.medals,
    @required this.level,
    this.avatar,
    this.op,
  }) : super(key: key);

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
  final int? op;

  @override
  Widget build(BuildContext context) {
    if (level == null || level?.level == null) {
      return const SizedBox();
    }
    var m = DateTime.parse(createdAt!).add(const Duration(hours: 7));
    // var dateExp = m.add(Duration(seconds: expired));
    // String expiredAt = "Expired";
    String titleSymbol = symbolConfig.firstWhere(
            (config) => config['symbol'] == symbol,
            orElse: () => {})['title'] ??
        '';

    Color cusColors = Colors.black;

    // switch(symbol) {
    //   case 'BBCA':
    //     titleSymbol = "Bank Central Asia Tbk.";
    //     break;
    //   case 'PACK':
    //     titleSymbol = "Solusi Kemasan Digital Tbk.";
    //     break;
    //   case 'CHIP':
    //     titleSymbol = "Pelita Teknologi Global Tbk.";
    //     break;
    //   case 'VAST':
    //     titleSymbol = "Vastland Indonesia Tbk.";
    //     break;
    //   case 'HILL':
    //     titleSymbol = "Hillcon Tbk.";
    //     break;
    //   case 'HALO':
    //     titleSymbol = "Haloni Jane Tbk.";
    //     break;
    //   case 'PTMP':
    //     titleSymbol = "Mitra Pack Tbk.";
    //     break;
    //   case 'TCKA':
    //     titleSymbol = "Tigaraksa Satria Tbk.";
    //     break;
    //   case 'BDKR':
    //     titleSymbol = "Berdikari pondasi Perkasa Tbk.";
    //     break;
    //   case 'FUTR':
    //     titleSymbol = "Lini Imaji Kreasi Ekosistem Tbk.";
    //     break;
    //   case 'TFCO':
    //     titleSymbol = "Tifico Fiber Indonesia Tbk.";
    //     break;
    //   case 'TELE':
    //     titleSymbol = "Omni Inovasi Indonesia Tbk.";
    //     break;
    //   case 'PGEO':
    //     titleSymbol = "Pertamina Geothermal Energy Tbk.";
    //     break;
    //   case 'TCID':
    //     titleSymbol = "Mandom Indonesia Tbk.";
    //     break;
    //   case 'TIFA':
    //     titleSymbol = "Tifa Finance Tbk.";
    //     break;
    //   case 'TINS':
    //     titleSymbol = "Timah Tbk.";
    //     break;
    //   default:
    //     titleSymbol = "";
    //     break;
    // }

    String goodTill = "";
    if (op == 0) {
      goodTill = "GTC";
    } else if (op == 1) {
      goodTill = "GFD";
    } else {
      goodTill = "expired";
    }
    if (goodTill == "GTC") {
      cusColors = AppColors.blueGem;
    } else if (goodTill == "GFD") {
      cusColors = AppColors.yellowyGreen;
    }
    // if (dateExp.isAfter(DateTime.now())) {
    //   var diff = dateExp.microsecond - DateTime.now().microsecondsSinceEpoch;
    //   double timeLeft = diff / (60 * 60 * 1000);
    //   if (timeLeft.floor() == 0) {
    //     timeLeft = diff / (60 * 1000);
    //     expiredAt = timeLeft.floor().toString() + ' Minutes';
    //   } else {
    //     if (timeLeft > 24) {
    //       expiredAt = (timeLeft / 24).floor().toString() + ' Days';
    //     } else {
    //       expiredAt = timeLeft.floor().toString() + ' Hours';
    //     }
    //   }
    // } else if (expired == 0) {
    //   expiredAt = "Tidak ada Expired";
    // }
    String postedDate = DateFormat('dd MMM yyyy HH:mm').format(m) + " WIB";
    return FutureBuilder<List>(
      future: SignalModel.instance.getChannelSignals(channelId, 1, 1),
      builder: (context, snapshot) => Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.white),
        child: Column(
          children: <Widget>[
            HeadingChannelInfoNew(
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
                Get.toNamed('/dsc/channels/', arguments: {
                  "channelId": channelId
                });
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                height: 1,
                thickness: 1,
                indent: 1,
                endIndent: 0,
                color: Color(0xFFC9CCCF),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.all(15.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symbol ?? "",
                          style: const TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          titleSymbol,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          goodTill,
                          style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: cusColors),
                        ),
                        Text(
                          "Submitted: $postedDate",
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 11,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
