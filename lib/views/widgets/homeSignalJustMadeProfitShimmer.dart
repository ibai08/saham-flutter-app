// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/views/pages/home.dart';
import 'package:shimmer/shimmer.dart';

class HomeSignalJustMadeProfitShimmer extends StatefulWidget {
  const HomeSignalJustMadeProfitShimmer({Key? key}) : super(key: key);

  @override
  State<HomeSignalJustMadeProfitShimmer> createState() =>
      _HomeSignalJustMadeProfitShimmerState();
}

class _HomeSignalJustMadeProfitShimmerState
    extends State<HomeSignalJustMadeProfitShimmer> {
  List<String> counts = ["", "", "", "", "", ""];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitlePartHome(
          title: "Signal yang baru saja profit",
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                height: 700,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: counts.map((count) {
                    return box(count, Colors.grey[350]!);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget box(String num, Color backgroundcolor) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    padding: const EdgeInsets.only(left: 5, right: 5),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(color: AppColors.grey, blurRadius: 4, offset: const Offset(0, 1))
        ]),
    child: Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[300]!,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: backgroundcolor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 10),
                    width: 20,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundcolor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 5),
                          width: 70,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: backgroundcolor,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          width: 120,
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: backgroundcolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundcolor,
                    ),
                  ),
                ],
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 0)),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: backgroundcolor,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: 90,
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: backgroundcolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: backgroundcolor,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: 70,
                        height: 7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: backgroundcolor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}