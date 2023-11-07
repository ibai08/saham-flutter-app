import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/ois.dart';

class MyChannelController extends GetxController {
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final Rx<OisMyChannelPageData?> oisStream = Rx<OisMyChannelPageData?>(null);
  late OisMyChannelPageData data;
  late OisMyChannelPageData filterData;
  RxBool hasError = false.obs;
  RxString errorMessage = "".obs;

  Future<void> synchronize({bool clearCache = false}) async {
    try {
      data = await OisModel.instance.synchronizeMyChannel(clearCache: clearCache);
      print("cekdata: ${data.listMyChannel}");
      oisStream.value = data;
      print("listchannel: ${oisStream.value?.listMyChannel}");
    } catch(err) {
      hasError.value = true;
      errorMessage.value = err.toString();
    }
  }

  void onRefresh() async {
    await synchronize();
    refreshController.refreshCompleted();
  }

  void search(String txt) {
    print(txt);
    filterData.listMyChannel = [];
    for (int i = 0; i < data.listMyChannel!.length; i++) {
      if (!data.listMyChannel![i].name.toString().toLowerCase().contains(txt.toLowerCase()) && (txt != null || txt != "")) {
        continue;
      }
      filterData.listMyChannel?.add(data.listMyChannel![i]);
    }
    
    oisStream.value = filterData;
  }

  @override
  void onInit() {
    Future.delayed(const Duration(milliseconds: 0)).then((_) async {
      await synchronize(clearCache: false);
    });
    super.onInit();
  }
}