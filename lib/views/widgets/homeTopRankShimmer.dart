// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class HomeTopRankShimmer extends StatefulWidget {
  const HomeTopRankShimmer({Key? key, this.pT}) : super(key: key);
  final double? pT;

  @override
  State<HomeTopRankShimmer> createState() => _HomeTopRankShimmerState();
}

class _HomeTopRankShimmerState extends State<HomeTopRankShimmer> {
  List<String> counts = ["", ""];

  @override
  Widget build(BuildContext context) {
    double? pT = widget.pT;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: pT!),
      child: Column(
        children: <Widget>[
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: <Widget>[
          //     Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          //       child: ListTile(
          //         dense: true,
          //         title: Text(
          //           "Most Consistent Channel",
          //           style: TextStyle(
          //               color: Colors.black,
          //               fontWeight: FontWeight.w600,
          //               fontSize: 18),
          //         ),
          //         subtitle: Text(
          //           "Channel dengan peringkat Rank tertinggi",
          //           style: TextStyle(
          //             color: Colors.black,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: counts.map((count) {
                      return box(count, Colors.grey[350]!);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget box(String num, Color backgroundcolor) {
  return Container(
    width: 285,
    margin: const EdgeInsets.only(top: 4, left: 12, bottom: 4, right: 12),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(color: AppColors.grey, blurRadius: 4, offset: const Offset(0, 2))
        ]),
    child: Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[300]!,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: backgroundcolor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 5),
                        child: Container(
                          height: 10,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: backgroundcolor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 7,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: backgroundcolor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 100,
                padding: const EdgeInsets.only(top: 30),
                child: const VerticalDivider(
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: backgroundcolor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 5),
                        child: Container(
                          height: 10,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: backgroundcolor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 7,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: backgroundcolor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}