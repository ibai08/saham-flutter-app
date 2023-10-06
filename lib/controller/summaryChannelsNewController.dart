import 'package:get/get.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/ois.dart';

class SummaryChannelsController extends GetxController {
  ChannelSummaryDetail? summaryDetail;
  ChannelSummaryDetail? summaryDetailAll;
  List<ChannelSummaryGrowth> chartDetail = [];
  RxBool hasError = false.obs;
  RxBool hasLoad = false.obs;
  RxInt channel = 0.obs;
  RxString errorMessage = "".obs;

  void onLoading() async {
    try {
      summaryDetail = await ChannelModel.instance.getSummary2(channel.value);
      summaryDetailAll = await ChannelModel.instance.getSummary2(channel.value, isAlltime: true);
      chartDetail = await ChannelModel.instance.getChart(channel.value);
      hasLoad.value = true;
      hasError.value = false;
      errorMessage.value = "";
    } catch (e) {
      hasError.value = true;
      hasLoad.value = false;
      errorMessage.value = e.toString();
    }
  }

  @override
  void onReady() {
    super.onReady();
    onLoading();
  }
}