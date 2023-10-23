import 'package:flutter/material.dart';

class BuildCardListTFPoint extends StatelessWidget {
  const BuildCardListTFPoint({
    Key? key,
    this.name,
    this.image,
    this.currentMonthPipsMin,
    this.lastMonthPips,
    this.average,
    this.count,
    this.currentMonthPips,
    this.minMedal,
    this.maxMedal,
    this.child,
  }) : super(key: key);

  final String? name;
  final String? image;

  final int? minMedal;
  final int? maxMedal;

  final int? currentMonthPips;
  final int? currentMonthPipsMin;
  final int? lastMonthPips;
  final int? average;
  final int? count;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'assets/$image.png',
                        width: 50,
                        height: 50,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name!,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              '${name == "Newbie" ? minMedal!.toStringAsFixed(0) : minMedal!.toStringAsFixed(0) + "-" + maxMedal!.toStringAsFixed(0)} XYZ Medal',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
              child!
            ],
          ),
        ),
      ],
    );
  }
}
