// ignore_for_file: unused_element

import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Widget?> _buildWidgetFromApi(BuildContext context) async {
    // Get JSON from local
    var response = await rootBundle.loadString('assets/json/widgets.json');
    await Future.delayed(const Duration(seconds: 2));
    return DynamicWidgetBuilder.build(response, context, DefaultClickListener(context: context));

    // // Get JSON from endpoint
    // var response = await Dio().get('https://bengkelrobot.net:8003/api/dynamic-widget/profile-page');
    // var responseJson = json.encode(response.data);
    // return DynamicWidgetBuilder.build(responseJson, context, DefaultClickListener());
}

class DefaultClickListener extends ClickListener {
  final BuildContext? context;
  DefaultClickListener({this.context});

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void onClicked(String? event) {
    if (event!.startsWith('/')) {
      Navigator.pushNamed(context!, event);
    }
    if (event.contains('https')) {
      final Uri url = Uri.parse(event);
      _launchUrl(url);
    }
  }
}