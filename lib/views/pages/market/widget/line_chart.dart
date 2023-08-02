// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/models/flspots.dart';
import 'dart:convert';

class ChartSaham extends StatefulWidget {
  const ChartSaham({Key? key}) :super(key: key);

  @override
  State<ChartSaham> createState() => _ChartSahamState();
}

class _ChartSahamState extends State<ChartSaham> {
  List<Color> gradientColors = [
    const Color.fromRGBO(255, 56, 68, 1.0),
    Colors.white70,
  ];

  List<FlSpot> _spots = [];
  Future<void> _loadSpots() async {
    String jsonString = await rootBundle.loadString('assets/dummy/flspots.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    FlSpotsModels? spotsModels = FlSpotsModels.fromJson(jsonData);
    List<Data>? data = spotsModels.data ?? [];

    // List<dynamic> items = jsonData['data'];
    List<FlSpot> spots = data.map((item) {
      final dateFormatter = DateFormat('yyyy-MM-dd HH:mm');
      final date = dateFormatter.parse(item.x!);
      final seconds = date.millisecondsSinceEpoch / 1000.0;
      double x = seconds.toDouble();
      double y = double.tryParse(item.y!) ?? 0.0;
      return FlSpot(x, y);
    }).toList();
    setState(() {
      _spots = spots;
    });
  }
  

  List<FlSpot> chartData = [];

  bool showAvg = false;
  double? minX;
  double? maxX;

  void updateMaxX() {
    double minChartX = double.infinity;
    double maxChartX = 0;
    chartData.forEach((spot) {
      if (spot.x < minChartX) {
        minChartX = spot.x;
      }
      if (spot.x > maxChartX) {
        maxChartX = spot.x;
      }
     });
     minX = minChartX;
     maxX = maxChartX;
  }

  String activeButton = '1D';

  @override
  void initState() {
    super.initState();
    _loadSpots().then((_) {
      setState(() {
        DateTime today = DateTime.now();
        DateTime startOfDay = DateTime(today.year, today.month, today.day);
        DateTime endOfDay = startOfDay.add(const Duration(days: 1));
        chartData = _spots.where((spot) {
          DateTime spotDate = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt() * 1000);
          return spotDate.isAfter(startOfDay) && spotDate.isBefore(endOfDay);
        }).toList();
      });
    } );
    print("ini spots: $_spots");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.7,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 14,
              left: 7,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
        // Container(
        //   child: flSpotsData[0],
        // ),
        // _spots != null ? Text('Berhasil') : Text('Gak Berhasil'), 
        const SizedBox(height: 16.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButtons('1D', activeButton, setActiveButton),
            CustomButtons('1W', activeButton, setActiveButton),
            CustomButtons('1M', activeButton, setActiveButton),
            CustomButtons('3M', activeButton, setActiveButton),
            CustomButtons('1Y', activeButton, setActiveButton),
            CustomButtons('5Y', activeButton, setActiveButton),
            CustomButtons('All', activeButton, setActiveButton),
          ],
        )
      ],
    );
  }



  void setActiveButton(String button) {
    setState(() {
      activeButton = button;
      // Ganti data chart sesuai dengan button yang dipilih
      switch (button) {
        case '1D':
          DateTime today = DateTime.now();
          DateTime startOfDay = DateTime(today.year, today.month, today.day);
          DateTime endOfDay = startOfDay.add(const Duration(days: 1));
          chartData = _spots.where((spot) {
            DateTime spotDate = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt() * 1000);
            return spotDate.isAfter(startOfDay) && spotDate.isBefore(endOfDay);
          }).toList();
          break;
        case '1W':
          DateTime today = DateTime.now();
          DateTime oneWeekAgo = today.subtract(const Duration(days: 7));
          DateTime startOfDay = DateTime(today.year, today.month, today.day);
          chartData = _spots.where((spot) {
            DateTime spotDate = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt() * 1000);
            return spotDate.isAfter(oneWeekAgo) && spotDate.isBefore(startOfDay);
          }).toList();
          break;
        case '1M':
          DateTime today = DateTime.now();
          DateTime oneMonthAgo = today.subtract(const Duration(days: 30));
          DateTime startOfDay = DateTime(today.year, today.month, today.day);
          chartData = _spots.where((spot) {
            DateTime spotDate = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt() * 1000);
            return spotDate.isAfter(oneMonthAgo) && spotDate.isBefore(startOfDay);
          }).toList();
          break;
        case '3M':
          DateTime today = DateTime.now();
          DateTime threeWeekAgo = today.subtract(const Duration(days: 91));
          DateTime startOfDay = DateTime(today.year, today.month, today.day);
          chartData = _spots.where((spot) {
            DateTime spotDate = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt() * 1000);
            return spotDate.isAfter(threeWeekAgo) && spotDate.isBefore(startOfDay);
          }).toList();
          break;
        case '1Y':
          DateTime today = DateTime.now();
          DateTime oneYearAgo = today.subtract(const Duration(days: 365));
          DateTime startOfDay = DateTime(today.year, today.month, today.day);
          chartData = _spots.where((spot) {
            DateTime spotDate = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt() * 1000);
            return spotDate.isAfter(oneYearAgo) && spotDate.isBefore(startOfDay);
          }).toList();
          break;
        case '5Y':
          DateTime today = DateTime.now();
          DateTime fiveYearAgo = today.subtract(const Duration(days: 1825));
          DateTime startOfDay = DateTime(today.year, today.month, today.day);
          chartData = _spots.where((spot) {
            DateTime spotDate = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt() * 1000);
            return spotDate.isAfter(fiveYearAgo) && spotDate.isBefore(startOfDay);
          }).toList();
          break;
        case 'All':
          chartData = _spots;
          break;
        default:
          DateTime today = DateTime.now();
          DateTime startOfDay = DateTime(today.year, today.month, today.day);
          DateTime endOfDay = startOfDay.add(const Duration(days: 1));
          chartData = _spots.where((spot) {
            DateTime spotDate = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt() * 1000);
            return spotDate.isAfter(startOfDay) && spotDate.isBefore(endOfDay);
          }).toList();
      }
    });
  }

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '6,670';
        break;
      case 2:
        text = '6,680';
        break;
      case 3:
        text = '6,700';
        break;
      case 4:
        text = '6,710';
        break;
      case 5:
        text = '6,720';
        break;
      case 6:
        text = '6,730';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }
  

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        horizontalInterval: 3,
        getDrawingHorizontalLine: (value) {
          if (value == 3) {
          return FlLine(
            color: Colors.black,
            strokeWidth: 1,
            dashArray: [5, 10], // Mengatur pola putus-putus pada garis horizontal
          );
        } else {
          return FlLine(
            color: Colors.transparent, // Mengatur garis horizontal lainnya menjadi transparan
          );
        }
        },
      ),
      lineTouchData: LineTouchData(
        getTouchLineEnd: (barData, spotIndex) => 6.730,
        touchTooltipData: LineTouchTooltipData(
          tooltipMargin: -5,
          showOnTopOfTheChartBoxArea: true,
          tooltipBgColor: Colors.blueGrey.withOpacity(0),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final x = DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt() * 1000);
              final formattedX = DateFormat('yyyy-MM-dd').format(x);
              return LineTooltipItem(
                formattedX,
                const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          }
        ),
        getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
          return indicators.map((int index) {
            final line = FlLine(
              color: Colors.red,
              strokeWidth: 1,
            ); 
            return TouchedSpotIndicatorData(
              line,
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  const radius = 5.0; 
                  const color = Colors.red; 
                  const strokeWidth = 0.0; 

                  return FlDotCirclePainter(
                    radius: radius,
                    color: color,
                    strokeWidth: strokeWidth,
                    strokeColor: color,
                  );
                },
              )
            );
          }).toList();
        }
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: rightTitleWidgets,
            reservedSize: 50,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false)
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: minX,
      maxX: maxX,
      minY: 0,
      maxY: 6.730,
      lineBarsData: [
        LineChartBarData(
          spots: chartData,
          isCurved: false,
          color: const Color.fromRGBO(255, 56, 68, 1.0),
          barWidth: 1,
          dotData: FlDotData(show: false),
          isStrokeCapRound: false,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors
                  .map((color) => color.withOpacity(0.5))
                  .toList(),
                  transform: const GradientRotation(180 * (pi / 90))
            ),
          ),
        ),
      ],
    );
  }
}

class CustomButtons extends StatelessWidget {
  final String buttonText;
  final String activeButton;
  final Function setActiveButton;

  const CustomButtons(this.buttonText, this.activeButton, this.setActiveButton, {Key? key}) : super(key: key);

  bool get isActive => buttonText == activeButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setActiveButton(buttonText);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color.fromRGBO(53, 6, 153, 1.0) : null,
          borderRadius: BorderRadius.circular(8),
          border: isActive ? Border.all(color: const Color.fromRGBO(53, 6, 153, 1.0)) : null
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

