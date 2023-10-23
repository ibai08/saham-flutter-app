// ignore_for_file: null_closures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/app_state_controller.dart';
import '../../core/string.dart';
import '../../function/helper.dart';
import '../../models/entities/mrg.dart';
import '../../models/mrg.dart';
import 'dialog_loading.dart';

class ListTileAction extends StatelessWidget {
  ListTileAction({Key? key, this.data, this.no}) : super(key: key);

  final RealAccMrg? data;
  final int? no;

  final DialogLoadingController controller = Get.put(DialogLoadingController());

  @override
  Widget build(BuildContext context) {
    var accountType = (appStateController?.userMrg.value.accountTypes)
        ?.singleWhere((type) => type.id == data?.type, orElse: null);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[300]!))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              no.toString(),
              softWrap: false,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 30,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data!.login!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Text(
                    accountType != null
                        ? (data?.contest == 1
                            ? "Contest"
                            : capitalizeFirst(accountType.name!))
                        : "-",
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    data?.date == null
                        ? "-"
                        : DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(data!.date!.toLocal()),
                    style: const TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: PopupMenuButton<String>(
              onSelected: (value) async {
                // showDialog(
                //     context: context,
                //     barrierDismissible: true,
                //     builder: (context) => dlg);
                try {
                  switch (value) {
                    case '1':
                      MarginInfo? marginInfo =
                          await MrgModel.getMarginInfo(data!.login!);

                      if (marginInfo == null) {
                        throw Exception("UNABLE_TO_CONNECT");
                      }

                      Navigator.pop(context);
                      // showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       // return DialogAccountInfo(
                      //       //   marginInfo: marginInfo,
                      //       // );
                      //     });

                      break;
                    case '4':
                      MarginInOut? margin =
                          await MrgModel.getMarginInOut(data!.login!);

                      if (margin == null) {
                        throw Exception("UNABLE_TO_CONNECT");
                      }

                      Navigator.pop(context);
                    // showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       // return DialogMarginInOut(data: margin);
                    //     });
                    // break;
                  }
                } catch (ex) {
                  controller.setProgress(
                      LoadingState.error, translateFromPattern(ex.toString()));
                  await Future.delayed(const Duration(seconds: 2));
                  Navigator.pop(context);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: "1",
                  child: Text('Account Info'),
                ),
                // const PopupMenuItem<String>(
                //   value: "2",
                //   child: Text('Open Position'),
                // ),
                // const PopupMenuItem<String>(
                //   value: "3",
                //   child: Text('Closed Position'),
                // ),
                const PopupMenuItem<String>(
                  value: "4",
                  child: Text('Margin In/Out'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}