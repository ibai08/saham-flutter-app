import 'package:get/get.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/ois.dart';

class PaymentController extends GetxController {
  Rx<ChannelCardSlim> channel = Rx<ChannelCardSlim>(ChannelCardSlim());
  int duration = 0;
  int metodeDD = 0;
  RxBool trySubmit = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = "".obs;

  final Rx<List<PaymentDurationInMonths>> durController = Rx<List<PaymentDurationInMonths>>([]);
  final Rx<List<PaymentChannels>> channelController = Rx<List<PaymentChannels>>([]);

  PaymentActions actions = PaymentActions();

  Future init() async {
    actions = await OisModel.instance.getPaymentActions();
    durController.value = actions.paymentDurations!;
    channelController.value = actions.paymentChannels!;
  }

  @override
  void onInit() {
    init().then((_) {}).catchError((error) {
      print(error);
      hasError.value = true;
      errorMessage.value = error.toString();
    });
    super.onInit();
  }
}