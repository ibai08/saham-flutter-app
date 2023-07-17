import 'package:flutter/material.dart';

class StockInfoRow extends StatelessWidget {
  final String? title1;
  final String? value1;
  final String? title2;
  final String? value2;
  final String? title3;
  final String? value3;
  final String? title4;
  final String? value4;
  final String? title5;
  final String? value5;
  final String? title6;
  final String? value6;

  const StockInfoRow({Key? key, 
    this.title1,
    this.value1,
    this.title2,
    this.value2,
    this.title3,
    this.value3,
    this.title4,
    this.value4,
    this.title5,
    this.value5,
    this.title6,
    this.value6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        title1!,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      const Text(
                        ':',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        value1!,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  title2!,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4.0),
                const Text(
                  ':',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(width: 4.0),
                Text(
                  value2!,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        title3!,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      const Text(
                        ':',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        value3!,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  title4!,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4.0),
                const Text(
                  ':',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(width: 22.0),
                Text(
                  value4!,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        title5!,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 14.5),
                      const Text(
                        ':',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        value5!,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  title6!,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4.0),
                const Text(
                  ':',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(width: 11.5),
                Text(
                  value6!,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}