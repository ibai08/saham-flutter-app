// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/views/widgets/channelAvatar.dart';
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
      padding: EdgeInsets.only(top: pT!, ),
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
                padding: const EdgeInsets.only(left: 9, right: 10),
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

Widget box(String num, Color backgroundColor) {
  return Container(
    width: 240,
    margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[300]!,
              child: ChannelAvatar(
                width: 40,
                imageUrl: '',
              ),
            ),
            const SizedBox(width: 2),
           
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    width: double.infinity,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Row(
            children: [
              const SizedBox(width: 3),
              Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: backgroundColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, right: 8, bottom: 3, left: 8),
          width: double.infinity,
          child: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: backgroundColor,
            ),
          ),
        ),
      ],
    ),
  );
}