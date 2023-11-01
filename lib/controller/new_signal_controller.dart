import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/app_state_controller.dart';
import 'package:saham_01_app/controller/home_tab_controller.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/core/string.dart';
import 'package:saham_01_app/function/remove_focus.dart';
import 'package:saham_01_app/models/entities/ois.dart';

import '../models/channel.dart';
import '../models/entities/symbols.dart';
import '../models/ois.dart';
import '../models/signal.dart';
import '../views/pages/search/search_multiple_symbols.dart';
import '../views/widgets/get_alert.dart';

class NewSignalController extends GetxController {
  Rx<List<ChannelCardSlim>?> channelStreamCtrl = Rx<List<ChannelCardSlim>?>(null);
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  Rx<Level?> medal = Rx<Level?>(null);
  Rx<TradeSymbol?> symbol = Rx<TradeSymbol?>(null);
  RxBool trySubmit = false.obs;
  RxString errorFormMessage = ''.obs;
  RxBool alreadyBuild = false.obs;
  AppStateController appStateController = Get.find();
  NewHomeTabController newHomeTabController = Get.find();
  DialogController dialogController = Get.find();

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
              settings: const RouteSettings(name: "/search/symbol/multi")));
      if (symbol.value != null) {
        symbolsCon.text = symbol.value!.name!;
        priceCon.text = "";
        slCon.text = "";
        tpCon.text = "";

        priceHint.value = double.parse("0").toStringAsFixed(symbol.value!.digit!);
        slHint.value = double.parse("0").toStringAsFixed(symbol.value!.digit!);
        tpHint.value = double.parse("0").toStringAsFixed(symbol.value!.digit!);
      }
    } catch (e) {
      errorMessage.value = e.toString();
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
      channelStreamCtrl.value = myChannel;

      Future<Level> getMedal({bool clearCache = false}) async {
        return ChannelModel.instance.getMedalList(clearCache: clearCache);
      }

      var result = await getMedal();
      medal.value = result;
      hasError.value = false;
      errorMessage.value = "";
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  Future<List<TradeSymbol>> getTradeSymbols() async {
    List<TradeSymbol> tradeSymbols = await SignalModel.instance.getSymbols() as List<TradeSymbol>;
    return tradeSymbols;
  }

  Future<void> performBuatSignal(BuildContext context, GlobalKey<FormState> formKey) async {
    bool dialog = false;
    
    try {
      trySubmit.value = true;
      bool valid = false;
      if (formKey.currentState!.validate() && data['isSelected'] != null) {
        valid = true;
      }
      if (valid) {
        formKey.currentState?.save();
        double price = double.parse(data['price'].toString().replaceAll(',', '.'));
        double sl = data['sl'] == null || data['sl'] == '' ? 0 : double.parse(data['sl'].toString().replaceAll(',', '.'));
        double tp = data['tp'] == null || data['tp'] == '' ? 0 : double.parse(data['tp'].toString().replaceAll(',', '.'));
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

        if (checkrr && rr > rratio) {
          throw Exception("R:R ratio must be $rratio:1 must be equal or better");
        }

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
                  padding: const EdgeInsets.only(top: 20, bottom: 5),
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
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        width: double.infinity,
                        child: const Text(
                          "Konfirmasi pembuatan signal",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text("SL", style: TextStyle(fontSize: 14)),
                                Text(
                                  "${pipsConverter(risk)} pips",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Text(
                            ":",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  "TP",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "${pipsConverter(reward)} pips",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                  )
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        "RR Ratio: ${rr.toStringAsFixed(2)}:1",
                        style: const TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.w600
                        )
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            style: TextButton.styleFrom(primary: Colors.blue),
                            child: const Text("CANCEL"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            style: TextButton.styleFrom(primary: Colors.blue),
                            child: const Text("OK"),
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

        // DialogLoading dlg = DialogLoading();
        int signalid = 0;
        //TODOs: nanti cek
        removeFocus(context);
        // showDialog(
        //   barrierDismissible: false,
        //   context: context,
        //   builder: (context) {
        //     return dlg;
        //   }
        // );
        dialogController.setProgress(LoadingState.progress, "Signal berhasil dibuat", null, null, null);
        signalid = await SignalModel.instance.createSignal(
          channelid: data["isSelected"], cmd: cmd, price: price, sl: sl, tp: tp, symbol: data["pair"], hour: int.parse("10")
        );

        Get.back();
        await dialogController.setProgress(LoadingState.success, "Signal berhasil dibuat", null, null, null);
        if (signalid > 0) {
          Get.toNamed('/dsc/signal', arguments: {"signalId": signalid});
        }
        newHomeTabController.tab.value = HomeTab.home;
        newHomeTabController.tabController.animateTo(0,duration: const Duration(milliseconds: 200),curve:Curves.easeIn);
        // showAlert(context, LoadingState.success, "Signal berhasil dibuat", thens: (x) {
        //   // Get.until((route) => route.settings.name == '/home');
        //   // Navigator.popUntil(context, ModalRoute.withName("/home"));
        //   // Get.toNamed('/home');
        //   // print("kalau keprint harusnya udah balik home");
        //   // if (signalid > 0) {
        //   //   print("signalid: $signalid");
        //   //   Navigator.pushNamed(context, '/dsc/signal/', arguments: signalid);
        //   //   // Get.toNamed('/dsc/signal/', arguments: signalid);
        //   // }
        //   Future.delayed(Duration.zero, () {
        //     // Navigator.popUntil(context, ModalRoute.withName("/home"));
        //   });
        // });
      }
    } catch (e) {
      if (dialog) {
        Get.back();
      }
      Get.back();
      // showAlert(context, LoadingState.error, e.toString());
      dialogController.setProgress(LoadingState.error, e.toString(), null, null, null);
    }
  }

  TradeSymbol? getSymbol() {
    return symbol.value;
  }

  void handleSelected(int isSelected) {
    data['isSelected'] = isSelected;
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      if (appStateController.users.value.id > 0) {
        await initializePageChannelAsync();
      }
    });
    // Future.delayed(Duration(microseconds: 0)).then((_) async {
    //   await getTradeSymbols();
    // });
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

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
  }
}