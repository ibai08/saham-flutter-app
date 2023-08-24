import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SignalThumbShimmer extends StatefulWidget {
  const SignalThumbShimmer({Key? key, this.width, this.marginBottom})
      : super(key: key);

  final double? width;
  final double? marginBottom;

  @override
  _SignalThumbShimmerState createState() => _SignalThumbShimmerState();
}

class _SignalThumbShimmerState extends State<SignalThumbShimmer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[300]!,
        child: Container(
          width: widget.width ?? double.infinity,
          height: 150.0,
          margin: EdgeInsets.only(
              top: 0, bottom: widget.marginBottom ?? 15, left: 10, right: 10),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)],
            color: Colors.white,
          ),
        ));
  }
}
