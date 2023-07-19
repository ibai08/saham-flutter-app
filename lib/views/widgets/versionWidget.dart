import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionWidget extends StatefulWidget {
  const VersionWidget({Key? key}) : super(key: key);

  @override
  State<VersionWidget> createState() => _VersionWidgetState();
}

class _VersionWidgetState extends State<VersionWidget> {
  StreamController<PackageInfo> packageInfoStreamCtrl = StreamController();
  @override
  void initState() {
    Future.delayed(Duration.zero).then((x) async {
      try {
        packageInfoStreamCtrl.add(await PackageInfo.fromPlatform());
        if (mounted) {
          setState(() {});
        }
      } catch (ex) {
        packageInfoStreamCtrl.addError(ex);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PackageInfo>(
        stream: packageInfoStreamCtrl.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PackageInfo packageInfo = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 45),
              child: Text(
                "App Version ${packageInfo.version} | Build Number ${packageInfo.buildNumber}",
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const SizedBox();
        });
  }
}