export '../../../../views/pages/market/widget/slider.dart';
import 'package:flutter/material.dart';

class IndexSaham extends StatelessWidget {
  const IndexSaham({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),

        // Saham Box Slider
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              IndexSahamBox('IDX30', '-0.43'),
              SizedBox(width: 10),
              IndexSahamBox('LQ45', '+0.64'),
              SizedBox(width: 10),
              IndexSahamBox('SRI-KEHATI', '-0.47'),
              SizedBox(width: 10),
              IndexSahamBox('UNTA', '+0.23'),
            ],
          ),
        ),
      ],
    );
  }
}

class IndexSahamBox extends StatelessWidget {
  final String buttonText;
  final String descText;

  const IndexSahamBox(this.buttonText, this.descText, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color descColor = Colors.black;
    if (descText.startsWith('-')) {
      descColor = Colors.red;
    } else if (descText.startsWith('+')) {
      descColor = Colors.green;
    }

    return InkWell(
      child: Container(
        width: 120,
        height: 94,
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(53, 6, 153, 1.0),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  fontFamily: 'Manrope',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              descText,
              style: TextStyle(
                  color: descColor, fontSize: 14, fontFamily: 'Manrope'),
            ),
          ],
        ),
      ),
    );
  }
}
