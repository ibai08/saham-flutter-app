// ignore_for_file: prefer_is_empty, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controller/statisticsController.dart';
import '../../../../models/entities/ois.dart';
import '../../../../views/widgets/info.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../../../views/widgets/labelChart.dart';

class StatisticsChannel extends StatelessWidget {
  final StatisticsChannelController controller =
      Get.put(StatisticsChannelController());
  final int channel;
  StatisticsChannel(this.channel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var unitHeight = 75.0;

    double symbolFreqHeight;
    double plHeight;

    return Container(
      padding: const EdgeInsets.only(top: 15),
      color: Colors.grey[200],
      child: Obx(() {
        if (controller.statChannelObs == null &&
            !controller.hasError.value == true) {
          return const Center(
            child: Text(
              "Tunggu ya..!!",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          );
        }
        if (controller.statChannelObs?.value?.listSymbolStat?.length == 0 &&
            !controller.hasError.value) {
          return const Center(
            child: Text(
              "Maaf.. data tidak ditemukan",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          );
        }
        if (controller.hasError.value) {
          return ListView(
            children: <Widget>[
              Info(
                onTap: controller.onLoading,
                image: const SizedBox(),
              )
            ],
          );
        }
        symbolFreqHeight = unitHeight /
                2 *
                controller.statChannelObs!.value!.listSymbolStat!.length +
            45;
        plHeight = unitHeight /
                2 *
                controller.statChannelObs!.value!.listSymbolStat!.length
                    .toDouble() +
            45;
        controller.statChannelObs?.value?.listSymbolStat?.sort((b, a) =>
            (a.sellCount! + a.buyCount!).compareTo(b.sellCount! + b.buyCount!));
        return ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.only(top: 25, bottom: 10),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Symbol Frequency',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    width: double.infinity,
                    height: symbolFreqHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SymbolFrequence(controller.statChannelObs!.value!),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.only(bottom: 10, top: 25),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Profit / Loss (IDR)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                    child:
                        ProfitLossFrequence(controller.statChannelObs!.value!),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}

class SymbolFrequence extends StatelessWidget {
  final ChannelStat channelStat;
  const SymbolFrequence(this.channelStat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<SymbolData, String>> generateData() {
      List<SymbolData> data = channelStat.listSymbolStat!
          .map<SymbolData>(
              (json) => SymbolData(json.symbol!, json.signalCount!))
          .toList();
      return [
        charts.Series<SymbolData, String>(
            id: 'Symbols',
            domainFn: (SymbolData symbols, _) => symbols.symbols,
            measureFn: (SymbolData symbols, _) => symbols.frequence,
            seriesColor: charts.Color.fromHex(code: "#00B451"),
            data: data,
            labelAccessorFn: (SymbolData symbols, _) =>
                '${symbols.symbols}: ${symbols.frequence.toString()} Deals')
      ];
    }

    return charts.BarChart(
      generateData(),
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      primaryMeasureAxis:
          const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
      domainAxis: const charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
    );
  }
}

class ProfitLossFrequence extends StatelessWidget {
  final ChannelStat channelStat;
  const ProfitLossFrequence(this.channelStat);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<SymbolProfitLoss, String>> generateData() {
      List<SymbolProfitLoss> profit = channelStat.listSymbolStat!
          .map<SymbolProfitLoss>((json) => SymbolProfitLoss(
              json.symbol!, (json.profitSum! + json.lossSum!) * 10000))
          .toList();
      return [
        charts.Series<SymbolProfitLoss, String>(
            id: 'Profit/Loss',
            domainFn: (SymbolProfitLoss symbols, _) => symbols.symbols,
            measureFn: (SymbolProfitLoss symbols, _) => symbols.frequence,
            data: profit,
            colorFn: (SymbolProfitLoss symbols, _) => charts.Color.fromHex(
                code: symbols.frequence > 0 ? "#2962ff" : "#e52e29"),
            labelAccessorFn: (SymbolProfitLoss symbols, _) =>
                '${symbols.symbols}: ${NumberFormat("#,###.##", "ID").format(symbols.frequence)}')
      ];
    }

    return charts.BarChart(
      generateData(),
      animate: true,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      primaryMeasureAxis:
          const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
      domainAxis: const charts.OrdinalAxisSpec(
          renderSpec: charts.NoneRenderSpec(), showAxisLine: false),
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
