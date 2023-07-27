import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({Key key,  this.text, this.bgColor, this.txtColor, this.size}) : super(key: key);

  final String text;
  final Color bgColor;
  final Color txtColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(15))
      ),
      child: Text(text, style: TextStyle(
        fontSize: size ?? 12,
        color: txtColor ?? Colors.white
      ),),
    );
  }
}