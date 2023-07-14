// import 'package:tradersfamily_app/models/entities/askap.dart';
// import 'package:tradersfamily_app/models/entities/firebase.dart';
// import 'package:tradersfamily_app/models/entities/inbox.dart';
// import 'package:tradersfamily_app/models/entities/mrg.dart';
// import 'package:tradersfamily_app/models/entities/ois.dart';
import '../../models/entities/inbox.dart';
import '../../models/entities/user.dart';
import 'route.dart';

class AppState {
  UserInfo user = UserInfo.init();
  // UserInfo userEdit = UserInfo.init();
  // FirebaseState fbState = FirebaseState.init();
  HomeTab homeTab = HomeTab.home;
  // UserMRG userMrg = UserMRG.init();
  // OisSearch oisSearch = OisSearch.init();
  // UserAskap userAskap = UserAskap.init();
  // int inboxCount = 0;
  InboxCount inboxCountTag = InboxCount.init();

  AppState(
      {user,
      // this.userEdit,
      // this.fbState,
      homeTab,
      // this.userMrg,
      // this.oisSearch,
      // this.userAskap,
      // this.inboxCount,
      inboxCountTag});

  AppState remake(
      {UserInfo? mUser,
      // UserInfo mUserEdit,
      // FirebaseState mFbState,
      HomeTab? mHomeTab,
      // UserMRG mUserMRG,
      // OisSearch mOisSearch,
      // UserAskap mUserAskap,
      // int mInboxCount,
      InboxCount? mInboxCountTag}) {
    UserInfo tmpUser = mUser == null ? this.user : mUser;
    // UserInfo tmpUserEdit = mUserEdit == null ? this.userEdit : mUserEdit;
    // FirebaseState tmpFirebaseToken = mFbState == null ? this.fbState : mFbState;
    HomeTab tmpHome = mHomeTab == null ? this.homeTab : mHomeTab;
    // UserMRG tmpUserMRG = mUserMRG == null ? this.userMrg : mUserMRG;
    // OisSearch tmpOisSearch = mOisSearch == null ? this.oisSearch : mOisSearch;
    // UserAskap tmpUserAskap = mUserAskap == null ? this.userAskap : mUserAskap;
    // int tmpInboxCount = mInboxCount == null ? this.inboxCount : mInboxCount;
    InboxCount tmpInboxCountTag =
        mInboxCountTag == null ? this.inboxCountTag : mInboxCountTag;
    print("ini AppState()");
    print(AppState());
    return AppState(
        user: tmpUser,
        // userEdit: tmpUserEdit,
        // fbState: tmpFirebaseToken,
        homeTab: tmpHome,
        // userMrg: tmpUserMRG,
        // oisSearch: tmpOisSearch,
        // userAskap: tmpUserAskap,
        // inboxCount: tmpInboxCount,
        inboxCountTag: tmpInboxCountTag);
  }
}
