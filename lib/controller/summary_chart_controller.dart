import 'package:get/get.dart';
import '../../models/entities/ois.dart';

class SummaryChartController extends GetxController {
  final Rx<ChannelSummaryDetail?>? channelSummaryDetail =
      Rx<ChannelSummaryDetail?>(null);

  void setSummaryDetail(ChannelSummaryDetail summaryDetail) {
    channelSummaryDetail?.value = summaryDetail;
  }
}
