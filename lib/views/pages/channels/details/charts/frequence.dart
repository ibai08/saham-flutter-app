import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// class SignalFrequence extends StatefulWidget {
//   final ChannelSummaryDetail summary;
//   SignalFrequence(this.summary);
//   @override
//   _SignalFrequenceState createState() => _SignalFrequenceState();
// }

class SignalFrequence extends StatelessWidget {
  final Rx<ChannelSummaryDetail?> summary;
  SignalFrequence(this.summary);
  @override
  Widget build(BuildContext context) {
    List<charts.Series<OrdinalSummary, String>> _generateData() {
      final signalPosted = [
        OrdinalSummary('summary', summary.value?.signalSettle),
      ];

      final profitCount = [
        OrdinalSummary('summary', summary.value?.profitCount),
      ];

      final lossCount = [
        OrdinalSummary('summary', summary.value?.lossCount),
      ];

      final expiredCount = [
        OrdinalSummary('summary', summary.value?.expiredCount),
      ];

      final activeCount = [
        OrdinalSummary('summary', summary.value?.activeCount),
      ];

      return [
        charts.Series<OrdinalSummary, String>(
            id: 'Signal Posted',
            domainFn: (OrdinalSummary sales, _) => sales.label!,
            measureFn: (OrdinalSummary sales, _) => sales.sales,
            data: signalPosted,
            seriesColor: charts.Color.fromHex(code: "#2962ff")),
        charts.Series<OrdinalSummary, String>(
            id: 'Profit',
            domainFn: (OrdinalSummary sales, _) => sales.label!,
            measureFn: (OrdinalSummary sales, _) => sales.sales,
            data: profitCount,
            seriesColor: charts.Color.fromHex(code: "#00af9a")),
        charts.Series<OrdinalSummary, String>(
            id: 'Loss',
            domainFn: (OrdinalSummary sales, _) => sales.label!,
            measureFn: (OrdinalSummary sales, _) => sales.sales,
            data: lossCount,
            seriesColor: charts.Color.fromHex(code: "#ff4438")),
        charts.Series<OrdinalSummary, String>(
            id: 'Active Signal',
            domainFn: (OrdinalSummary sales, _) => sales.label!,
            measureFn: (OrdinalSummary sales, _) => sales.sales,
            data: activeCount,
            seriesColor: charts.Color.fromHex(code: "#ff9e18")),
        charts.Series<OrdinalSummary, String>(
            id: 'Expired',
            domainFn: (OrdinalSummary sales, _) => sales.label!,
            measureFn: (OrdinalSummary sales, _) => sales.sales,
            data: expiredCount,
            seriesColor: charts.Color.fromHex(code: "#707880")),
      ];
    }

    return charts.BarChart(
      _generateData(),
      animate: false,
      barGroupingType: charts.BarGroupingType.grouped,
      domainAxis:
          charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
      behaviors: [
        charts.SeriesLegend(
          position: charts.BehaviorPosition.end,
          horizontalFirst: false,
          cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
          showMeasures: true,
        ),
      ],
    );
  }
}

/// Sample ordinal data type.
class OrdinalSummary {
  final String? label;
  final int? sales;

  OrdinalSummary(this.label, this.sales);
}