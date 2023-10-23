// ignore_for_file: sized_box_for_whitespace, must_be_immutable

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SignalShimmer extends StatelessWidget {
  final String? title;
  final String? onLoad;
  SignalShimmer({Key? key, this.title, this.onLoad}) : super(key: key);
  List<String> counts = ["", "", "", "", "", ""];
  // List<int> _dataChannel = [];
  int sort = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        shrinkWrap: true,
        children: [
          onLoad == "1"
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  child: Column(
                    children: [
                      Text(
                        title ?? "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          ...counts.map((count) {
            return box(count, Colors.grey[350], context);
          }).toList()
        ],
      ),
    );
  }
}

Widget box(String num, Color? backgroundcolor, context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(0)),
      boxShadow: [BoxShadow(color: Colors.grey[400]!, blurRadius: 0)],
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
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 10),
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: backgroundcolor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 10),
                    width: 25,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundcolor,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        width: 200,
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: backgroundcolor,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        width: 130,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: backgroundcolor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 12, top: 10),
                    width: 70,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundcolor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 12, top: 10),
                    width: 130,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundcolor,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                        left: 10, top: 5, bottom: 10, right: 10),
                    width: MediaQuery.of(context).size.width * 0.50,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundcolor,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.50,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: backgroundcolor,
                    ),
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
// class SignalShimmerNew extends StatefulWidget {
//   const 
  

//   @override
//   State<SignalShimmer> createState() => _SignalShimmerNewState();
// }

// class SignalShimmerNew extends StatelessWidget {
//   SignalShimmerNew({Key? key, this.title, this.onLoad}) : super(key: key);
//   final String? title;
//   final String? onLoad;
//   List<String> counts = ["", "", "", "", "", ""];
//   // List<int> _dataChannel = [];
//   int sort = 0;

//   @override
//   Widget build(BuildContext context) {

//     // return Column(
//     //   crossAxisAlignment: CrossAxisAlignment.start,
//     //   children: [
//     //     onLoad == "1"
//     //         ? Container(
//     //             padding: EdgeInsets.only(left: 15, top: 15),
//     //             child: Column(
//     //               children: [
//     //                 Text(
//     //                   title,
//     //                   style: TextStyle(
//     //                     fontSize: 17,
//     //                     fontWeight: FontWeight.bold,
//     //                   ),
//     //                 ),
//     //               ],
//     //             ),
//     //           )
//     //         : Text(""),
//     //     Container(
//     //       child: Column(
//     //         children: [
//     //           Padding(
//     //             padding: EdgeInsets.all(10),
//     //             child: Container(
//     //               width: MediaQuery.of(context).size.width,
//     //               child: ListView(
//     //                 scrollDirection: Axis.vertical,
//     //                 children: counts.map((count) {
//     //                   return box(count, Colors.grey[350], context);
//     //                 }).toList(),
//     //               ),
//     //             ),
//     //           )
//     //         ],
//     //       ),
//     //     )
//     //   ],
//     // );
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       child: ListView(
//         scrollDirection: Axis.vertical,
//         padding: const EdgeInsets.only(top: 15),
//         shrinkWrap: true,
//         children: [
//           onLoad == "1"
//               ? Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                   child: Column(
//                     children: [
//                       Text(
//                         title!,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const SizedBox(),
//           ...counts.map((count) {
//             return box(count, Colors.grey[350]!, context);
//           }).toList()
//         ],
//       ),
//     );
//   }
// }

// Widget boxes(String num, Color backgroundcolor, context) {
//   return Container(
//     width: MediaQuery.of(context).size.width,
//     margin: const EdgeInsets.all(10),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: const BorderRadius.all(Radius.circular(0)),
//       boxShadow: [BoxShadow(color: Colors.grey[400]!, blurRadius: 0)],
//     ),
//     child: Column(
//       children: [
//         Shimmer.fromColors(
//           baseColor: Colors.grey[400]!,
//           highlightColor: Colors.grey[300]!,
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(
//                         left: 10, right: 10, bottom: 10, top: 10),
//                     width: 55,
//                     height: 55,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(100),
//                       color: backgroundcolor,
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(
//                         left: 10, right: 10, bottom: 10, top: 10),
//                     width: 25,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: backgroundcolor,
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(top: 20, bottom: 10),
//                         width: 200,
//                         height: 15,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: backgroundcolor,
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 20),
//                         width: 130,
//                         height: 10,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: backgroundcolor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Container(
//                     margin: const EdgeInsets.only(left: 12, top: 10),
//                     width: 70,
//                     height: 10,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: backgroundcolor,
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(right: 12, top: 10),
//                     width: 130,
//                     height: 10,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: backgroundcolor,
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     alignment: Alignment.center,
//                     margin: const EdgeInsets.only(
//                         left: 10, top: 5, bottom: 10, right: 10),
//                     width: MediaQuery.of(context).size.width * 0.88,
//                     height: 65,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: backgroundcolor,
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     alignment: Alignment.center,
//                     width: MediaQuery.of(context).size.width * 0.93,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: backgroundcolor,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
