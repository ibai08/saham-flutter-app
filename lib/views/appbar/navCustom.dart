// ignore: file_names
import 'package:flutter/material.dart';

class NavCustom extends AppBar {
  NavCustom({Key? key, String? title, tap})
      : super(
            key: key,
            title: Text(
              title!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.blueGrey[900],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: tap,
            ));
}
