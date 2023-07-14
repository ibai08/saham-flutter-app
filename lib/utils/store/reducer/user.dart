import 'package:flutter/material.dart';
import 'package:saham_01_app/models/entities/inbox.dart';
import 'package:saham_01_app/models/entities/user.dart';
import 'package:saham_01_app/utils/store/appkeys.dart';
import 'package:saham_01_app/utils/store/appstate.dart';
import 'package:saham_01_app/utils/store/reducer/operation.dart';
import 'package:saham_01_app/utils/store/route.dart';

class UserReducer {
  Operation? operation;
  dynamic payload;

  UserReducer({this.operation, this.payload});

  AppState mapOperationToState(AppState prev) {
    switch (this.operation) {
      case Operation.setUser:
        if (this.payload is Map &&
            this.payload.containsKey("user") &&
            this.payload["user"] is Map) {
          return prev.remake(
            mUser: UserInfo.fromMap(this.payload["user"]),
            // mUserEdit: UserInfo.fromMap(this.payload["user"]),
          );
        }

        return prev.remake(
          mUser: UserInfo.init(),
          // mUserEdit: UserInfo.init(),
          mHomeTab: HomeTab.home,
          // mUserMRG: UserMRG.init(),
          // mUserAskap: UserAskap.init(),
        );
        break;
      case Operation.setNewVillage:
        if (this.payload is Map &&
            this.payload.containsKey("village") &&
            this.payload.containsKey("villageid") &&
            prev.user.id! > 0) {
          // prev.userEdit.village = this.payload["village"];
          // prev.userEdit.villageid = this.payload["villageid"];

          return prev;
        }
        break;
      case Operation.clearState:
        final newRouteName = "/home";
        bool isFirst = false;

        AppKeys.navKey.currentState?.popUntil((route) {
          isFirst = route.isFirst;
          return true;
        });

        if (!isFirst) {
          AppKeys.navKey.currentState
              ?.popUntil(ModalRoute.withName(newRouteName));
        }

        return prev.remake(
          mUser: UserInfo.init(),
          // mUserEdit: UserInfo.init(),
          mHomeTab: HomeTab.home,
          // mUserMRG: UserMRG.init(),
          // mUserAskap: UserAskap.init(),
          // mInboxCount: 0,
          mInboxCountTag: InboxCount.init(),
        );
        break;
      case Operation.updateAvatar:
        if (this.payload is Map &&
            this.payload.containsKey("avatar") &&
            prev.user.id! > 0) {
          // prev.userEdit.avatar = this.payload["avatar"];
          return prev;
        }
        break;
      default:
        return prev;
    }
    return prev;
  }
}
