import 'dart:convert';
import 'dart:math';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

String acak(String strPass) {
  int lenStrPass = strPass.length;
  String strEncryptedPass = "";
  for (var position = 0; position < lenStrPass; position++) {
    int keyToUse = (255 + lenStrPass + position + 1) % 255;
    int asciiNumByteToEncrypt = strPass.codeUnitAt(position);
    int xoredByte = asciiNumByteToEncrypt ^ keyToUse;
    String encryptedByte = String.fromCharCode(xoredByte);
    strEncryptedPass += encryptedByte;
  }

  return strEncryptedPass;
}

///Generate MD5 hash
String generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

bool validateMobileNumber(String value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,14}$)';
  RegExp regExp = new RegExp(patttern);
  if (regExp.hasMatch(value)) {
    return true;
  }
  return false;
}

String numberShortener(int number) {
  if (number == 0) {
    return '0';
  }
  String op = "";
  if (number < 0) {
    op = "-";
    number = number * -1;
  }
  int i = (log(number) / log(1000)).truncate();
  return op +
      (number / pow(1000, i)).truncate().toString() +
      [' ', 'K', 'Jt', 'M'][i];
}

String capitalizeFirst(String str) {
  String st = "";
  for (var s in str.split(" ")) {
    if (st != "") {
      st += " ";
    }
    st += '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}';
  }
  return st;
}

String stripHtmlBr(String string) {
  String parsedString =
      string.replaceAll("<br>", "\n").replaceAll("<br/>", "\n");

  return parsedString;
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = crypto.sha256.convert(bytes);
  return digest.toString();
}

String pipsConverter(int number) {
  if (number == 0) {
    return '0.0';
  }
  String op = "";
  if (number < 0) {
    op = "-";
    number = number * -1;
  }
  double pips = number / 10;
  int i = (log(pips) / log(1000)).truncate();
  if (pips < 10000) {
    return '$op${pips.toStringAsFixed(1)}';
  } else {
    return op +
        (pips / pow(1000, i)).truncate().toString() +
        [' ', 'K', 'M', 'B'][i];
  }
}