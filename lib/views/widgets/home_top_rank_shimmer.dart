// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_colors.dart';

class MostConsistentChannelShimmer extends StatefulWidget {
  const MostConsistentChannelShimmer({Key? key, this.sH}) : super(key: key);
  final double? sH;

  @override
  State<MostConsistentChannelShimmer> createState() =>
      MmostConsistentChannelShimmerState();
}

class MmostConsistentChannelShimmerState
    extends State<MostConsistentChannelShimmer> {
  List<String> counts = ["", "", ""];

  @override
  Widget build(BuildContext context) {
    // double top = widget.sH! * 0.08;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8), bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[300]!,
                            child: Container(
                              width: 80,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey[300]
                              ),
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[300]!,
                              child: Container(
                                width: 160,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.grey[300]
                                ),
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Shimmer.fromColors(
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[300]!,
                            child: Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey[300]
                              ),
                            )
                          ),
                    ),
                  ],
                ),
                // ==> BOX BUYING POWER
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.grey3,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                                baseColor: Colors.grey[400]!,
                                highlightColor: Colors.grey[300]!,
                                child: Container(
                                  width: 80,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey[300]
                                  ),
                                )
                              ),
                              const SizedBox(height: 5),
                            Shimmer.fromColors(
                                baseColor: Colors.grey[400]!,
                                highlightColor: Colors.grey[300]!,
                                child: Container(
                                  width: 130,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey[300]
                                  ),
                                )
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                        child: Shimmer.fromColors(
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[300]!,
                            child: Container(
                              width: 90,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[300]
                              ),
                            )
                          ),
                      ),
                    ],
                  ),
                ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              padding: const EdgeInsets.only(right: 15, top: 10),
              child: Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    width: 130,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300]
                    ),
                  )
                ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Container(
                  height: 180,
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
    margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
    width: 240,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[300]!,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: backgroundcolor,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, left: 3, right: 3),
                child: Container(
                  width: 15,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: backgroundcolor,
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 5),
                      child: Container(
                        height: 15,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: backgroundcolor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        height: 7,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: backgroundcolor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 5),
                child: Container(
                  height: 25,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: backgroundcolor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 5),
                child: Container(
                  height: 35,
                  width: 210,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: backgroundcolor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
