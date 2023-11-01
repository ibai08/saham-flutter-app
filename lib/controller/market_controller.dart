import 'package:get/get.dart';
import 'package:saham_01_app/models/entities/saham_growth.dart';

class MarketController extends GetxController {
  RxInt activeCategoryButtonIndex = 0.obs;
  RxInt activePeriodButtonIndex = 0.obs;
  List<String> periodValues = ["1D", "1W", "1M", "3M", "1Y", "5Y", "All"];
  List<String> categoryValues = ["Most Active", "Top Gamer (by %)", "Top Loser (by %)", "Top Volume"];
  Rx<List<SahamGrowth>> sahamChart = Rx<List<SahamGrowth>>([]);

  
}