import 'package:get/get.dart';
import '../../models/entities/ois.dart';

class GrowthChartController extends GetxController {
  final RxList<ChannelSummaryGrowth>? channelGrowth =
      RxList<ChannelSummaryGrowth>([]);
  final RxList<bool> filterTime =
      <bool>[false, false, false, false, false, true].obs;
  final RxString timeVal = RxString("All");

  final RxBool hasError = false.obs;

  void setChannelGrowth(List<ChannelSummaryGrowth> growthData) {
    channelGrowth?.value = growthData;
  }

  void updateTimeVal(int index) {
    for (int i = 0; i < filterTime.length; i++) {
      filterTime[i] = i == index;
    }
    if (index == 0) {
      timeVal.value = "1W";
    } else if (index == 1) {
      timeVal.value = "1M";
    } else if (index == 2) {
      timeVal.value = "3M";
    } else if (index == 3) {
      timeVal.value = "1Y";
    } else if (index == 4) {
      timeVal.value = "3Y";
    } else {
      timeVal.value = "All";
    }
  }

  @override
  void onInit() {
    super.onInit();
    try {
      channelGrowth;
      hasError.value = false;
    } catch (e) {
      hasError.value = true;
    }
  }
}
