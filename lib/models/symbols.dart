import 'dart:convert';

import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/models/entities/symbols.dart';

class SymbolModel {
  SymbolModel._privateConstructor();
  static final SymbolModel instance = SymbolModel._privateConstructor();

  List<TradeSymbol> getSymbols() {
    List symbolList = jsonDecode(remoteConfig.getString("ois_symbols"));

    List<TradeSymbol> symbols =
        symbolList.map((map) => TradeSymbol.fromTF2v1API(map)).toList();

    return symbols;
  }
}