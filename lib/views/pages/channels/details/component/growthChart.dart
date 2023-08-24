import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../controller/growthChartController.dart';
import '../../../../../models/entities/ois.dart';
import '../../../../../views/pages/channels/details/charts/growth.dart';
import '../../../../../views/widgets/info.dart';

const List<Widget> fruits = <Widget>[
  Text(
    '1W',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  Text(
    '1M',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  Text(
    '3M',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  Text(
    '1Y',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  Text(
    '3Y',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  Text(
    'All',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
];

class GrowthChartComponentWidget extends StatelessWidget {
  final List<ChannelSummaryGrowth>? data;
  final Function? onLoading;

  GrowthChartComponentWidget({Key? key, this.data, this.onLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GrowthChartController());
    Widget growthChartWidget = const SizedBox(height: 0);

    controller.setChannelGrowth(data!);

    return Obx(() {
      RxList<ChannelSummaryGrowth>? lGrowth = controller.channelGrowth;
      // ignore: unrelated_type_equality_checks
      if (controller.channelGrowth == null && controller.hasError != true) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: const Center(
            child: Text("Tunggu ya..!!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        );
      }
      // ignore: unrelated_type_equality_checks
      if (controller.hasError == true) {
        return ListView(
          children: <Widget>[
            Info(
              onTap: onLoading,
              image: const SizedBox(),
            )
          ],
        );
      }
      if (lGrowth != null && lGrowth.length > 1) {
        growthChartWidget = Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Growth Channels",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black)),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        margin: const EdgeInsets.only(right: 10),
                        color: AppColors.blue2,
                      ),
                      const Text("Profit Official Version")
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    bottom: 25, left: 35, right: 35, top: 15),
                height: 300,
                child: ChartGrowth(lGrowth, controller.timeVal.value),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey2,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: ToggleButtons(
                    onPressed: (int index) {
                      controller.updateTimeVal(index);
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    selectedColor: AppColors.black,
                    selectedBorderColor: Colors.transparent,
                    fillColor: AppColors.white,
                    borderColor: Colors.transparent,
                    color: AppColors.black,
                    isSelected: controller.filterTime,
                    children: fruits,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      }
      return growthChartWidget;
    });
  }
}
