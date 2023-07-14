import 'package:flutter/material.dart';
import 'package:saham_01_app/utils/store/appkeys.dart';
import 'package:saham_01_app/utils/store/appstate.dart';
import 'package:saham_01_app/utils/store/reducer/operation.dart';
import 'package:saham_01_app/utils/store/route.dart';

class RouteReducer {
  Operation? operation;
  dynamic payload;

  RouteReducer({this.operation, this.payload});

  AppState mapOperationToState(AppState prev) {
    switch (this.operation) {
      case Operation.bringToHome:
        AppKeys.navKey.currentState!.popUntil(ModalRoute.withName("/"));
        if (this.payload is HomeTab) {
          return prev.remake(mHomeTab: this.payload);
        }
        break;
      case Operation.pushNamed:
        if (this.payload is Map) {
          Map data = this.payload;
          if (data.containsKey("route")) {
            if (data.containsKey("arguments")) {
              AppKeys.navKey.currentState!
                  .pushNamed(data["route"], arguments: data["arguments"]);
            } else {
              AppKeys.navKey.currentState!.pushNamed(data["route"]);
            }
          }
        }
        break;
      default:
        break;
    }
    return prev;
  }
}
