import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../core/http.dart';

fetchData(contex, url) async {
  List list;
  final response = await DefaultAssetBundle.of(contex).loadString(url);
  var data = jsonDecode(response);
  var rest = data["data"];
  list = rest as List;
  return list;
}

fetchDataDio(context, url) async {
  Response res;
  List list;
  Dio dio = Dio(); // with default Options
  dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
  dio.options.receiveTimeout = const Duration(milliseconds: 30000);
  res = await dio.get(getMainSite() + url);
  list = res.data as List;
  return list;
}
