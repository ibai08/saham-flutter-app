import 'package:get/get.dart';
import 'package:saham_01_app/models/entities/ois.dart';

class SignalFrequencyController extends GetxController {
  final Rx<ChannelSummaryDetail?>? channelDetail = Rx<ChannelSummaryDetail?>(null);
  
  void setChannelDetail(ChannelSummaryDetail summaryDetail) {
    channelDetail?.value = summaryDetail;
  }
}