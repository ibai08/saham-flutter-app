// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../views/pages/home.dart';
import 'package:shimmer/shimmer.dart';

class HomeSignalJustMadeProfitShimmer extends StatefulWidget {
  const HomeSignalJustMadeProfitShimmer({Key? key}) : super(key: key);

  @override
  State<HomeSignalJustMadeProfitShimmer> createState() =>
      _HomeSignalJustMadeProfitShimmerState();
}

class _HomeSignalJustMadeProfitShimmerState
    extends State<HomeSignalJustMadeProfitShimmer> {
  List<String> counts = ["", "", "", "", "", "", ""];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitlePartHome(
          title: "Signal baru saja profit",
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
    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: const BorderRadius.all(Radius.circular(4)),
    ),
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
                    margin: const EdgeInsets.only(bottom: 10, top: 10),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: backgroundcolor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 5, right: 5, bottom: 10, top: 10),
                    width: 20,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: backgroundcolor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 0),
                          width: 70,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: backgroundcolor,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
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
                  //sini
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  indent: 1,
                  endIndent: 0,
                  color: Color(0xFFC9CCCF),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          width: 40,
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: backgroundcolor,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: 90,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: backgroundcolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        width: 40,
                        height: 7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: backgroundcolor,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: 90,
                        height: 5,
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
