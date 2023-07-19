import 'package:flutter/material.dart';

class SortButtonNew extends StatelessWidget {
  const SortButtonNew({
    Key? key,
    @required this.text,
    @required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  final String? text;
  final Function? onTap;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: TextButton(
        onPressed: () {
          onTap!;
        },
        child: Text(
          "$text",
           style: TextStyle(
            color: isActive != null ? Colors.black : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: isActive != null ? const Color.fromRGBO(46, 42, 255, 0.5) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isActive != null ? const Color.fromRGBO(53, 6, 153, 1.0) : Colors.grey,
              width: 1
            )
          )
        ),
      ),
    );
  }
}