// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';

class ChannelPointPrompt extends StatelessWidget {
  final String? level;
  final String? channelName;
  final double? point;
  final int? medal;
  final int? needMedal;

  const ChannelPointPrompt(
      {Key? key,
      @required this.level,
      @required this.channelName,
      @required this.point,
      @required this.medal,
      @required this.needMedal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/${level?.toLowerCase()}.png',
                        width: 55,
                        height: 55,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Hi $channelName, sekarang kamu adalah',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                            ),
                            Text(
                              level!,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
              Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.assistant,
                              color: Colors.grey[700],
                              size: 28,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'XYZ Point',
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                NumberFormat.currency(
                                        decimalDigits: 0, symbol: "")
                                    .format(point?.round()),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0),
                              ),
                            ],
                          )
                        ],
                      )),
                      Container(
                          height: 20,
                          child: VerticalDivider(
                            color: Colors.grey[700],
                          )),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.stars,
                              color: Colors.grey[700],
                              size: 28,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'XYZ Medal',
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                medal.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
              needMedal! <= 0
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Butuh $needMedal XYZ Medal lagi untuk naik Level',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      )),
            ]),
      ),
    );
  }
}
