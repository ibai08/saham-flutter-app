import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/models/entities/ois.dart';

class ChartGrowth extends StatelessWidget {
  final List<ChannelSummaryGrowth> listGrowth;
  String time;
  ChartGrowth(this.listGrowth, this.time);

  @override
  Widget build(BuildContext context) {
    bool isAfter = false;
    String tfPointDate = remoteConfig.getString("tf_point_start_date");
    DateTime tfPointDt = DateFormat("yyyy-MM-dd HH:mm:ss").parse(tfPointDate, true).toLocal();
    DateTime? dateEnd;
    List<Map> listGrowthTmp = [];
    double growthTmp1 = 0;
    double growthTmp2 = 0;
    DateTime now = DateTime.now();

    listGrowth.forEach((v) {
      double pipsTmp = (v.profit! / 10) * 10000;
      DateTime dt = DateFormat("yyyy-MM-dd HH:mm:ss").parse(v.createdAt!, true).toLocal();
      growthTmp1 += pipsTmp;
      if (tfPointDt.isBefore(dt)) {
        isAfter = true;
        growthTmp2 += pipsTmp;
      } else {
        growthTmp2 = growthTmp2;
      }

      listGrowthTmp.add({
        "id": v.id,
        "closeTime": v.closeTime,
        "createdAt": v.createdAt,
        "profitDataByTimeTmp": growthTmp1,
        "profitDataByTimeAfterTmp": growthTmp2
      });
    });

    List<Map> listGrowthDatas = [];
    if (time == "1W") {
      dateEnd = DateTime.now().subtract(Duration(days: 7));
    } else if (time == "1M") {
      dateEnd = DateTime(now.year, now.month - 1, now.day);
    } else if (time == "3M") {
      dateEnd = DateTime(now.year, now.month - 3, now.day);
    } else if (time == "1Y") {
      dateEnd = DateTime(now.year - 1, now.month, now.day);
    } else if (time == "3Y") {
      dateEnd = DateTime(now.year - 3, now.month, now.day);
    } else {
      dateEnd = null;
    }

    listGrowthTmp.forEach((value) {
      DateTime ct = DateFormat("yyyy-MM-dd HH:mm:ss").parse(value['closeTime'], true).toLocal();
      if (dateEnd != null) {
        if (now.isAfter(ct) && dateEnd.isBefore(ct) && dateEnd != null) {
          listGrowthDatas.add({
            "closeTime": value['closeTime'],
            "createdAt": value['createdAt'],
            "pipsBefore": value['profitDataByTimeTmp'],
            "pipsAfter": value['profitDataByTimeAfterTmp']
          });
        }
      } else {
        listGrowthDatas.add({
          "closeTime": value['closeTime'],
          "createdAt": value['createdAt'],
          "pipsBefore": value['profitDataByTimeTmp'],
          "pipsAfter": value['profitDataByTimeAfterTmp'],
        });
      }
    });

    LineChartData? generateData() {
      if (listGrowthDatas.length < 2) {
        return null;
      }
      List<FlSpot> data = [];
      List<FlSpot> data2 = [];

      double i = 0;
      listGrowthDatas.forEach((v) {
        data.add(FlSpot(i, v['pipsBefore']));
        data2.add(FlSpot(i, v['pipsAfter']));
        i++;
      });

      return LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          enabled: true,
          touchSpotThreshold: 10,
          getTouchedSpotIndicator: (x, i) {
            return i.map((e) => TouchedSpotIndicatorData(
              FlLine(color: Colors.grey[400], strokeWidth: 1),
              FlDotData(
                show: true,
                getDotPainter: (d, s, j, l) {
                  return FlDotCirclePainter(
                    color: j.color,
                    strokeWidth: 0,
                    radius: 6
                  );
                }
              )
            )).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            tooltipBgColor: Colors.black.withOpacity(0.6),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            maxContentWidth: 1000,
            getTooltipItems: (touchedSpots) {
              int i = 0;
              return touchedSpots.map((touchedSpot) {
                i++;
                var formatter = DateFormat('dd MMM yyyy hh:mm');
                String formatted = formatter.format(DateTime.parse(listGrowthDatas[touchedSpot.x.toInt()]['closeTime']));
                return LineTooltipItem(
                  i == 1 ? formatted + '\n\n' : '',
                  const TextStyle(
                    fontWeight: FontWeight.normal,
                    height: 0.9,
                    color: Colors.white
                  ),
                  textAlign: TextAlign.left,
                  children: [
                    TextSpan(
                      text: '• ',
                      style: TextStyle(
                        color: touchedSpot.bar.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      )
                    ),
                    TextSpan(
                      text: '${touchedSpot.bar.color == const Color(0xff5fd0df) ? 'Profit Official Version' : 'Profit Beta Version'}: ${NumberFormat("#,###.0", "en-US").format(touchedSpot.y)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      )
                    )
                  ]
                );
              }).toList();
            }
          )
        ),
        gridData: FlGridData(
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Color.fromARGB(255, 203, 203, 203),
              strokeWidth: 0.5
            );
          },
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false)
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false)
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false)
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false)
          )
        ),
        borderData: FlBorderData(
          show: false
        ),
        lineBarsData: [
          if (isAfter) 
            LineChartBarData(
              isCurved: false,
              color: AppColors.blue2,
              barWidth: 1,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              spots: data2
            )
        ]
      );
    }

    return generateData() ==  null ? const Center(
      child: Text(
        "Data signal terlalu sedikit",
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
    ) : LineChart(generateData()!);
  }
}