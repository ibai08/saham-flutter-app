import 'package:flutter/material.dart';
import '../../../../views/pages/market/widget/line_chart.dart';

class MarketCard extends StatelessWidget {
  const MarketCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
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
                    const Text(
                      'IHSG',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Image.asset('assets/market-close.png'),
                  ],
                ),
              ),
              const Text(
                '6,687.00',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: const [
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
          const SizedBox(height: 10.0),
          const ChartSaham(),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

