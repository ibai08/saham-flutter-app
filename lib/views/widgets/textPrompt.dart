import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class TextPrompt extends StatelessWidget {
  const TextPrompt({
    Key key,
    @required this.title,
    @required this.desc,
    @required this.cta,
    @required this.fn,
    this.padding,
  }) : super(key: key);

  final String title;
  final String desc;
  final String cta;
  final Function fn;
  final double padding;

  @override
  Widget build(BuildContext context) {
    double pad = padding;
    // ignore: prefer_conditional_assignment
    if (pad == null) {
      pad = 20;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            desc,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed:() {
              fn;
            },
            style:
                TextButton.styleFrom(backgroundColor: AppColors.primaryGreen),
            child: Text(
              cta,
              style:
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}