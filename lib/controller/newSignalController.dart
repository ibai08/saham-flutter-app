import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/core/string.dart';
import 'package:saham_01_app/function/removeFocus.dart';
import 'package:saham_01_app/function/showAlert.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/views/widgets/dialogLoading.dart';

import '../function/helper.dart';
import '../models/channel.dart';
import '../models/entities/symbols.dart';
import '../models/ois.dart';
import '../models/signal.dart';
import '../views/pages/search/searchMultipleSymbols.dart';

class NewSignalController extends GetxController {
  RxList<ChannelCardSlim>? channelStreamCtrl = RxList<ChannelCardSlim>();
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  Rx<Level?> medal = Rx<Level?>(null);
  Rx<TradeSymbol?> symbol = Rx<TradeSymbol?>(null);
  RxBool trySubmit = false.obs;
  RxString errorFormMessage = ''.obs;

  RxBool isSelected = false.obs;

  List<Map> expiredList = [
      {"id": "0", "title": "Good For Day (GFD)"},
      {"id": "1", "title": "Good Till Cancelled (GTC)"},
    ].where((item) => item["id"] != null).toList();

  final Map data = {};
  RxString expiredAtValue = "0".obs;

  final symbolsCon = TextEditingController();
  final priceCon = TextEditingController();
  final tpCon = TextEditingController();
  final slCon = TextEditingController();
  final priceValue = TextEditingController();
  final stopLosValue = TextEditingController();
  final takeProfitValue = TextEditingController();

  final priceFocus = FocusNode();
  final tpFocus = FocusNode();
  final slFocus = FocusNode();
  final expiredFocus = FocusNode();

  RxString priceHint = "".obs;
  RxString tpHint = "".obs;
  RxString slHint = "".obs;

  Future navigateToSubPage(context, txtCur) async {
    try {
      symbol.value = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchMultipleSymbols(current: txtCur, options: SearchMultipleSymbolsOptions.single),
              settings: RouteSettings(name: "/search/symbol/multi")));
      if (symbol != null) {
        symbolsCon.text = symbol.value!.name!;
        priceCon.text = "";
        slCon.text = "";
        tpCon.text = "";

        priceHint.value = double.parse("0").toStringAsFixed(symbol.value!.digit!);
        slHint.value = double.parse("0").toStringAsFixed(symbol.value!.digit!);
        tpHint.value = double.parse("0").toStringAsFixed(symbol.value!.digit!);
      }
    } catch (e, stack) {
      print("errorrr navigate: $e");
      print("stack: $stack");
    }
  }

  // Future<void> initForm() async {
  //   try {
  //     List<ChannelCardSlim> myChannel = await OisModel.instance.getMyChannel(clearCache: true);
  //     channelStreamCtrl.add(myChannel);
  //   } catch(e) {
  //     hasError.value = true;
  //     errorMessage.value = e.toString();
  //   }
  // }

  Future<void> initializePageChannelAsync({bool clearCache = false}) async {
    try {
      List<ChannelCardSlim> myChannel = await OisModel.instance.getMyChannel(clearCache: true);
      channelStreamCtrl?.addAll(myChannel);

      Future<Level> getMedal({bool clearCache = false}) async {
        return ChannelModel.instance.getMedalList(clearCache: clearCache);
      }

      var result = await getMedal();
      medal.value = result;
      print("-----------------------OKKK__________________OKKK-------------------");
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print("errorr init");
    }
  }

  Future<List<TradeSymbol>> getTradeSymbols() async {
    List<TradeSymbol> tradeSymbols = await SignalModel.instance.getSymbols() as List<TradeSymbol>;
    return tradeSymbols;
  }

  Future<void> performBuatSignal(BuildContext context, GlobalKey<FormState> formKey) async {
    bool dialog = false;
    print("jalan 1");
    print("formkey: $formKey");
    
    try {
      trySubmit.value = true;
      bool valid = false;
      if (formKey.currentState!.validate() && data['isSelected'] != null) {
        print("kena uyy");
        valid = true;
      }
      print("data: ${data['price']}");
      print("jalan 2");
      if (valid) {
        formKey.currentState?.save();
        print("jalan 3");
        double price = double.parse(data['price'].toString().replaceAll(',', '.'));
        double sl = data['sl'] == null || data['sl'] == '' ? 0 : double.parse(data['sl'].toString().replaceAll(',', '.'));
        double tp = data['tp'] == null || data['tp'] == '' ? 0 : double.parse(data['tp'].toString().replaceAll(',', '.'));

        print("sl: $sl");
        print("tp: $tp");
        print("price: $price");
        print("data: ${data['price']}");
        print("dataselected: ${data['pair']}");
        print("dataselected: ${data['isSelected']}");
        print("expired at: ${expiredAtValue.value}");
        int digit = getSymbol()!.digit!;
        num digitMulti = pow(10, digit);

        String cmd = "BUY";

        if (sl > price) {
          throw Exception("SL_MUST_BE_LOWER_THAN_PRICE");
        }

        if (tp < price) {
          throw Exception("TP_MUST_BE_HIGHER_THAN_PRICE");
        }

        double rratio = double.tryParse(remoteConfig.getString("risk_reward_ratio")) ?? 1.5;

        int risk = ((price - sl).abs() * digitMulti).floor();
        int reward = ((price - tp).abs() * digitMulti).floor();

        bool checkrr = remoteConfig.getInt("risk_reward_ratio_check") == 1 ? true : false;

        double rr = risk / reward;

        // if (checkrr && rr > rratio) {
        //   throw Exception("R:R ratio must be $rratio:1 must be equal or better");
        // }

        removeFocus(context);
        bool confirm = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            elevation: 0.0,
            backgroundColor:  Colors.transparent,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0)
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: double.infinity,
                        child: Text(
                          "Konfirmasi pembuatan signal",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text("SL", style: TextStyle(fontSize: 14)),
                                Text(
                                  "${pipsConverter(risk)} pips",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            ":",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "TP",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "${pipsConverter(reward)} pips",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                  )
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 24.0),
                      Text(
                        "RR Ratio: ${rr.toStringAsFixed(2)}:1",
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.w600
                        )
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            style: TextButton.styleFrom(primary: Colors.blue),
                            child: Text("CANCEL"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            style: TextButton.styleFrom(primary: Colors.blue),
                            child: Text("OK"),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        );
        if (!confirm) {
          return;
        }

        dialog = true;

        DialogLoading dlg = DialogLoading();
        int signalid = 0;
        removeFocus(context);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return dlg;
          }
        );
        signalid = await SignalModel.instance.createSignal(
          channelid: data["isSelected"], cmd: cmd, price: price, sl: sl, tp: tp, symbol: data["pair"], hour: int.parse("10")
        );

        Get.back();
        showAlert(context, LoadingState.success, "Signal berhasil dibuat", thens: (x) {
          // Get.until((route) => route.settings.name == '/home');
          // Navigator.popUntil(context, ModalRoute.withName("/home"));
          // Get.toNamed('/home');
          // print("kalau keprint harusnya udah balik home");
          // if (signalid > 0) {
          //   print("signalid: $signalid");
          //   Navigator.pushNamed(context, '/dsc/signal/', arguments: signalid);
          //   // Get.toNamed('/dsc/signal/', arguments: signalid);
          // }
          print("context: $context");
          Future.delayed(Duration.zero, () {
            // Navigator.popUntil(context, ModalRoute.withName("/home"));
            appStateController?.setAppState(Operation.bringToHome, HomeTab.home);
            print("kalau keprint harusnya udah balik home");
          });
        });
      }
    } catch (e, stack) {
      print("error: $e");
      print("stackerror: $stack");
      if (dialog) {
        Get.back();
      }
      showAlert(context, LoadingState.error, e.toString());
    }
  }

  TradeSymbol? getSymbol() {
    print("symbol.value : ${symbol.value}");
    return symbol.value;
  }

  void handleSelected(int isSelected) {
    print("isSelected: $isSelected");
    data['isSelected'] = isSelected;
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(microseconds: 0)).then((_) async {
      await initializePageChannelAsync();
    });
    Future.delayed(Duration(microseconds: 0)).then((_) async {
      await getTradeSymbols();
    });
  }

  @override
  void onClose() {
    super.onClose();
    // priceHint.close();
    // tpHint.close();
    // slHint.close();
    // channelStreamCtrl?.close();
    // symbol;
    symbolsCon.clear();
    priceCon.clear();
    tpCon.clear();
    slCon.clear();
    priceValue.clear();
    stopLosValue.clear();
    takeProfitValue.clear();
    print("sudah kedelete");
  }
}