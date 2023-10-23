import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/function/launch_url.dart';
import 'package:saham_01_app/models/ois.dart';

import '../library/dynamic_widgets/dynamic_widget.dart';

class DefaultClickListener implements ClickListener {
  BuildContext context;

  DefaultClickListener(this.context);

  @override
  void onClicked(dynamic event) {
    var eventType = event['eventType'];
    var routeName = event['routeName'];
    var routeType = event['routeType'];
    var arguments = event['arguments'];
    var channelId = event['channelId'];
    var actionName = event['actionName'];
    var stateName = event['stateName'];
    switch (eventType) {
      case 'routing':
        routing(routeName, routeType, arguments);
        break;
      case 'openBrowser':
        Uri? url = Uri.parse(event['url']);
        launchURL(url);
        break;   
      case 'logAndPush':
        logAndPush(channelId, actionName, stateName, routeName, arguments);
        break; 
    }
  }

  routing(String routeName, String routeType, dynamic argument) {
    dynamic value;
    switch(routeType) {
      case 'push':
        value = Get.to(routeName, arguments: argument);
        break;
      case 'pushNamed':
        value = Get.toNamed(routeName, arguments: argument);
        break;
      case 'pushReplacement':
        value = Get.off(routeName, arguments: argument);
        break;
      case 'pushNamedAndRemoveUntil':
        value = Get.offAllNamed(routeName, arguments: argument);
        break;
      case 'popAndPushNamed':
        value = Get.offAndToNamed(routeName, arguments: argument);
        break;
      case 'pushReplacementNamed':
        value = Get.offNamed(routeName, arguments: argument);
        break;
      default:
        value = Get.toNamed(routeName, arguments: argument);
        break;
    }
    return value;
  }

  logAndPush(int channelId, String actionName, String stateName, String routeName, dynamic argument) {
    OisModel.instance.logActions(
      channelId: channelId,
      actionName: actionName,
      stateName: stateName
    ).then((x) {}).catchError((err) {});
    Get.toNamed(routeName, arguments: argument);
  }
}