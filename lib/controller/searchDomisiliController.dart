import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/views/pages/search/searchDomisili.dart';

import '../models/domisili.dart';
import '../models/user.dart';

class SearchDomisiliController extends GetxController {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  
  final searchController = TextEditingController();

  RxBool hasError = false.obs;
  RxBool hasLoad = false.obs;

  RxString errorMessage = ''.obs;

  RxList<GroupedCity> listGcs = RxList<GroupedCity>();

  void onRefresh() async {
    // request data + delete cache data
    // refresh selesai
    await getDomisili(clearCache: true);
    refreshController.refreshCompleted();
  }

  RxMap listcon = Map().obs;

  Map dataSource = {};

  void search(String txt) {
    print("text isi: $txt");
    if (txt.length > 0 && txt.length < 3) {
      hasError.value = true;
      errorMessage.value = "Masukkan 3 atau lebih huruf";
      // listcon.addError("Masukkan 3 atau lebih huruf");
      print("kena error text");
      return;
    } else if (txt.length == 0) {
      print('kena else if txt');
      listcon.addAll(dataSource);
      return;
    }
    Map tempFoundCity = {};
    dataSource.forEach((k, v) {
      List listCity = [];
      if (k.toString().toLowerCase().contains(txt.toLowerCase())) {
        tempFoundCity['$k'] = v;
      } else {
        for (var item in v) {
          String city = item["name"];
          if (city.toLowerCase().contains(txt.toLowerCase())) {
            listCity.add(item);
          }
        }
        if (listCity.length > 0) {
          tempFoundCity['$k'] = listCity;
        }
      }
    
    });
    print("udah proses datasource");
    hasError.value = false;
    hasLoad.value = true;
    print("tempfoundcit: $tempFoundCity");
    listcon.value = tempFoundCity;
  }

  Future<Map> getDomisili({clearCache = false}) async {
    try {
      print("sebelum dp");
      var dp = await Domisili.getDomisili(clearCache: clearCache);
      print("sesudah dp");
      print("dp: $dp");
      if (!dp.containsKey("error")) {
        dataSource = dp;
        listcon.addAll(dataSource);
      } else {
        await UserModel.instance.refreshLogin();
      }
      print("prosesss sesudah dp");
      hasLoad.value = true;
    } catch (xerr) {
      print("hasError: $xerr");
      hasError.value = true;
      errorMessage.value = "error getting domisili: $xerr";
      // print("error getting domisili: $xerr");
    }

    return {};
  }

  void onInit() {
    super.onInit();
    print("sebelum get domisili");
    getDomisili();
    print("sesudah get domisili");
  } 
}