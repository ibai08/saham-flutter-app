import 'package:flutter/material.dart';

class GridSektor extends StatefulWidget {
  final String sektorText;
  final String sektorImage;
  final String sektorPrice;

  const GridSektor(this.sektorText, this.sektorImage, this.sektorPrice, {Key? key}) : super(key: key);

  @override
  _GridSektorState createState() => _GridSektorState();
}

class _GridSektorState extends State<GridSektor> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerWidth = constraints.maxWidth;
        double containerHeight = 104;

        // Test Responsive
        if (containerWidth < 320) {
          containerWidth = containerWidth * 0.7;
          containerHeight = containerHeight * 0.7;
        }
        if (containerWidth < 360) {
          containerWidth = containerWidth * 0.9;
          containerHeight = containerHeight * 0.9;
        }
        if (containerWidth < 400) {
          containerWidth = containerWidth * 0.95;
          containerHeight = containerHeight * 0.95;
        }
        if (containerWidth < 115) {
          containerWidth = containerWidth * 0.8;
          containerHeight = containerHeight * 0.8;
        }

        return InkWell(
          child: Container(
            width: containerWidth,
            height: containerHeight,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      widget.sektorImage,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.sektorText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.sektorPrice,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
