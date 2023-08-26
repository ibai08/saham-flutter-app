// ignore_for_file: constant_identifier_names, null_check_always_fails, unnecessary_null_comparison, empty_catches, avoid_print

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:sprintf/sprintf.dart';
import '../../core/getStorage.dart';

enum TransactionType { subscribePayment, withdraw, reward }

enum TransactionStatus { waiting, refused, success }

enum RedeemStatus { waiting, cancelled, success }

enum SearchType { signal, channel }

enum SignalStatus { active, expired }

enum TradeCommand {
  OP_BUY,
  OP_SELL,
  OP_BUY_LIMIT,
  OP_SELL_LIMIT,
  OP_BUY_STOP,
  OP_SELL_STOP,
  OP_BALANCE,
  OP_CREDIT
}

String getTradeCommandString(int index) {
  switch (index) {
    case 0:
      return "Buy";
    case 1:
      return "Sell";
    case 2:
      return "Buy";
    case 3:
      return "Sell";
    case 4:
      return "Buy";
    case 5:
      return "Sell";
    case 6:
      return "Balance";
    default:
      return "Credit";
  }
}

List<SignalCardSlim> listSignalCardSlimFromListMap(List signalData) {
  List<SignalCardSlim> tmp = [];
  for (Map scs in signalData) {
    tmp.add(SignalCardSlim.fromMap(scs));
  }
  return tmp;
}

List<ChannelCardSlim> listChannelCardSlimFromListMap(List channelData) {
  List<ChannelCardSlim> tmp = [];
  for (Map ccs in channelData) {
    tmp.add(ChannelCardSlim.fromMap(ccs));
  }
  return tmp;
}

class OisSearch {
  String? search;
  SearchType? type;
  List<SignalStatus>? signalStates;

  OisSearch({this.search, this.type, this.signalStates});

  static OisSearch clone(OisSearch user) {
    try {
      return OisSearch(
          search: user.search,
          type: user.type,
          signalStates: user.signalStates);
    } catch (xerr) {
      return OisSearch.init();
    }
  }

  static OisSearch init() {
    return OisSearch(search: null, type: null, signalStates: null);
  }
}

class ChannelInfo {
  int? id;
  int? userid;
  String? username;
  String? title;
  String? caption;
  double? price;
  int? status;
  int? createdTimeStamp;
  String? avatar;
  int? medals;
  double? point;
  int? subscriber;

  // static List<String> _keyRequired = [
  //   "id",
  //   "userid",
  //   "username",
  //   "title",
  //   "caption",
  //   "price",
  //   "status",
  //   "createdTimeStamp"
  // ];

  ChannelInfo._privateConstructor(
      {this.id,
      this.userid,
      this.username,
      this.title,
      this.caption,
      this.price,
      this.status,
      this.createdTimeStamp,
      this.avatar,
      this.medals,
      this.point,
      this.subscriber});

  factory ChannelInfo.createObject(
      {id = 0,
      userid = 0,
      username,
      title,
      caption,
      price,
      status,
      createdTimeStamp,
      avatar,
      medals,
      point,
      subscriber}) {
    return ChannelInfo?._privateConstructor(
      id: id,
      userid: userid,
      username: username,
      title: title,
      caption: caption,
      price: price,
      status: status,
      createdTimeStamp: createdTimeStamp,
      avatar: avatar,
      medals: medals,
      point: point,
      subscriber: subscriber,
    );
  }

  factory ChannelInfo.fromMap(Map? data) {
    try {
      // _keyRequired.forEach((v) {
      //   if (data.containsKey(v)) {
      //     throw new Exception("INVALID_CHANNEL_MAP_INFO");
      //   }
      // });

      return ChannelInfo._privateConstructor(
          id: data?["id"],
          userid: data?["userid"],
          username: data?["username"],
          title: data?["title"],
          caption: data?["caption"],
          price: data?["price"],
          status: data?["status"],
          createdTimeStamp: data?["createdTimeStamp"],
          avatar: data?["avatar"],
          medals: data?["medals"],
          point: data?["point"],
          subscriber: data?["subscriber"]);
    } catch (xerr) {}

    return null!;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userid": userid,
      "username": username,
      "title": title,
      "caption": caption,
      "price": price,
      "status": status,
      "createdTimeStamp": createdTimeStamp,
      "avatar": avatar
    };
  }

  // static List<String> getKeyRequired() {
  //   return _keyRequired;
  // }
}

class ChannelSummary {
  ChannelSummaryDetail? detail;
  List<ChannelSummaryGrowth>? listGrowth;
  // static List<String> _keyRequired = ["detail", "growth"];

  ChannelSummary({this.detail, this.listGrowth});
  factory ChannelSummary.fromTF2v1API(Map input) {
    try {
      Map data = input["summary"];
      List growth = input["growth"];

      ChannelSummaryDetail tmpDetail = ChannelSummaryDetail.createObject(
        signalActive: int.tryParse(data["jml_active"].toString()) ?? 0,
        signalSettle: int.tryParse(data["jml_settle"].toString()) ?? 0,
        signalCount: int.tryParse(data["jml_signal"].toString()) ?? 0,
        profitCount: int.tryParse(data["jml_profit"].toString()) ?? 0,
        lossCount: int.tryParse(data["jml_loss"].toString()) ?? 0,
        expiredCount: int.tryParse(data["jml_expired"].toString()) ?? 0,
        averagePostPerWeek: int.tryParse(data["post_per_week"].toString()) ?? 0,
        profitTotal: double.tryParse(data["total_profit"].toString()) ?? 0.00,
        lossTotal: double.tryParse(data["total_loss"].toString()) ?? 0.00,
        pips: int.tryParse(data["pips"].toString()) ?? 0,
        favouriteSymbol: data["fav_symbol"].toString(),
        weekAge: int.tryParse(data["minggu"].toString()) ?? 0,
        consecutiveProfitCount:
            int.tryParse(data["consecutiveProfitCount"].toString()) ?? 0,
        consecutiveProfitSum:
            double.tryParse(data["consecutiveProfitSum"].toString()) ?? 0.00,
        consecutiveLossCount:
            int.tryParse(data["consecutiveLossCount"].toString()) ?? 0,
        consecutiveLossSum:
            double.tryParse(data["consecutiveLossSum"].toString()) ?? 0.00,
      );

      List<ChannelSummaryGrowth> results = growth
          .map<ChannelSummaryGrowth>((json) =>
              ChannelSummaryGrowth.createObject(
                  id: int.tryParse(json["id"].toString()) ?? 0,
                  label: json["label"].toString(),
                  closeTime: json["close_time"].toString(),
                  profit: double.tryParse(json["profit"].toString()) ?? 0.00))
          .toList();

      return ChannelSummary(detail: tmpDetail, listGrowth: results);
    } catch (xerr) {
      print(xerr);
    }

    return null!;
  }

  factory ChannelSummary.fromMap(Map data) {
    try {
      // _keyRequired.forEach((v) {
      //   if (data.containsKey(v)) {
      //     throw new Exception("INVALID_CHANNEL_MAP_INFO");
      //   }
      // });

      Map detail = data["detail"];

      ChannelSummaryDetail tmpDetail = ChannelSummaryDetail.createObject(
          signalCount: detail["signalCount"],
          profitCount: detail["profitCount"],
          lossCount: detail["lossCount"],
          expiredCount: detail["expiredCount"],
          averagePostPerWeek: detail["averagePostPerWeek"],
          profitTotal: detail["profitTotal"],
          lossTotal: detail["lossTotal"],
          pips: detail["pips"],
          favouriteSymbol: detail["favouriteSymbol"],
          weekAge: detail["weekAge"]);

      return ChannelSummary(detail: tmpDetail);
    } catch (xerr) {}

    return null!;
  }

  Map<String, dynamic>? toMap() {
    try {
      return {
        "detail": detail?.toMap(),
        "growth": listGrowth?.map<Map>((growth) => growth.toMap()!).toList()
      };
    } catch (xerr) {}

    return null;
  }
}

class ChannelSummaryDetail {
  int? signalSettle;
  int? signalCount;
  int? signalActive;
  int? profitCount;
  int? lossCount;
  int? expiredCount;
  int? activeCount;
  int? averagePostPerWeek;
  double? profitTotal;
  double? lossTotal;
  int? pips;
  double? avgPips;
  double? avgPipsMonthly;
  String? favouriteSymbol;
  int? weekAge;
  int? consecutiveProfitCount;
  double? consecutiveProfitSum;
  int? consecutiveLossCount;
  double? consecutiveLossSum;

  ChannelSummaryDetail._privateConstructor(
      {this.signalCount,
      this.profitCount,
      this.signalActive,
      this.signalSettle,
      this.lossCount,
      this.expiredCount,
      this.activeCount,
      this.averagePostPerWeek,
      this.profitTotal,
      this.lossTotal,
      this.pips,
      this.avgPips,
      this.avgPipsMonthly,
      this.favouriteSymbol,
      this.weekAge,
      this.consecutiveProfitCount,
      this.consecutiveProfitSum,
      this.consecutiveLossCount,
      this.consecutiveLossSum});

  factory ChannelSummaryDetail.createObject({
    signalCount = 0,
    profitCount = 0,
    signalActive = 0,
    activeCount = 0,
    signalSettle = 0,
    lossCount,
    expiredCount,
    averagePostPerWeek,
    profitTotal,
    lossTotal,
    pips,
    avgPips,
    avgPipsMonthly,
    favouriteSymbol,
    weekAge,
    consecutiveProfitCount,
    consecutiveProfitSum,
    consecutiveLossCount,
    consecutiveLossSum,
  }) {
    return ChannelSummaryDetail._privateConstructor(
      signalCount: signalCount,
      signalActive: signalActive,
      activeCount: activeCount,
      signalSettle: signalSettle,
      profitCount: profitCount,
      lossCount: lossCount,
      expiredCount: expiredCount,
      averagePostPerWeek: averagePostPerWeek,
      profitTotal: profitTotal,
      lossTotal: lossTotal,
      pips: pips,
      avgPips: avgPips,
      avgPipsMonthly: avgPipsMonthly,
      favouriteSymbol: favouriteSymbol,
      weekAge: weekAge,
      consecutiveProfitCount: consecutiveProfitCount,
      consecutiveProfitSum: consecutiveProfitSum,
      consecutiveLossCount: consecutiveLossCount,
      consecutiveLossSum: consecutiveLossSum,
    );
  }

  factory ChannelSummaryDetail.fromMap(Map? data) {
    try {
      return ChannelSummaryDetail._privateConstructor(
          signalCount: data?["signalCount"],
          profitCount: data?["profitCount"],
          signalActive: data?["signalActive"],
          signalSettle: data?["signalSettle"],
          lossCount: data?["lossCount"],
          expiredCount: data?["expiredCount"],
          averagePostPerWeek: data?["averagePostPerWeek"],
          profitTotal: data?["profitTotal"],
          lossTotal: data?["lossTotal"],
          pips: data?["pips"],
          favouriteSymbol: data?["favouriteSymbol"],
          weekAge: data?["weekAge"],
          consecutiveProfitCount: data?["consecutiveProfitCount"],
          consecutiveProfitSum: data?["consecutiveProfitSum"],
          consecutiveLossCount: data?["consecutiveLossCount"],
          consecutiveLossSum: data?["consecutiveLossSum"]);
    } catch (xerr) {}

    return null!;
  }

  factory ChannelSummaryDetail.fromMapApi2(Map data) {
    try {
      return ChannelSummaryDetail._privateConstructor(
          signalSettle: int.tryParse(data["jml_settle"].toString()) ?? 0,
          signalCount: int.tryParse(data["jml_signal"].toString()) ?? 0,
          activeCount: int.tryParse(data["jml_active"].toString()) ?? 0,
          profitCount: int.tryParse(data["jml_profit"].toString()) ?? 0,
          lossCount: int.tryParse(data["jml_loss"].toString()) ?? 0,
          expiredCount: int.tryParse(data["jml_expired"].toString()) ?? 0,
          averagePostPerWeek:
              int.tryParse(data["post_per_week"].toString()) ?? 0,
          profitTotal: double.tryParse(data["gross_profit"].toString()) ?? 0.0,
          lossTotal: double.tryParse(data["gross_loss"].toString()) ?? 0.0,
          pips: int.tryParse(data["pips"].toString()) ?? 0,
          avgPips: double.tryParse(data["avg_pips"].toString()) ?? 0.0,
          avgPipsMonthly:
              double.tryParse(data["avg_pips_monthly"].toString()) ?? 0.0,
          weekAge: int.tryParse(data["minggu"].toString()) ?? 0,
          consecutiveProfitCount:
              int.tryParse(data["consecutiveProfitCount"].toString()) ?? 0,
          consecutiveProfitSum:
              double.tryParse(data["consecutiveProfitSum"].toString()) ?? 0.0,
          consecutiveLossCount:
              int.tryParse(data["consecutiveLossCount"].toString()) ?? 0,
          consecutiveLossSum:
              double.tryParse(data["consecutiveLossSum"].toString()) ?? 0.0);
    } catch (x) {
      print(x);
    }

    return null!;
  }
  Map<String, dynamic>? toMap() {
    return {
      "signalCount": signalCount,
      "signalActive": signalActive,
      "signalSettle": signalSettle,
      "profitCount": profitCount,
      "lossCount": lossCount,
      "expiredCount": expiredCount,
      "averagePostPerWeek": averagePostPerWeek,
      "profitTotal": profitTotal,
      "lossTotal": lossTotal,
      "pips": pips,
      "favouriteSymbol": favouriteSymbol,
      "weekAge": weekAge,
      "consecutiveProfitCount": consecutiveProfitCount,
      "consecutiveProfitSum": consecutiveProfitSum,
      "consecutiveLossCount": consecutiveLossCount,
      "consecutiveLossSum": consecutiveLossSum,
    };
  }
}

class ChannelSummaryGrowth {
  int? id;
  String? label;
  String? closeTime;
  String? createdAt;
  double? profit;
  ChannelSummaryGrowth._privateConstructor(
      {this.id, this.label, this.closeTime, this.profit, this.createdAt});

  factory ChannelSummaryGrowth.createObject(
      {id = 0, label, closeTime, profit, createdAt}) {
    return ChannelSummaryGrowth._privateConstructor(
        id: id,
        label: label,
        closeTime: closeTime,
        profit: profit,
        createdAt: createdAt);
  }

  factory ChannelSummaryGrowth.fromMap(Map? data) {
    try {
      return ChannelSummaryGrowth._privateConstructor(
          id: data?["id"],
          label: data?["label"],
          closeTime: data?["closeTime"],
          profit: data?["profit"]);
    } catch (xerr) {}

    return null!;
  }

  factory ChannelSummaryGrowth.fromMapApiv2(Map data) {
    try {
      return ChannelSummaryGrowth._privateConstructor(
          id: int.tryParse(data["id"].toString()) ?? 0,
          label: data["label"] ?? "",
          closeTime: data["close_time"] ?? "",
          createdAt: data["CREATED_AT"] ?? "",
          profit: double.tryParse(data["pips"].toString()) ?? 0.0);
    } catch (e) {
      print(e);
    }

    return null!;
  }

  Map<String, dynamic>? toMap() {
    return {"id": id, "label": label, "closeTime": closeTime, "profit": profit};
  }
}

class ChannelStat {
  List<ChannelSymbolStat>? listSymbolStat;
  ChannelStat._privateConstructor({this.listSymbolStat});

  factory ChannelStat.fromTF2v1API(Map input) {
    try {
      List<ChannelSymbolStat> tmp = [];
      input.forEach((k, v) {
        tmp.add(ChannelSymbolStat.createObject(
          symbol: k.toString(),
          signalCount: int.tryParse(v["count"].toString()) ?? 0,
          buyCount: int.tryParse(v["buy"].toString()) ?? 0,
          sellCount: int.tryParse(v["sell"].toString()) ?? 0,
          profitSum: double.tryParse(v["profit"].toString()) ?? 0.0,
          lossSum: double.tryParse(v["loss"].toString()) ?? 0.0,
        ));
      });

      return ChannelStat._privateConstructor(listSymbolStat: tmp);
    } catch (xerr) {
      print(xerr);
    }

    return null!;
  }
}

class ChannelSymbolStat {
  String? symbol;
  int? signalCount;
  int? buyCount;
  int? sellCount;
  double? profitSum;
  double? lossSum;

  ChannelSymbolStat._privateConstructor(
      {this.symbol,
      this.signalCount,
      this.buyCount,
      this.sellCount,
      this.profitSum,
      this.lossSum});

  factory ChannelSymbolStat.createObject(
      {symbol = '',
      signalCount = 0,
      buyCount = 0,
      sellCount = 0,
      profitSum = 0.00,
      lossSum = 0.00}) {
    return ChannelSymbolStat._privateConstructor(
        symbol: symbol ?? '',
        signalCount: signalCount,
        buyCount: buyCount,
        sellCount: sellCount,
        profitSum: profitSum,
        lossSum: lossSum);
  }
}

class SignalInfo {
  ChannelInfo? channel;
  int? id;
  String? symbol;
  int? op;
  double? price;
  double? sl;
  double? tp;
  int? active;
  double? profit;
  int? pips;
  double? closePrice;
  String? closeTime;
  String? openTime;
  int? expired;
  String? createdAt;

  // static List<String> _keyRequired = [
  //   "channel",
  //   "id",
  //   "symbol",
  //   "op",
  //   "price",
  //   "sl",
  //   "tp",
  //   "active",
  //   "profit",
  //   "pips",
  //   "closePrice",
  //   "closeTime",
  //   "expired",
  //   "createdAt"
  // ];

  factory SignalInfo.createObject({
    int? id,
    String? symbol,
    int? op,
    double? price,
    double? sl,
    double? tp,
    int? active,
    double? profit,
    int? pips,
    double? closePrice,
    String? closeTime,
    String? openTime,
    int? expired,
    int? notified,
    int? channelId,
    String? title,
    double? channelPrice,
    String? username,
    int? userid,
    String? createdAt,
    int? subs,
    String? caption,
    int? channelStatus,
    int? channelCreatedTimeStamp,
    String? channelAvatar,
    int? medals,
    double? point,
  }) {
    ChannelInfo? oc = ChannelInfo.createObject(
        id: channelId,
        caption: caption,
        userid: userid,
        createdTimeStamp: channelCreatedTimeStamp,
        price: channelPrice,
        status: channelStatus,
        title: title,
        username: username,
        avatar: channelAvatar,
        medals: medals,
        point: point,
        subscriber: subs);
    return SignalInfo._privateConstructor(
        id: id,
        channel: oc,
        symbol: symbol,
        op: op,
        price: price,
        sl: sl,
        tp: tp,
        active: active,
        profit: profit,
        pips: pips,
        closePrice: closePrice,
        closeTime: closeTime,
        openTime: openTime,
        expired: expired,
        createdAt: createdAt);
  }

  factory SignalInfo.fromMap(Map data) {
    try {
      // _keyRequired.forEach((v) {
      //   if (data.containsKey(v)) {
      //     throw new Exception("INVALID_SIGNAL_MAP_INFO");
      //   }
      // });
      ChannelInfo? channel = ChannelInfo.fromMap(data["channel"]);
      if (channel == null) {
        throw Exception("INVALID_CHANNEL_MAP_INFO");
      }

      return SignalInfo?._privateConstructor(
          id: data["id"],
          channel: channel,
          symbol: data["symbol"],
          op: data["op"],
          price: data["price"],
          sl: data["sl"],
          tp: data["tp"],
          active: data["active"],
          profit: data["profit"],
          pips: data["pips"],
          closePrice: data["closePrice"],
          closeTime: data["closeTime"],
          openTime: data["openTime"],
          expired: data["expired"],
          createdAt: data["createdAt"]);
    } catch (xerr) {}

    return null!;
  }

  Map<String, dynamic>? toMap() {
    return {
      "channel": channel?.toMap(),
      "id": id,
      "symbol": symbol ?? '',
      "op": op,
      "price": price,
      "sl": sl,
      "tp": tp,
      "active": active,
      "profit": profit,
      "pips": pips,
      "closePrice": closePrice,
      "closeTime": closeTime,
      "openTime": openTime,
      "expired": expired,
      "createdAt": createdAt
    };
  }

  SignalInfo._privateConstructor(
      {this.id,
      this.channel,
      this.symbol,
      this.op,
      this.price,
      this.sl,
      this.tp,
      this.active,
      this.profit,
      this.pips,
      this.closePrice,
      this.closeTime,
      this.openTime,
      this.expired,
      this.createdAt});

  // static List<String> getKeyRequired() {
  //   return _keyRequired;
  // }
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['imageText'] = imageText;
  //   data['name'] = name;
  //   data['companyName'] = companyName;
  //   data['rank'] = rank;
  //   data['percentage'] = percentage;
  //   return data;
  // }
}

class SignalTradeCopyLog {
  SignalInfo? signal;
  List<SignalTradeCopyLogSlim>? listTrade;

  SignalTradeCopyLog({this.signal, this.listTrade});
}

class SignalTradeCopyLogSlim {
  int? channelID;
  String? channelName;
  int? signalID;
  int? mt4ID;
  String? broker;
  String? symbol;
  double? volume;
  int? orderID;
  String? createdAt;

  SignalTradeCopyLogSlim._privateConstructor({
    this.channelID,
    this.channelName,
    this.signalID,
    this.mt4ID,
    this.broker,
    this.symbol,
    this.volume,
    this.orderID,
    this.createdAt,
  });

  // static List<String> _keyRequired = [
  //   "channelID",
  //   "channelName",
  //   "signalID",
  //   "mt4ID",
  //   "broker",
  //   "symbol",
  //   "volume",
  //   "orderID",
  //   "createdAt"
  // ];

  factory SignalTradeCopyLogSlim.fromMap(Map data) {
    try {
      // _keyRequired.forEach((v) {
      //   if (data.containsKey(v)) {
      //     throw new Exception("INVALID_SIGNAL_BADGE_MAP_INFO");
      //   }
      // });

      return SignalTradeCopyLogSlim._privateConstructor(
        channelID: int.tryParse(data["channelID"].toString()) ?? 0,
        channelName: data["channelName"].toString(),
        signalID: int.tryParse(data["signalID"].toString()) ?? 0,
        mt4ID: int.tryParse(data["mt4ID"].toString()) ?? 0,
        broker: data["broker"].toString(),
        symbol: data["symbol"].toString(),
        volume: double.tryParse(data["volume"].toString()) ?? 0,
        orderID: int.tryParse(data["orderID"].toString()) ?? 0,
        createdAt: data["createdAt"].toString(),
      );
    } catch (xerr) {}

    return null!;
  }

  factory SignalTradeCopyLogSlim.fromTF2v1API(Map data) {
    try {
      return SignalTradeCopyLogSlim._privateConstructor(
        channelID: int.tryParse(data["id"].toString()) ?? 0,
        channelName: data["title"].toString(),
        signalID: int.tryParse(data["signal_id"].toString()) ?? 0,
        mt4ID: int.tryParse(data["mt4id"].toString()) ?? 0,
        broker: data["broker"].toString(),
        symbol: data["symbol"].toString(),
        volume: double.tryParse(data["volume"].toString()) ?? 0,
        orderID: int.tryParse(data["ticket_id"].toString()) ?? 0,
        createdAt: data["CREATED_AT"].toString(),
      );
    } catch (xerr) {}

    return null!;
  }

  Map<String, dynamic> toMap() {
    return {
      "channelID": channelID,
      "channelName": channelName,
      "signalID": signalID,
      "mt4ID": mt4ID,
      "broker": broker,
      "symbol": symbol,
      "volume": volume,
      "orderID": orderID,
      "createdAt": createdAt,
    };
  }
}

class SignalCardSlim {
  int? channelId;
  String? channelName;
  int? channelSubscriber;
  String? channelAvatar;
  int? signalid;
  String? symbol;
  String? createdAt;
  int? expired;
  int? subs;
  int? medals;
  int? op;
  factory SignalCardSlim.fromMap(Map data) {
    try {
      return SignalCardSlim._privateConstructor(
          channelId: data["channelId"],
          channelSubscriber: data["channelSubscriber"],
          channelName: data["channelName"],
          channelAvatar: data["channelAvatar"],
          signalid: data["signalid"],
          symbol: data["symbol"],
          createdAt: data["createdAt"],
          expired: data["expired"],
          subs: data["subs"],
          medals: int.tryParse(data["medals"].toString()) ?? 0,
          op: data["op"]);
    } catch (xerr) {
      print(xerr.toString());
    }

    return null!;
  }

  Map<String, dynamic> toMap() {
    return {
      "channelId": channelId,
      "channelName": channelName,
      "channelSubscriber": channelSubscriber,
      "channelAvatar": channelAvatar,
      "signalid": signalid,
      "symbol": symbol,
      "createdAt": createdAt,
      "expired": expired,
      "subs": subs,
      "medals": medals,
      "op": op
    };
  }

  SignalCardSlim._privateConstructor(
      {this.channelId,
      this.channelName,
      this.channelSubscriber,
      this.channelAvatar,
      this.signalid,
      this.symbol,
      this.createdAt,
      this.expired,
      this.subs,
      this.medals,
      this.op});
}

class ChannelCardSlim {
  int? id;
  String? name;
  String? username;
  int? subscriber;
  double? postPerWeek;
  double? profit;
  double? pips;
  String? avatar;
  double? price;
  int? signals;
  bool? subscribed;
  DateTime? subsDate;
  DateTime? subsExpired;
  int? weekAge;
  bool? mute;
  bool? real;
  String? account;
  bool? isPrivate;
  List<ChannelPricing>? pricing;
  String? contactEmail;
  int? medals;
  double? point;
  DateTime? createdTime;
  factory ChannelCardSlim.fromMap(Map data) {
    try {
      double diffWeek = (double.tryParse(data["diff_week"].toString()) ?? 1.00);
      if (diffWeek < 1.00) diffWeek = 1.00;

      List<dynamic> pricingTemp = data["pricing"] ?? [];
      List<ChannelPricing> pricing =
          pricingTemp.map((map) => ChannelPricing.fromMap(map)).toList();
      return ChannelCardSlim(
          id: data["id"],
          name: data["title"] ?? data["name"],
          username: data["username"] == null || data["username"] == "null"
              ? "-"
              : data["username"],
          subscriber: data["subs"] ?? 0,
          avatar: data["avatar"],
          price: double.tryParse(data["price"].toString()) ?? 0.00,
          pips: double.tryParse(data["pips"].toString()) ?? 0.00,
          profit: double.tryParse(data["total_profit"].toString()) ?? 0.00,
          postPerWeek: data["signals"] != null
              ? (double.tryParse(data["signals"].toString()) ?? 0.00) / diffWeek
              : 0,
          signals: int.tryParse(data["signals"].toString()) ?? 0,
          subscribed: data["subscribed"] is bool
              ? data["subscribed"]
              : data["subscribed"] == 1
                  ? true
                  : false,
          subsDate: data['subsDate'] == "null" || data['subsDate'] == null
              ? null
              : DateTime.parse(data['subsDate'].replaceAll('Z', '') + 'Z'),
          subsExpired: data['subsExpired'] == "null" ||
                  data['subsExpired'] == null
              ? null
              : DateTime.parse(data['subsExpired'].replaceAll('Z', '') + 'Z'),
          weekAge: int.tryParse(data["diff_week"].toString()) ?? 0,
          mute: data["mute"] == 0 ? false : true,
          real: data["real"] == 1 ? true : false,
          account: data["account"]?.toString() ?? "",
          isPrivate: data["isPrivate"] == 1 ? true : false,
          pricing: pricing,
          contactEmail: data["contactEmail"],
          medals: int.tryParse(data["medals"].toString()) ?? 0,
          createdTime: int.tryParse(data["created_time"].toString()) != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  int.tryParse(data["created_time"].toString())! * 1000,
                  isUtc: true)
              : DateTime.parse(data["created_time"]),
          point: double.tryParse(data["point"].toString()) ?? 0.0);
    } catch (xerr) {
      print(xerr);
    }

    return ChannelCardSlim.dummy();
  }

  factory ChannelCardSlim.dummy() {
    return ChannelCardSlim(
        id: 0,
        name: "Channel Name",
        username: "Channel Provider",
        subscriber: 0,
        avatar: null,
        price: 0.00,
        pips: 0.00,
        profit: 0.00,
        postPerWeek: 0,
        signals: 0,
        subscribed: false,
        subsDate: null,
        subsExpired: null,
        weekAge: 0,
        mute: false,
        real: false,
        account: "",
        isPrivate: false,
        contactEmail: "",
        medals: 0,
        point: 0,
        createdTime: null);
  }

  Future<Rx<String?>?> watchChannelCache(int userid) async {
    try {
      SharedBoxHelper? box = SharedHelper.instance.getBox(BoxName.cache);
      return box?.watch(sprintf(CacheKey.channelByIDforUserID, [id, userid]));
    } catch (xerr) {}
    return null;
  }

  Future<void> saveToUserCacheAsync(int userid) async {
    SharedBoxHelper? box = SharedHelper.instance.getBox(BoxName.cache);
    // save this ChannelCardSlim object to box... jadi kita bisa stream nantinya...
    box?.putMap(sprintf(CacheKey.channelByIDforUserID, [id, userid]), toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "username": username,
      "price": price,
      "subs": subscriber,
      "postPerWeek": postPerWeek,
      "total_profit": profit,
      "pips": pips,
      "avatar": avatar,
      "signals": signals,
      "subscribed": subscribed == null
          ? null
          : subscribed!
              ? 1
              : 0,
      "subsDate": subsDate.toString(),
      "subsExpired": subsExpired.toString(),
      "diff_week": weekAge,
      "mute": mute == null
          ? null
          : mute!
              ? 1
              : 0,
      "real": real == null
          ? null
          : real!
              ? 1
              : 0,
      "account": account,
      "isPrivate": isPrivate,
      "pricing": pricing?.map((p) => p.toMap()).toList(),
      "contactEmail": contactEmail,
      "medals": medals,
      "point": point,
      "created_time": createdTime.toString(),
    };
  }

  ChannelCardSlim(
      {this.id,
      this.name,
      this.username,
      this.price,
      this.subscriber,
      this.postPerWeek,
      this.profit,
      this.pips,
      this.avatar,
      this.signals,
      this.subscribed,
      this.subsDate,
      this.subsExpired,
      this.weekAge,
      this.mute,
      this.real,
      this.account,
      this.isPrivate,
      this.pricing,
      this.contactEmail,
      this.medals,
      this.point,
      this.createdTime});
}

class ChannelPricing {
  int? qty;
  double? price;

  ChannelPricing({this.qty, this.price});

  factory ChannelPricing.fromMap(Map map) {
    return ChannelPricing(
        qty: map["qty"],
        price: double.tryParse(map["price"].toString()) ?? 0.0);
  }

  toMap() {
    return {"qty": qty, "price": price};
  }
}

class SignalPageData {
  List<SignalCardSlim>? listSignal;
  List<ChannelCardSlim>? listChannel;
  SignalPageData({this.listSignal, this.listChannel});
  SignalPageData remake(
      {List<SignalCardSlim>? mListSignal,
      List<ChannelCardSlim>? mlistChannel}) {
    List<SignalCardSlim>? tmpSignal = mListSignal ?? listSignal;
    List<ChannelCardSlim>? tmpChannel = mlistChannel ?? listChannel;
    return SignalPageData(listSignal: tmpSignal, listChannel: tmpChannel);
  }

  Map toMap() {
    Map data = {"signal": [], "channel": []};
    listSignal?.forEach((v) {
      data["signal"].add(v.toMap());
    });
    listSignal?.forEach((v) {
      data["channel"].add(v.toMap());
    });
    return data;
  }

  factory SignalPageData.fromMap(Map data) {
    return SignalPageData(
        listSignal: listSignalCardSlimFromListMap(data["signal"]),
        listChannel: listChannelCardSlimFromListMap(data["channel"]));
  }
}

class HomePageData {
  List<SignalInfo>? listSignal;
  List<ChannelMostProfitEntity>? listChannel;
  List<ChannelCardSlim>? listPopularChannel;

  HomePageData({this.listSignal, this.listChannel, this.listPopularChannel});
}

class TransactionPaymentSlim {
  String? reff;
  TransactionType? type;
  TransactionStatus? status;
  double? jumlah;
  String? username;
  double? comm;
  double? adminFee;
  DateTime? tgl;
  String? description;

  TransactionPaymentSlim(
      {@required this.reff,
      @required this.type,
      @required this.status,
      @required this.jumlah,
      @required this.username,
      @required this.tgl,
      this.comm,
      this.adminFee,
      this.description});

  Map toMap() {
    return {
      "reff": reff,
      "type": type?.index,
      "status": status?.index,
      "jumlah": jumlah,
      "username": username,
      "comm": comm,
      "admin_fee": adminFee,
      "tgl": tgl.toString(),
      "description": description
    };
  }

  factory TransactionPaymentSlim.fromMap(Map data) {
    if (!data.containsKey("reff") ||
        !data.containsKey("jumlah") ||
        !data.containsKey("type") ||
        !data.containsKey("status") ||
        !data.containsKey("username") ||
        !data.containsKey("comm") ||
        !data.containsKey("admin_fee") ||
        !data.containsKey("tgl")) {
      return null!;
    }

    TransactionType type = data["code"] < TransactionType.values.length
        ? TransactionType.values[data["code"]]
        : TransactionType.values[data["type"]];

    return TransactionPaymentSlim(
        reff: data["reff"].toString(),
        type: type,
        status: TransactionStatus.values[data["status"]],
        jumlah: double.tryParse(data["jumlah"].toString()) ?? 0,
        comm: double.tryParse(data["comm"].toString()) ?? 0.0,
        adminFee: double.tryParse(data["admin_fee"].toString()) ?? 0.0,
        tgl: DateTime.tryParse(data["tgl"].toString()),
        username: data["username"].toString(),
        description: data["description"].toString());
  }
}

class OisDashboardPageData {
  double? lastSync;
  int? totalChannel;
  int? totalSignal;
  int? totalSubscriber;
  int? totalPayment;
  double? totalBalance;
  double? totalActiveBalance;
  List<TransactionPaymentSlim>? transactionPayment;
  String? bankName;
  String? bankAccount;
  String? bankUsername;

  OisDashboardPageData(
      {this.lastSync,
      this.totalChannel,
      this.totalSignal,
      this.totalSubscriber,
      this.totalPayment,
      this.totalBalance,
      this.totalActiveBalance,
      this.transactionPayment,
      this.bankName,
      this.bankAccount,
      this.bankUsername});

  Map toMap() {
    List<Map> data = [];
    transactionPayment?.forEach((v) {
      data.add(v.toMap());
    });

    return {
      "lastSync": lastSync,
      "totalChannel": totalChannel,
      "totalSignal": totalSignal,
      "totalSubscriber": totalSubscriber,
      "totalPayment": totalPayment,
      "totalBalance": totalBalance,
      "totalActiveBalance": totalActiveBalance,
      "transactionPayment": data,
      "bankName": bankName,
      "bankAccount": bankAccount,
      "bankUsername": bankUsername
    };
  }

  factory OisDashboardPageData.fromMap(Map data) {
    if (!data.containsKey("lastSync") ||
        !data.containsKey("totalChannel") ||
        !data.containsKey("totalSignal") ||
        !data.containsKey("totalSubscriber") ||
        !data.containsKey("totalPayment") ||
        !data.containsKey("totalBalance") ||
        !data.containsKey("transactionPayment") ||
        !data.containsKey("bankName") ||
        !data.containsKey("bankAccount") ||
        !data.containsKey("bankUsername")) {
      return null!;
    }

    if (data["transactionPayment"] is List) {
      return null!;
    }

    List<TransactionPaymentSlim> listPayment = [];
    data["transactionPayment"].forEach((v) {
      listPayment.add(TransactionPaymentSlim.fromMap(v));
    });

    return OisDashboardPageData(
      lastSync: data["lastSync"],
      totalChannel: data["totalChannel"],
      totalSignal: data["totalSignal"],
      totalSubscriber: data["totalSubscriber"],
      totalPayment: data["totalPayment"],
      totalBalance: double.tryParse(data["totalBalance"].toString()) ?? 0.0,
      totalActiveBalance:
          double.tryParse(data["totalActiveBalance"].toString()) ?? 0.0,
      transactionPayment: listPayment,
      bankName: data["bankName"],
      bankAccount: data["bankAccount"],
      bankUsername: data["bankUsername"],
    );
  }
}

class OisMyChannelPageData {
  double? lastSync;
  List<ChannelCardSlim>? listMyChannel;
  Map? listChannelBalance;

  OisMyChannelPageData(
      {@required this.lastSync,
      @required this.listMyChannel,
      @required this.listChannelBalance});

  Map toMap() {
    List<Map> data = [];
    listMyChannel?.forEach((v) {
      data.add(v.toMap());
    });

    return {
      "lastSync": lastSync,
      "listMyChannel": data,
      "listChannelBalance": listChannelBalance
    };
  }

  factory OisMyChannelPageData.init() {
    return OisMyChannelPageData(
        lastSync: 0.0, listChannelBalance: {}, listMyChannel: []);
  }

  factory OisMyChannelPageData.fromMap(Map data) {
    if (!data.containsKey("lastSync") ||
        !data.containsKey("listMyChannel") ||
        !data.containsKey("listChannelBalance")) {
      return OisMyChannelPageData.init();
    }

    if (data["listMyChannel"] is List ||
        data["listChannelBalance"] is Map ||
        data["listChannelBalance"].length == 0) {
      return OisMyChannelPageData.init();
    }

    return OisMyChannelPageData(
        lastSync: data["lastSync"],
        listMyChannel: listChannelCardSlimFromListMap(data["listMyChannel"]),
        listChannelBalance: data["listChannelBalance"]);
  }
}

class PaymentActions {
  final List<PaymentChannels>? paymentChannels;
  final List<PaymentDurationInMonths>? paymentDurations;

  PaymentActions({this.paymentChannels, this.paymentDurations});
}

class PaymentChannels {
  final int? id;
  final String? name;

  PaymentChannels({this.id, this.name});

  factory PaymentChannels.fromMap(Map map) {
    return PaymentChannels(id: map["id"], name: map["name"]);
  }
}

class PaymentDurationInMonths {
  final String? name;
  final int? value;

  PaymentDurationInMonths({this.name, this.value});

  factory PaymentDurationInMonths.fromMap(Map map) {
    return PaymentDurationInMonths(name: map["name"], value: map["value"]);
  }
}

class PaymentDetails {
  final int? billNo;
  final int? qty;
  final double? price;
  final double? billTotal;
  final DateTime? billDate;
  final DateTime? billExpired;
  final String? paymentMethod;
  final String? trxId;
  final String? channelName;
  final int? status;
  final DateTime? paymentDate;

  PaymentDetails(
      {this.qty,
      this.price,
      this.billTotal,
      this.billExpired,
      this.paymentMethod,
      this.trxId,
      this.channelName,
      this.status,
      this.billNo,
      this.billDate,
      this.paymentDate});

  factory PaymentDetails.fromMap(Map map) {
    return PaymentDetails(
        qty: map["qty"],
        price: double.parse(map["price"].toString()),
        billTotal: double.parse(map["billTotal"].toString()),
        billExpired: DateTime.parse(map["billExpired"] + "Z"),
        paymentMethod: map["paymentMethod"],
        trxId: map["trxId"],
        channelName: map["channelName"],
        status: map["status"],
        billNo: map["billNo"],
        billDate: DateTime.parse(map["billDate"] + "Z"),
        paymentDate: (map["paymentDate"] != null
            ? DateTime.parse(map["paymentDate"] + "Z")
            : null));
  }
}

class ChannelSubscriber {
  final int? channelId;
  final String? title;
  final int? userId;
  final String? username;
  final DateTime? subsDate;
  final DateTime? subsExpired;

  ChannelSubscriber(
      {this.channelId,
      this.title,
      this.userId,
      this.username,
      this.subsDate,
      this.subsExpired});

  factory ChannelSubscriber.fromMap(Map map) => ChannelSubscriber(
      channelId: map["channelId"],
      title: map["title"],
      userId: map["userId"],
      username: map["username"],
      subsDate: DateTime.parse(map["subsDate"].replaceAll("Z", "") + "Z"),
      subsExpired: DateTime.parse(map["subsDate"].replaceAll("Z", "") + "Z"));

  Map toMap() => {
        "channelId": channelId,
        "title": title,
        "userId": userId,
        "username": username,
        "subsDate": subsDate.toString(),
        "subsExpired": subsExpired.toString()
      };
}

class ChannelMostProfitEntity {
  final int? id;
  final String? title;
  final String? username;
  final double? profit;
  final int? pips;
  final int? monthd;
  final String? avatar;

  const ChannelMostProfitEntity(
      {this.id,
      this.title,
      this.username,
      this.profit,
      this.pips,
      this.monthd,
      this.avatar});

  factory ChannelMostProfitEntity.fromMap(Map map) => ChannelMostProfitEntity(
      id: int.parse(map["id"].toString()),
      title: map["title"],
      username: map["username"],
      profit: double.parse(map["profit"].toString()),
      pips: int.parse(map["pips"].toString()),
      monthd: int.parse(map["monthd"].toString()),
      avatar: map["avatar"]);

  Map toMap() => {
        "id": id,
        "title": title,
        "username": username,
        "profit": profit,
        "pips": pips,
        "monthd": monthd,
        "avatar": avatar
      };
}

class HistoryPoint {
  HistoryPoint({
    this.id,
    this.channelId,
    this.utcInsertAt,
    this.settleSignals,
    this.totalSignalsCreated,
    this.totalSignalsClosed,
    this.totalPips,
    this.avgPips,
    this.avgPipsMonthly,
    this.point,
    this.medal,
    this.prevPoint,
    this.prevMedal,
    this.prevChannelMedal,
    this.sendMail,
  });

  int? id;
  int? channelId;
  DateTime? utcInsertAt;
  int? settleSignals;
  int? totalSignalsCreated;
  int? totalSignalsClosed;
  int? totalPips;
  double? avgPips;
  double? avgPipsMonthly;
  double? point;
  int? medal;
  double? prevPoint;
  int? prevMedal;
  int? prevChannelMedal;
  int? sendMail;

  factory HistoryPoint.fromMap(Map<String, dynamic> json) => HistoryPoint(
        id: json["id"],
        channelId: json["channel_id"],
        utcInsertAt: DateTime.parse(json["utc_insert_at"]),
        settleSignals: json["settle_signals"],
        totalSignalsCreated: json["total_signals_created"],
        totalSignalsClosed: json["total_signals_closed"],
        totalPips: json["total_pips"],
        avgPips: double.tryParse(json["avg_pips"].toString()) ?? 0.0,
        avgPipsMonthly:
            double.tryParse(json["avg_pips_monthly"].toString()) ?? 0.0,
        point: double.tryParse(json["point"].toString()) ?? 0.0,
        medal: json["medal"],
        prevPoint: double.tryParse(json["prev_point"].toString()) ?? 0.0,
        prevMedal: json["prev_medal"],
        prevChannelMedal: json["prev_channel_medal"],
        sendMail: json["send_mail"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "channel_id": channelId,
        "utc_insert_at": utcInsertAt,
        "settle_signals": settleSignals,
        "total_signals_created": totalSignalsCreated,
        "total_signals_closed": totalSignalsClosed,
        "total_pips": totalPips,
        "avg_pips": avgPips,
        "avg_pips_monthly": avgPipsMonthly,
        "point": point,
        "medal": medal,
        "prev_point": prevPoint,
        "prev_medal": prevMedal,
        "prev_channel_medal": prevChannelMedal,
        "send_mail": sendMail,
      };
}

class RedeemHistory {
  RedeemHistory({
    this.id,
    this.channelId,
    this.status,
    this.utcInsertAt,
    this.code,
    this.point,
    this.medal,
  });

  int? id;
  int? channelId;
  DateTime? utcInsertAt;
  double? point;
  int? medal;
  RedeemStatus? status;
  String? code;

  factory RedeemHistory.fromMap(Map<String, dynamic> json) => RedeemHistory(
        id: json["id"],
        channelId: json["channel_id"],
        utcInsertAt:
            DateTime.parse(json["utc_insert_at"]).add(const Duration(hours: 7)),
        point: double.tryParse(json["point"].toString()) ?? 0.0,
        medal: json["medal"],
        status: RedeemStatus.values[json["status"]],
        code: json["code"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "channel_id": channelId,
        "utc_insert_at": utcInsertAt,
        "point": point,
        "medal": medal,
        "code": code,
        "status": status,
      };
}

class Level {
  Level._privateConstructor();
  static final Level instance = Level._privateConstructor();
  Level({
    this.level,
    this.exchangePointMultiplier,
    this.minDate,
    this.maxDate,
    this.urlRule,
  });

  List<LevelElement>? level;
  int? exchangePointMultiplier;
  int? minDate;
  int? maxDate;
  String? urlRule;

  factory Level.fromMap(Map<String, dynamic> json) => Level(
        level: List<LevelElement>.from(
            json["level"].map((x) => LevelElement.fromJson(x))),
        exchangePointMultiplier: json["exchange_point_multiplier"],
        minDate: int.parse(json["minDate"].toString()),
        maxDate: int.parse(json["maxDate"].toString()),
        urlRule: json["url_rule"],
      );

  Map<String, dynamic> toMap() => {
        "level": List<dynamic>.from(level!.map((x) => x.toJson())),
        "exchange_point_multiplier": exchangePointMultiplier,
        "minDate": minDate,
        "maxDate": maxDate,
        "url_rule": urlRule,
      };
}

class LevelElement {
  LevelElement({
    this.name,
    this.minMedal,
    this.maxMedal,
    this.money,
  });

  String? name;
  int? minMedal;
  int? maxMedal;
  int? money;

  factory LevelElement.fromJson(Map<String, dynamic> json) => LevelElement(
        name: json["name"],
        minMedal: json["minMedal"],
        maxMedal: json["maxMedal"],
        money: json["money"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "minMedal": minMedal,
        "maxMedal": maxMedal,
        "money": money,
      };
}

class RulesPoint {
  RulesPoint._privateConstructor();
  static final RulesPoint instance = RulesPoint._privateConstructor();

  int? currentMonthPips;
  int? currentMonthPipsMin;
  int? lastMonthPips;
  double? average;
  int? count;

  factory RulesPoint.fromMap(Map json) {
    try {
      return RulesPoint(
          currentMonthPips: int.tryParse(json["current_month_pips"]) ?? 0,
          currentMonthPipsMin: json["current_month_pips_min"],
          lastMonthPips: json["last_month_pips"],
          average: double.tryParse(json["total_settle"]["avg"]) ?? 0.0,
          count: json["total_settle"]["count"]);
    } catch (xerr) {
      print(xerr);
    }
    return RulesPoint();
  }

  Map toMap() {
    return {
      "current_month_pips": currentMonthPips,
      "current_month_pips_min": currentMonthPipsMin,
      "last_month_pips": lastMonthPips,
      "total_settle": {"avg": average, "count": count}
    };
  }

  RulesPoint(
      {this.currentMonthPips,
      this.currentMonthPipsMin,
      this.lastMonthPips,
      this.average,
      this.count});
}
