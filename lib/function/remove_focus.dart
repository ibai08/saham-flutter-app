import 'package:flutter/material.dart';

removeFocus(contex) {
  FocusScope.of(contex).requestFocus(FocusNode());
}
