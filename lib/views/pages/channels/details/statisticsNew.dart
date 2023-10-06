// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/controller/statisticNewController.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/views/pages/channels/details/statistics.dart';
import 'package:saham_01_app/views/widgets/info.dart';
import 'package:saham_01_app/views/widgets/labelChart.dart';

class StatisticsChannel extends StatelessWidget {
  StatisticsChannel({Key? key}) : super(key: key);

  final StatisticsController controller = Get.find();
  
  @override
  Widget build(BuildContext context) {
    double unitHeight = 75.0;
    double symbolFreqHeight;
    double plHeight;

    return Container(
      padding: const EdgeInsets.only(top: 15),
      color: Colors.grey[200],
      child: Obx(() {
        if (controller.statStreamCtrl.value == null && controller.hasError.value == false && controller.hasLoad.value == false) {
          return const Center(
            child: Text(
              "Tunggu ya..!!",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          );
        }
        if (controller.statStreamCtrl.value?.listSymbolStat?.length == 0 && controller.hasError.value == false && controller.hasLoad.value == true) {
          return const Center(
            child: Text(
              "Maaf.. data tidak ditemukan",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          );
        }
        if (controller.hasError.value == true && controller.hasLoad.value == false) {
          return Center(
            child: Info(
              image: const SizedBox(),
              title: "Terjadi Error",
              desc: controller.errorMessage.value,
              onTap: controller.onLoading,
            ),
          );
        }

        symbolFreqHeight = unitHeight / 2 * controller.statStreamCtrl.value!.listSymbolStat!.length + 45;
        plHeight = unitHeight / 2 * controller.statStreamCtrl.value!.listSymbolStat!.length.toDouble();
        controller.statStreamCtrl.value!.listSymbolStat!.sort((b, a) => (a.sellCount! + a.buyCount!).compareTo(b.sellCount! + b.buyCount!));
        return ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.only(top: 25, bottom: 10),
              child: Column(
                children: <Widget>[
                  const Text(
                    "Symbol Frequency",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    width: double.infinity,
                    height: symbolFreqHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SymbolsFrequence(channelStat: controller.statStreamCtrl.value!),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.only(top: 25, bottom: 10),
              child: Column(
                children: <Widget>[
                  const Text(
                    "Profit / Loss (IDR)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const LabelCharts(
                    text1: "Profit",
                    text2: "Loss",
                  ),
                  Container(
                    width: double.infinity,
                    height: plHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ProfitLossFrequence(channelStat: controller.statStreamCtrl.value!),
                  )
                ],
              ),
            )
          ],
        );
      })
    );
  }
}

class SymbolsFrequence extends StatelessWidget {
  final ChannelStat channelStat;
  const SymbolsFrequence({Key? key, required this.channelStat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<SymbolData, String>> generateData() {
      List<SymbolData> data = channelStat.listSymbolStat!.map((json) => SymbolData(json.symbol!, json.signalCount!)).toList();

      return [
        charts.Series<SymbolData, String>(
          id: 'Symbol',
          domainFn: (SymbolData symbols, _) => symbols.symbols,
          measureFn: (SymbolData symbols, _) => symbols.frequence,
          seriesColor: charts.Color.fromHex(code: "#00B451"),
          data: data,
          labelAccessorFn: (SymbolData symbols, _) => '${symbols.symbols}: ${symbols.frequence.toString()} Deals'
        )
      ];
    }

    return charts.BarChart(
      generateData(),
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      primaryMeasureAxis: const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
      domainAxis: const charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
    );
  }
}

class ProfitLossFrequence extends StatelessWidget {
  final ChannelStat channelStat;
  const ProfitLossFrequence({Key? key, required this.channelStat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<SymbolProfitLoss, String>> generateDate() {
      List<SymbolProfitLoss> profit = channelStat.listSymbolStat!.map((json) => SymbolProfitLoss(json.symbol!, (json.profitSum! + json.lossSum!) * 10000)).toList();

      return [
        charts.Series<SymbolProfitLoss, String>(
          id: 'Profit/Loss',
          domainFn: (SymbolProfitLoss symbols, _) => symbols.symbols,
          measureFn: (SymbolProfitLoss symbols, _) => symbols.frequence,
          data: profit,
          colorFn: (SymbolProfitLoss symbols, _) => charts.Color.fromHex(
            code: symbols.frequence > 0 ? "#2962ff" : "#e52e29"
          ),
          labelAccessorFn: (SymbolProfitLoss symbols, _) => '${symbols.symbols}: ${NumberFormat("#,###.##", "ID").format(symbols.frequence)}'
        )
      ];
    }

    return charts.BarChart(
      generateDate(),
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      primaryMeasureAxis: const  charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
      domainAxis: const  charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec(), showAxisLine: false)
    );
  }
}

class SymbolData {
  final String symbols;
  final int frequence;

  SymbolData(this.symbols, this.frequence);
}

class SymbolProfitLoss {
  final String symbols;
  final double frequence;

  SymbolProfitLoss(this.symbols, this.frequence);
}