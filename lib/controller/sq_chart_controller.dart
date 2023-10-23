import 'package:get/get.dart';
import '../../models/entities/ois.dart';

class SignalFrequencyController extends GetxController {
  final Rx<ChannelSummaryDetail?>? channelDetail =
      Rx<ChannelSummaryDetail?>(null);

  void setChannelDetail(ChannelSummaryDetail summaryDetail) {
    channelDetail?.value = summaryDetail;
  }
}
