import 'package:redux/redux.dart';
import 'package:saham_01_app/utils/store/appstate.dart';
import 'package:saham_01_app/utils/store/reducer/user.dart';

AppState reducer(AppState prev, dynamic action) {
  if (action is UserReducer) {
    return action.mapOperationToState(prev);
  }
  // else if (action is FirebaseReducer) {
  //   return action.mapOperationToState(prev);
  // } else if (action is RouteReducer) {
  //   return action.mapOperationToState(prev);
  // } else if (action is MrgReducer) {
  //   return action.mapOperationToState(prev);
  // } else if (action is AskapReducer) {
  //   return action.mapOperationToState(prev);
  // } else if (action is InboxReducer) {
  //   return action.mapOperationToState(prev);
  // }

  return prev;
}

Store? store;
