import 'package:get/get.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/models/entities/ois.dart';

class StatisticsController extends GetxController{
  RxInt channel = 0.obs;
  RxBool hasError = false.obs;
  RxBool hasLoad = false.obs;
  RxBool isInit = false.obs;
  RxString errorMessage = "".obs;
  Rx<ChannelStat?> statStreamCtrl = Rx<ChannelStat?>(null);
  late ChannelStat channelStat;

  void onLoading() async {
    try {
      channelStat = await ChannelModel.instance.getStatistic(channel.value);
      statStreamCtrl.value = channelStat;
      hasError.value = false;
      hasLoad.value = true;
      errorMessage.value = "";
    } catch (e, stack) {
      print("Error: $stack");
      hasError.value = true;
      hasLoad.value = false;
      errorMessage.value = e.toString();
    }
  }

  @override
  void onInit() {
    super.onInit();
    isInit.value = true;
  }

  @override
  void onReady() {
    super.onReady();
    onLoading();
  }
}