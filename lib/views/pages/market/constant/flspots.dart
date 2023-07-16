import 'dart:convert';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';

class ChartData {
  static final Map<String, List<FlSpot>> data = {
    '1D': [
      FlSpot(0, 3),
      FlSpot(2.6, 3),
      FlSpot(4.9, 5.3),
      FlSpot(6.8, 6.1),
      FlSpot(8, 6),
      FlSpot(9.5, 5.6),
      FlSpot(11, 3.4),
      FlSpot(11.5, 4),
      FlSpot(13.2, 2),
      FlSpot(15.8, 3.5),
      FlSpot(17, 4.2),
    ],
    '1W': [
      FlSpot(0, 3.5),
      FlSpot(2, 4),
      FlSpot(4, 3.5),
      FlSpot(6, 4.5),
      FlSpot(8, 5),
      FlSpot(10, 4),
      FlSpot(12, 4.5),
      FlSpot(14, 4),
      FlSpot(16, 4.5),
      FlSpot(18, 4),
    ],
    '1M': [
      FlSpot(0, 4),
      FlSpot(3, 4.5),
      FlSpot(6, 3.5),
      FlSpot(9, 4),
      FlSpot(12, 4.5),
      FlSpot(15, 5),
      FlSpot(18, 4),
      FlSpot(21, 4.5),
      FlSpot(24, 4),
      FlSpot(27, 4.5),
    ],
    '3M': [
      FlSpot(0, 4),
      FlSpot(6, 4.5),
      FlSpot(12, 3.5),
      FlSpot(18, 4),
      FlSpot(24, 4.5),
      FlSpot(30, 5),
      FlSpot(36, 4),
      FlSpot(42, 4.5),
      FlSpot(48, 4),
      FlSpot(54, 4.5),
      FlSpot(60, 5.0),
      FlSpot(63, 6.2),
      FlSpot(67, 5.4)
    ],
    '1Y': [
      FlSpot(0, 4.5),
      FlSpot(10, 4),
      FlSpot(20, 4.5),
      FlSpot(30, 4),
      FlSpot(40, 4.5),
      FlSpot(50, 5),
      FlSpot(60, 4),
      FlSpot(70, 4.5),
      FlSpot(80, 4),
      FlSpot(90, 4.5),
    ],
    '5Y': [
      FlSpot(0, 4),
      FlSpot(20, 4.5),
      FlSpot(40, 3.5),
      FlSpot(60, 4),
      FlSpot(80, 4.5),
      FlSpot(100, 5),
      FlSpot(120, 4),
      FlSpot(140, 4.5),
      FlSpot(160, 4),
      FlSpot(180, 4.5),
    ],
    'All': [
      FlSpot(0, 3),
      FlSpot(10, 3),
      FlSpot(20, 5.3),
      FlSpot(30, 6.1),
      FlSpot(40, 6),
      FlSpot(50, 5.6),
      FlSpot(60, 3.4),
      FlSpot(70, 4),
      FlSpot(80, 2),
      FlSpot(90, 3.5),
      FlSpot(100, 4.2),
    ]
    // tambahkan data lainnya
  };

  static void saveDataToJson(String fileName) {
    final jsonData = json.encode(data);

    // Menyimpan data ke file
    final file = File(fileName);
    file.writeAsString(jsonData);
  }
}