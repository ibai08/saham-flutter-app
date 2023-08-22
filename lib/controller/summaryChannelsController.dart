import 'package:get/get.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/ois.dart';

class SummaryChannelsController extends GetxController {
  ChannelSummaryDetail? summaryDetail;
  ChannelSummaryDetail? summaryDetailAll;

  List<ChannelSummaryGrowth> chartDetail = [];

  RxInt channel = 0.obs;

  void updateChannelValue(int channelValue) {
    channel.value = channelValue;
  }

  String hasError = '';
  void onLoading() async {
    try {
      hasError = '';
      summaryDetail = await ChannelModel.instance.getSummary2(channel.value);
      summaryDetailAll = await ChannelModel.instance
          .getSummary2(channel.value, isAlltime: true);
      chartDetail = await ChannelModel.instance.getChart(channel.value);
    } catch (e) {
      hasError = e.toString();
    }
  }

  @override
  void onInit() {
    super.onInit();
    onLoading();
  }
}
