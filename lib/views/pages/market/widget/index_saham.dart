export 'package:saham_01_app/views/pages/market/widget/slider.dart';
import 'package:flutter/material.dart';

class IndexSaham extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        
        // Saham Box Slider
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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

  IndexSahamBox(this.buttonText, this.descText);

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
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(53, 6, 153, 1.0),
                borderRadius: BorderRadius.circular(8.0)
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  fontFamily: 'Manrope',
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text(
              descText,
              style: TextStyle(
                color: descColor,
                fontSize: 14,
                fontFamily: 'Manrope'
              ),
            ),
          ],
        ),
      ),
    );
  }
}