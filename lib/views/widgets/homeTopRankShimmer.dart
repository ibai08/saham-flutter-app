// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'package:shimmer/shimmer.dart';

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
    double top = widget.sH! * 0.08;
    print("top: ${top}");
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: top, bottom: 20),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
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
