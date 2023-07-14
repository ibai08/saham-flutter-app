import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class ScrollUpWidget {
  final RefreshController refreshController;

  ScrollUpWidget._(this.refreshController);
  void onResetTab();
}
