import 'dart:convert';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/entities/symbols.dart';
import 'package:saham_01_app/models/signal.dart';
import 'package:saham_01_app/models/symbols.dart';

class SignalDetailController extends GetxController {
  RxInt signalid = 0.obs;
  SignalInfo? signalInfo;
  Rx<String?>? signalSubs = "".obs;
  RxString errorStatus = "".obs;
  RxBool signalConError = false.obs;
  RxBool listTradeError = false.obs;
  RxBool isInit = false.obs;

  RefreshController refreshController = RefreshController(initialRefresh: false);
  int digit = -1;
  List<TradeSymbol> tradeSymbols = SymbolModel.instance.getSymbols();
  final Rx<SignalInfo?> signalCon = Rx<SignalInfo?>(null);
  final Rx<List<SignalTradeCopyLogSlim>?> listTrade = Rx<List<SignalTradeCopyLogSlim>?>(null);

  var arguments;

  Future<void> initializeSignalAsync({bool clearCache = false}) async {
    signalid.value = 0;
    if (arguments is int) {
      signalid.value = arguments;
    }

    try {
      if (signalid.value < 1) {
        throw Exception("REQUESTED_SIGNAL_NOT_FOUND");
      }
      signalSubs = await SignalModel.instance.subsribeSignalAsync(
        signalid: signalid.value,
        clearCache: clearCache
      );

      if (signalSubs?.value != null) {
        if (signalSubs?.value.toString() == "") {
            Get.until((route) => route.settings.name == "/home");
            return;
          }
          try {
            Map boxData = jsonDecode(signalSubs!.value!);
            signalInfo = SignalInfo.fromMap(boxData);
            TradeSymbol? tradeSymbol = tradeSymbols.firstWhere(
                (element) =>
                    element.name?.toLowerCase() ==
                    signalInfo?.symbol?.toLowerCase(), orElse: () => TradeSymbol(name: null, digit: null));
            if (tradeSymbol.digit != null) {
              digit = tradeSymbol.digit!;
            }
            signalCon.value = signalInfo;
          } catch (e, stack) {
            errorStatus.value = e.toString();
            signalConError.value = true;
          }
      }
      isInit.value = true;
    } catch (e) {
      errorStatus.value = e.toString();
      signalConError.value = true;
    }

    try {
      int refresh = 18000;
      if (clearCache) {
        refresh = 0;
      }
      List tradeSignal = await SignalModel.instance.getSignalTradeByMe(signalid.value, refreshSeconds: refresh);
    } catch (xerr) {
      // listTrade.addError(xerr);
      errorStatus.value = xerr.toString();
      listTradeError.value = true;
    }
  }

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    signalSubs?.close();
    await initializeSignalAsync(clearCache: true);
    refreshController.refreshCompleted();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(microseconds: 0)).then((_) async {
      await initializeSignalAsync(clearCache: true);
    });
  }

  @override 
  void onClose() {
    super.onClose();
    signalSubs?.close();
  }
}