import 'dart:convert';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/entities/symbols.dart';
import 'package:saham_01_app/models/signal.dart';
import 'package:saham_01_app/models/symbols.dart';

class SignalDetailController extends GetxController {
  RxInt? signalid;
  SignalInfo? signalInfo;
  RxString? signalSubs;
  RxString? errorStatus;
  RxBool signalConError = false.obs;
  RxBool listTradeError = false.obs;

  RefreshController refreshController = RefreshController(initialRefresh: false);
  int digit = -1;
  List<TradeSymbol> tradeSymbols = SymbolModel.instance.getSymbols();
  final Rx<SignalInfo?> signalCon = Rx<SignalInfo?>(null);
  final Rx<List<SignalTradeCopyLogSlim>?> listTrade = Rx<List<SignalTradeCopyLogSlim>?>(null);


  var arguments;

  Future<void> initializeSignalAsync({bool clearCache = false}) async {
    signalid?.value = 0;
    if (arguments is int) {
      signalid?.value = arguments;
    }

    try {
      if (signalid!.value < 1) {
        throw Exception("REQUESTED_SIGNAL_NOT_FOUND");
      }
      signalSubs?.value = await SignalModel.instance.subsribeSignalAsync(
        signalid: signalid?.value,
        clearCache: clearCache
      );

      if (signalSubs?.value != "null") {
        signalSubs?.listen((handleData) {
          if (handleData == "") {
            Get.until((route) => route.settings.name == "/home");
            return;
          }
          try {
            Map boxData = jsonDecode(handleData);
            signalInfo = SignalInfo.fromMap(boxData);
            TradeSymbol? tradeSymbol = tradeSymbols.firstWhere((element) => element.name?.toLowerCase() == signalInfo?.symbol?.toLowerCase(), orElse: () => null as TradeSymbol);
            if (tradeSymbols != null) {
              digit = tradeSymbol.digit!;
            }
            signalCon.value = signalInfo;
          } catch (e) {
            print(e);
            errorStatus?.value = e.toString();
            signalConError.value = true;
          }
        });
      }
    } catch (e) {
      // signalCon.addError(e);
      print(e);
      errorStatus?.value = e.toString();
      signalConError.value = true;
    }

    try {
      int refresh = 18000;
      if (clearCache) {
        refresh = 0;
      }
      List tradeSignal = await SignalModel.instance.getSignalTradeByMe(signalid!.value, refreshSeconds: refresh);
    } catch (xerr) {
      // listTrade.addError(xerr);
      print(xerr);
      errorStatus?.value = xerr.toString();
      listTradeError.value = true;
    }
  }

  void onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    signalSubs?.close();
    await initializeSignalAsync(clearCache: true);
    refreshController.refreshCompleted();
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(microseconds: 0)).then((_) async {
      await initializeSignalAsync(clearCache: true);
    });
  }

  @override 
  void onClose() {
    super.onClose();
    signalSubs?.close();
  }
}