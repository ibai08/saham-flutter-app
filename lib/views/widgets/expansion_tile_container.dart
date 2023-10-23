import 'package:flutter/material.dart';

class ExpansionTileContainer extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const ExpansionTileContainer({Key? key, required this.title, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey[300]!),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)]
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18
          ),
        ),
        children: children,
      ),
    );
  }
}