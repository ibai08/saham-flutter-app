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
    print("ini dulu");
    try {
      print("proses 0");
      hasError.value = '';
      print("proses 1");
      print("udah proses 1: ${channel.value}");
      summaryDetail = await ChannelModel.instance.getSummary2(channel.value);
      print("proses 2");
      summaryDetailAll = await ChannelModel.instance
          .getSummary2(channel.value, isAlltime: true);
      print("summary detail: ${summaryDetail?.toMap()}");
      print("summary detail all: ${summaryDetailAll}");
      print("proses 3");
      chartDetail = await ChannelModel.instance.getChart(channel.value);
      print("selesai onLoading");
      hasLoad.value = true;
    } catch (e) {
      hasError.value = e.toString();
      print("haseroro: $hasError");
    }
  }

  @override
  void onReady() {
    super.onReady();
    onLoading();

    print("udah ready");
  }
}
