import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/models/entities/symbols.dart';
import 'package:saham_01_app/models/symbols.dart';

class SignalDetailWidget extends GetxController {
  final String? symbol;
  final String? type;
  final String? expired;
  final String? closeTime;
  final String? openTime;
  final String? createdAt;
  final int? pips;
  final double? tp;
  final double? sl;
  final double? price;
  final double? profit;
  final int? status;
  final int? id;

  final List<TradeSymbol> tradeSymbols = SymbolModel.instance.getSymbols();

  SignalDetailWidget({
    Key? key,
    this.symbol,
    this.type,
    this.expired,
    this.closeTime,
    this.openTime,
    this.createdAt,
    this.pips,
    this.tp,
    this.sl,
    this.price,
    this.status,
    this.profit,
    this.id
  });

  @override
  Widget build(BuildContext context) {
    final TradeSymbol? tradeSymbol = tradeSymbols.firstWhere((element) {
      String? name = element.name ?? '';
      String? symbols = symbol ?? '';
      return name.toLowerCase() == symbols.toLowerCase();
    });

    final digit = tradeSymbol == null ? -1 : tradeSymbol.digit;

    var btnTxt = "Expired";
    Color? btnColor = Colors.grey[300];
    Color txtColor = Colors.black;
    late Widget btn;
    switch (status) {
      case 0:
        if (pips! > 0) {
          btnTxt = "${NumberFormat("#,###.##", "ID").format((pips! / 10) * 10000)} IDR";
          btnColor = AppColors.primaryGreen;
          txtColor = Colors.white;
        } else if (pips! < 0) {
          btnTxt = "${NumberFormat("#,###.##", "ID").format((pips! / 10) * 10000)} IDR";
          btnColor = Colors.red;
          txtColor = Colors.white;
        } else {
          btnTxt = "EXPIRED";
          btnColor = Colors.grey[300];
          txtColor = Colors.black;
        }
        btn = GestureDetector(
          child: Container(
            width: double.infinity,
            color: btnColor,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              btnTxt,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: txtColor
              ),
            ),
          ),
        );
        break;
      case 1:
        btnTxt = "VIEW SIGNAL";
        btnColor = AppColors.accentGreen;
        txtColor = Colors.white;
        btn = Container(
          width: double.infinity,
          color: btnColor,
          margin: const EdgeInsets.only(top: 10),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 0)
            ),
            onPressed: () {
              Get.toNamed('/dsc/signal/', arguments: id);
            },
            child: Text(
              btnTxt,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: txtColor
              ),
            ),
          ),
        );
        break;
      case 2:
        btnTxt = "RUNNING";
        btnColor = AppColors.primaryYellow;
        txtColor = Colors.white;
        btn = Container(
          width: double.infinity,
          color: btnColor,
          margin: const EdgeInsets.only(top: 10),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 0)
            ),
            onPressed: () {
              Get.toNamed('/dsc/signal/', arguments: id);
            },
            child: Text(
              btnTxt,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: txtColor
              ),
            ),
          ),
        );
        break;
      case 3:
        btnTxt = "CANCELED";
        btn = Container(
          width: double.infinity,
          color: btnColor,
          margin: const EdgeInsets.only(top: 10),
          child: TextButton(
            style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onPressed: null,
              child: Text(
                btnTxt,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w400, color: txtColor),
              )
          ),
        );
        break;
    }

    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
      padding: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        color: Colors.white
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Created at',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    createdAt ?? ' ',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            padding: const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        symbol ?? ' ',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        type ?? ' ',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                        ),
                      ),
                    )
                  ],
                ),
                Divider(
                  color: Colors.grey[500],
                ),
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        'Price',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14)
                      ),
                    ),
                    Expanded(
                      child: Text(
                        price! > 0 ? (digit! > -1 ? price!.toStringAsFixed(digit) : price.toString()) : ' ', 
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),
                tp! > 0 ? Divider(
                  color: Colors.grey[500],
                ) : const SizedBox(),
                tp! > 0 ? Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        'Take Profit',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tp! > 0 ? (digit! > -1 ? tp!.toStringAsFixed(digit) : tp.toString()) : ' ',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                        ), 
                      ),
                    ),
                  ],
                ) : const SizedBox(),
                sl! > 0 ? Divider(
                  color: Colors.grey[500],
                ) : const SizedBox(),
                sl! > 0 ? Row (
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        'Stop Loss',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        sl! > 0 ? (digit! > -1 ? sl!.toStringAsFixed(digit) : sl.toString()) : ' ',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                        ),
                      ),
                    ),
                  ]
                ) : const SizedBox(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(
                      status == 3 || status == 1
                          ? "Expired at"
                          : 'Opened at',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 12)),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                      status == 3 || status == 1
                          ? expired!
                          : openTime ?? ' ',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          if (status == 0 || status == 3) 
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Row(
                children: <Widget>[
                  const Expanded(
                    flex: 2,
                    child: Text("Closed at",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(closeTime!,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          btn
        ],
      ),
    );
  }


}