// ignore_for_file: file_names

import 'package:get/get.dart';

import '../models/entities/user.dart';
import '../utils/store/route.dart';



class AppStateController extends GetxController {
  var user = UserInfo.init().obs;
  var userEdit = UserInfo.init().obs;
  // var fbState = FirebaseState.init().obs;
  var homeTab = HomeTab.home.obs;
  // var userMrg = UserMRG.init().obs;
  // var oisSearch = OisSearch.init().obs;
  // var userAskap = UserAskap.init().obs;
  // var inboxCount = 0.obs;
  // var inboxCountTag = InboxCount.init().obs;

  void remake({
    UserInfo? mUser,
    UserInfo? mUserEdit,
    // FirebaseState mFbState,
    HomeTab? mHomeTab,
    // UserMRG mUserMRG,
    // OisSearch mOisSearch,
    // UserAskap mUserAskap,
    // int mInboxCount,
    // InboxCount mInboxCountTag,
  }) {
    user.value = mUser ?? user.value;
    userEdit.value = mUserEdit ?? userEdit.value;
    // fbState.value = mFbState ?? fbState.value;
    homeTab.value = mHomeTab ?? homeTab.value;
    // userMrg.value = mUserMRG ?? userMrg.value;
    // oisSearch.value = mOisSearch ?? oisSearch.value;
    // userAskap.value = mUserAskap ?? userAskap.value;
    // inboxCount.value = mInboxCount ?? inboxCount.value;
    // inboxCountTag.value = mInboxCountTag ?? inboxCountTag.value;
    print(AppStateController());
  }
}