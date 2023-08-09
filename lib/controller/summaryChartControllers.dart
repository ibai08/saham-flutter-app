import 'package:get/get.dart';
import 'package:saham_01_app/models/entities/ois.dart';

class SummaryChartController extends GetxController {
  final Rx<ChannelSummaryDetail?>? channelSummaryDetail = Rx<ChannelSummaryDetail?>(null);

  void setSummaryDetail(ChannelSummaryDetail summaryDetail) {
    channelSummaryDetail?.value = summaryDetail;
  }
}