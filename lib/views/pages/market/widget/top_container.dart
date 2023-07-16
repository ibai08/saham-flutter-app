import 'package:flutter/material.dart';
import 'package:tradersfamily_app/pages/market/widget/line_chart.dart';

class MarketCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'IHSG',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Image.asset('assets/market-close.png'),
                  ],
                ),
              ),
              Text(
                '6,687.00',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Indeks Harga Saham Gabungan',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              Text(
                '-17.23 (-0.26%)',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFFFF4438),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          ChartSaham(),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}