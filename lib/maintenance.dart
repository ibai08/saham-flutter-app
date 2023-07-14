import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MaintenanceView extends StatefulWidget {
  @override
  _MaintenanceViewState createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    Get.toNamed("/");
    _refreshController.refreshCompleted();
  }

  DateFormat estMaintenanceFormat = DateFormat('dd MMM yyyy HH:mm');
  @override
  Widget build(BuildContext context) {
    // print(ModalRoute.of(context)!.settings.arguments);
    print("objects file 1");
    // DateTime est = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        body: SafeArea(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Image.asset(
                // "assets/icon/brands/tf.png",
                "assets/logo-gray.png",
                width: 60,
              )),
              SizedBox(
                height: 15,
              ),
              Text(
                "Maintenance",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Untuk peningkatan kualitas, kami melakukan maintenance aplikasi XYZ. Selama maintenance berlangsung, Anda tidak dapat mengaksesnya sementara waktu.",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: Colors.grey[900]),
                  children: [
                    TextSpan(
                      text: "Perkiraan selesai pada ",
                    ),
                    TextSpan(
                        text: "estMaintenanceFormat.format(est.toLocal())",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
