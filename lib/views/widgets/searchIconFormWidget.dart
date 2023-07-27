import 'package:flutter/material.dart';

class SearchIconFormWidget extends StatelessWidget {
  const SearchIconFormWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 27, top: 15, right: 3, bottom: 15),
      child: Image.asset(
        'assets/search.png',
        width: 20,
      ),
    );
  }
}