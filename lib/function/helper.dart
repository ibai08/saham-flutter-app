// ignore_for_file: null_check_always_fails

import 'package:intl/intl.dart';

import 'lang.dart';

String enumToString(Object o) => o.toString().split('.').last;

T enumFromString<T>(String key, List<T> values) {
  return values.firstWhere((v) => key == enumToString(v!));
}

String translateFromPattern(String string) {
  if (lang.containsKey(string)) {
    return lang[string]!;
  }
  if (string.contains(".app")) {
    return "Unexpected error host, please check your connection and try again";
  }
  if (string.toLowerCase().contains("timeout")) {
    return "Connection timeout, please check your connection and try again";
  }

  RegExp exp = RegExp(r"\[(\w+)\]");
  var pattern = lang.keys.firstWhere((test) {
    return (RegExp(test.replaceAll(exp, "(.*)"))).allMatches(string).isNotEmpty;
  });

  if (pattern == null) {
    return string;
  }
  var template = lang[pattern];

  var params = exp.allMatches(pattern).map((e) => e.group(0)).toList();

  if (params.isNotEmpty) {
    RegExp expPattern = RegExp(pattern.replaceAll(exp, "(.*)"));
    var variables = (expPattern
        .allMatches(string)
        .first
        .groups(List.generate(params.length, (int index) => index + 1)));

    var parsedParam = {};
    for (int i = 0; i < params.length; i++) {
      var isDateTime = RegExp(
              r"^([0-9]{4})-([0-1][0-9])-([0-3][0-9])T([0-1][0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])Z$")
          .hasMatch(variables[i]!);
      if (isDateTime) {
        if (DateTime.tryParse(variables[i]!) != null) {
          parsedParam[params[i]] = DateFormat("dd-MM-yyyy HH:mm")
              .format(DateTime.parse(variables[i]!).toLocal());
        } else {
          parsedParam[params[i]] = variables[i];
        }
      } else {
        parsedParam[params[i]] = variables[i];
      }
    }

    return template!.replaceAllMapped(exp, (m) {
      var matched = m.group(0);
      if (parsedParam.containsKey(matched)) {
        return parsedParam[matched];
      }
      return matched!;
    });
  } else {
    return template!;
  }
}
