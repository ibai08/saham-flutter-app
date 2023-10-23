import 'package:get/get.dart';
import '../../models/channel.dart';
import '../../models/entities/ois.dart';

class SummaryChannelsController extends GetxController {
  ChannelSummaryDetail? summaryDetail;
  ChannelSummaryDetail? summaryDetailAll;

  List<ChannelSummaryGrowth> chartDetail = [];

  RxBool hasLoad = false.obs;

  RxInt channel = 0.obs;

  void updateChannelValue(int channelValue) {
    channel.value = channelValue;
  }

  RxString hasError = ''.obs;
  void onLoading() async {
    try {
      hasError.value = '';
      summaryDetail = await ChannelModel.instance.getSummary2(channel.value);
      summaryDetailAll = await ChannelModel.instance
          .getSummary2(channel.value, isAlltime: true);
      chartDetail = await ChannelModel.instance.getChart(channel.value);
      hasLoad.value = true;
    } catch (e) {
      hasError.value = e.toString();
    }
  }

  @override
  void onReady() {
    super.onReady();
    onLoading();
  }
}
