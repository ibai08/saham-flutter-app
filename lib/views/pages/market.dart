import 'package:flutter/material.dart';
import 'package:tradersfamily_app/appbar/navmain.dart';
import 'package:tradersfamily_app/pages/market/widget/emiten_slider.dart' as EmitenSlider;
import 'package:tradersfamily_app/pages/market/widget/index_saham.dart';
// import 'package:tradersfamily_app/pages/market/widget/slider.dart';
import 'package:tradersfamily_app/pages/market/widget/grid_sektor_saham.dart';
import 'package:tradersfamily_app/pages/market/widget/stock_info.dart';
import 'package:tradersfamily_app/pages/market/widget/top_container.dart';
import 'package:tradersfamily_app/store/operation.dart';
import 'package:tradersfamily_app/store/reducer.dart';
import 'package:tradersfamily_app/store/reducer/route.dart';
import 'package:tradersfamily_app/store/route.dart';


class MarketPage extends StatefulWidget {
  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NavMain(
          currentPage: 'Market',
          backPage: () async {
              store.dispatch(RouteReducer(operation: Operation.bringToHome, payload: HomeTab.home));
            },
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: MarketCard(),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
              child: Column(
                children: [
                  Container(
                    child: StockInfoRow(
                      title1: 'Open',
                      value1: '6,704.23',
                      title2: 'Lot',
                      value2: '179.42M',
                      title3: 'High',
                      value3: '6,727.29',
                      title4: 'Value',
                      value4: '7.66T',
                      title5: 'Low',
                      value5: '6,669.24',
                      title6: 'Freq',
                      value6: '12.20M',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16.0, right: 16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Emiten Berdasarkan Kategori',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.8, fontFamily: 'Manrope'),
                            ),
                          ],
                        ),
                        // SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal,
                        //   child: Row(
                        //     children: <Widget>[
                        //       EmitenCategory(),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0, right: 16.0),
                    child: Column(
                      children: [
                        EmitenSlider.EmitenCategory(),
                        // SizedBox(width: 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Lihat Semua',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontFamily: 'Manrope',          
                              ),
                            ),
                            SizedBox(width: 3.5),
                            Image.asset(
                              'assets/icon/light/arrow-right.png',
                              width: 13.5,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0, right: 16.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Container(
                            child: Text(
                              'Index Saham',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Manrope'
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        IndexSaham(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Lihat Semua',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontFamily: 'Manrope',      
                              ),
                            ),
                            SizedBox(width: 3.5),
                            Image.asset(
                              'assets/icon/light/arrow-right.png',
                              width: 13.5,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0, right: 16.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Container(
                            child: Text(
                              'Sektor Saham',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Manrope',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        GridView.count(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            GridSektor('Bahan Baku', 'assets/package.png', '-0.97%'),
                            GridSektor('Primer', 'assets/coffee.png', '-0.35%'),
                            GridSektor('Non Primer', 'assets/tv.png', '-0.97%'),
                            GridSektor('Energi', 'assets/zap.png', '-1.15%'),
                            GridSektor('Keuangan', 'assets/dollar-sign.png', '-0.37%'),
                            GridSektor('Kesehatan', 'assets/heart.png', '-0.39%'),
                            GridSektor('Industri', 'assets/idustry.png', '-1.25%'),
                            GridSektor('Prasarana', 'assets/road.png', '+0.03%'),
                            GridSektor('Properti', 'assets/house.png', '-0.36%'),
                            GridSektor('Teknologi', 'assets/cpu.png', '-0.07%'),
                            GridSektor('Transport', 'assets/truck.png', '-1.09%'),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





