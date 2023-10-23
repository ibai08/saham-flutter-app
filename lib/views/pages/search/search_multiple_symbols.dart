// ignore_for_file: prefer_is_empty, unnecessary_null_comparison, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/models/entities/symbols.dart';
import 'package:saham_01_app/models/signal.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/btn_block.dart';
import 'package:saham_01_app/views/widgets/info.dart';

enum SearchMultipleSymbolsOptions { single, multiple}

class SearchMultipleSymbols extends StatelessWidget {
  final dynamic current;
  final SearchMultipleSymbolsOptions? options;
  SearchMultipleSymbols({Key? key, this.current, this.options}) : super(key: key);

  final SearchMultipleSymbolsController controller = Get.put(SearchMultipleSymbolsController());

  @override
  Widget build(BuildContext context) {
    controller.current = current;
    controller.options = options;

    if (current != '') {
      controller.curr.value = current.toString().split(", ");
    }
    return Scaffold(
      appBar: NavTxt(title: "Pilih Instrument"),
      bottomNavigationBar: options != SearchMultipleSymbolsOptions.single ? Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 5
            )
          ]
        ),
        child: BtnBlock(
          title: "Pilih",
          onTap: () {
            Get.back(result: controller.symbols);
          },
        ),
      ) : const SizedBox(
        height: 1,
      ),
      body: Obx(() {
        if (controller.listcon == [] && !controller.hasError.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.hasError.value) {
          return Info(onTap: controller.getSymbols);
        }
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(left: 5, right: 5),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Cari Instrument",

                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      fillColor: Colors.grey[200]!,
                      contentPadding: const EdgeInsets.all(0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0),
                        borderRadius:BorderRadius.circular(10)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 0)
                      )
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (_) {
                      controller.search(_);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: Colors.grey,
                  height: 1,
                ),
                options != SearchMultipleSymbolsOptions.single ? CheckboxListTile(
                  title: controller.txtTitle,
                  value: controller.all.value,
                  onChanged: (bool? value) {
                    controller.all.value = value!;
                    if (controller.temp.length > 0) {
                      if (value == true) {
                        controller.symbols.value = [];
                        controller.symbols.value = controller.tempSymbols;
                      } else {
                        controller.symbols.value = [];
                      }
                      for (var i = 0; i < controller.temp.length; i++) {
                        controller.temp[i] = value;
                      }
                    }
                  },
                ) : Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: controller.txtTitle,
                ),
                const Divider(
                  color: Colors.grey,
                  height: 1,
                ),
                SizedBox(
                  height: options != SearchMultipleSymbolsOptions.single ? MediaQuery.of(context).size.height - 280 : MediaQuery.of(context).size.height - 215,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      Column(
                        children: controller.listcon,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class SearchMultipleSymbolsController extends GetxController {
  RxList<ListSymbols> listSymbols = <ListSymbols>[].obs;
  RxList<ListSymbols> filteredListSymbols = <ListSymbols>[].obs;
  RxList<ListSymbols> listcon = <ListSymbols>[].obs;
  RxList<bool> temp = <bool>[].obs;
  RxList<String> symbols = <String>[].obs;
  RxList<String> tempSymbols = <String>[].obs;
  RxList<String> curr = <String>[].obs;
  RxBool all = false.obs;
  RxBool hasError = false.obs;
  Widget txtTitle = const Text(
    "Pilih Istrument ",
    style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18
    ),
  );
  dynamic current;
  SearchMultipleSymbolsOptions? options;

  Future<void> getSymbols() async {
    try {
      listSymbols.value = [];
      List<TradeSymbol> dp = await SignalModel.instance.getSymbols() as List<TradeSymbol>;
      for (int i = 0; i < dp.length; i++) {
        var cek = false;
        if (temp.length != dp.length) {
          tempSymbols.add(dp[i].name!);
          if (current != '') {
            for (var i = 0; i < curr.length; i++) {
              if (dp[i].name == curr[i]) {
                cek = true;
              }
            }
            if (cek) {
              temp.add(true);
              symbols.add(dp[i].name!);
            } else {
              temp.add(false);
            }
          } else {
            temp.add(false);
          }
        }
        listSymbols.add(
          ListSymbols(
            title: dp[i].name,
            value: temp[i],
            options: options,
            digit: dp[i].digit,
          )
        );
      }
      // listcon.addAll(listSymbols);
      listcon.value = listSymbols;
    } catch (e) {
      hasError.value = true;
    }
  }

  void search(String txt) {
    filteredListSymbols.value = [];
    for (int i = 0; i < listSymbols.length; i++) {
      if (!listSymbols[i].title.toString().toLowerCase().contains(txt.toLowerCase()) && (txt != null || txt != "")) {
        continue;
      }
      filteredListSymbols.add(listSymbols[i]);
    }
    // listcon.addAll(filteredListSymbols);
    listcon.value = filteredListSymbols;
  }
  
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 0)).then((_) async {
      try {
        await getSymbols();
      } catch (_) {
      }
    });
  }
}

class ListSymbols extends StatelessWidget {
  ListSymbols({Key? key, this.title, this.digit, this.options, this.value}) : super(key: key);

  final String? title;
  final SearchMultipleSymbolsOptions? options;
  final int? digit;
  bool? value;
  void onChange(bool newVal) {
    value = newVal;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        options != SearchMultipleSymbolsOptions.single ? Obx(() {
            return CheckboxListTile(
              title: Text(title!),
              value: value,
              onChanged: (newVal) {
                onChange(newVal!);
              },
            );
          }
        ) : GestureDetector(
          onTap: () {
            Get.back(
              result: TradeSymbol(name: title, digit: digit),
              canPop: true
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Text(
              title!,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
          height: 1,
        )
      ]
    );
  }
}