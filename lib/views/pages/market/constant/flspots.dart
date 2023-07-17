import 'dart:convert';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';

class ChartData {
  static final Map<String, List<FlSpot>> data = {
    '1D': [
      const FlSpot(0, 3),
      const FlSpot(2.6, 3),
      const FlSpot(4.9, 5.3),
      const FlSpot(6.8, 6.1),
      const FlSpot(8, 6),
      const FlSpot(9.5, 5.6),
      const FlSpot(11, 3.4),
      const FlSpot(11.5, 4),
      const FlSpot(13.2, 2),
      const FlSpot(15.8, 3.5),
      const FlSpot(17, 4.2),
    ],
    '1W': [
      const FlSpot(0, 3.5),
      const FlSpot(2, 4),
      const FlSpot(4, 3.5),
      const FlSpot(6, 4.5),
      const FlSpot(8, 5),
      const FlSpot(10, 4),
      const FlSpot(12, 4.5),
      const FlSpot(14, 4),
      const FlSpot(16, 4.5),
      const FlSpot(18, 4),
    ],
    '1M': [
      const FlSpot(0, 4),
      const FlSpot(3, 4.5),
      const FlSpot(6, 3.5),
      const FlSpot(9, 4),
      const FlSpot(12, 4.5),
      const FlSpot(15, 5),
      const FlSpot(18, 4),
      const FlSpot(21, 4.5),
      const FlSpot(24, 4),
      const FlSpot(27, 4.5),
    ],
    '3M': [
      const FlSpot(0, 4),
      const FlSpot(6, 4.5),
      const FlSpot(12, 3.5),
      const FlSpot(18, 4),
      const FlSpot(24, 4.5),
      const FlSpot(30, 5),
      const FlSpot(36, 4),
      const FlSpot(42, 4.5),
      const FlSpot(48, 4),
      const FlSpot(54, 4.5),
      const FlSpot(60, 5.0),
      const FlSpot(63, 6.2),
      const FlSpot(67, 5.4)
    ],
    '1Y': [
      const FlSpot(0, 4.5),
      const FlSpot(10, 4),
      const FlSpot(20, 4.5),
      const FlSpot(30, 4),
      const FlSpot(40, 4.5),
      const FlSpot(50, 5),
      const FlSpot(60, 4),
      const FlSpot(70, 4.5),
      const FlSpot(80, 4),
      const FlSpot(90, 4.5),
    ],
    '5Y': [
      const FlSpot(0, 4),
      const FlSpot(20, 4.5),
      const FlSpot(40, 3.5),
      const FlSpot(60, 4),
      const FlSpot(80, 4.5),
      const FlSpot(100, 5),
      const FlSpot(120, 4),
      const FlSpot(140, 4.5),
      const FlSpot(160, 4),
      const FlSpot(180, 4.5),
    ],
    'All': [
      const FlSpot(0, 3),
      const FlSpot(10, 3),
      const FlSpot(20, 5.3),
      const FlSpot(30, 6.1),
      const FlSpot(40, 6),
      const FlSpot(50, 5.6),
      const FlSpot(60, 3.4),
      const FlSpot(70, 4),
      const FlSpot(80, 2),
      const FlSpot(90, 3.5),
      const FlSpot(100, 4.2),
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