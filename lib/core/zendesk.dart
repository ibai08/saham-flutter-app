import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/core/getStorage.dart';
import 'package:saham_01_app/function/launchUrl.dart';
import 'package:saham_01_app/views/widgets/dialogConfirmation.dart';
import 'package:zendesk/zendesk.dart';

final Zendesk zendesk = Zendesk();

class ZendeskTag {
  static String login = "TFApp:Login";
  static String logout = "TFApp:Logout";
  static String newVisitor = "TFApp:New-Visit";

  static String mrgReal = "IMS:[MRG:Real_Account]";
  static String askapReal = "IMS:[Askap:Real_Account]";
  static String mrgInvestor = "IMS:[MRG:Investor]";
  static String askapInvestor = "IMS:[Askap:Investor]";
}

class MainZendesk {
  static GetStorage gs = GetStorage();
  static List<String> listTag = [];

  Future<void> initZendesk() async {
    try {
      String? zendeskKey = remoteConfig?.getString("zendesk_token");
      String defaultKey = '2s2WJDCUfkCkSLhf09CiAHZl9bXI2Bj8';
      await zendesk.init(zendeskKey == "" ? defaultKey : zendeskKey);
      gs.write('zendesk_token', zendeskKey == "" ? defaultKey : zendeskKey);
    } catch (e) {
      print(e);
    }
  }

  Future<void> setVisitorInfo({String name = "", String email = "", String phone = ""}) async {
    try {
      await gs.write(CacheKey.listUserInfo, [email, name, phone]);
    } catch (e) {
      print(e);
    }
  }

  bool hasVisitorInfo() {
    List<String>? userInfo = gs.read<List<String>>(CacheKey.listUserInfo);
    return userInfo != null;
  }

  Future<List<String>?> getVisitorInfo() async {
    return gs.read<List<String>>(CacheKey.listUserInfo);
  }

  Future<void> removeTag(String tag) async {
    await zendesk.removeVisitorTags([tag]);
  }

  Future<void> addTag(String tag) async {
    await zendesk.addVisitorTags([tag]);
  }

  bool? checkAvailable({contex}) {
    try {
      if (remoteConfig?.getString("livechat_schedule") != null &&remoteConfig?.getString("livechat_schedule") != "") {
        DateTime now = DateTime.parse(DateTime.now().toUtc().add(Duration(hours: 7)).toString().replaceAll("Z", ""));

        Map schedule = jsonDecode(remoteConfig!.getString("livechat_schedule"));
        String dateNow = DateFormat('yyyy-MM-dd').format(now);
        DateTime startHour = DateTime.parse('$dateNow ${schedule["start_time"]}');
        DateTime endHour = DateTime.parse('$dateNow ${schedule["end_time"]}');
        int startWeek = schedule["start_date"] ?? 0;
        int endWeek = schedule["end_date"] ?? 0;
        List<String> dayOfWeek = [
          "",
          "Senin",
          "Selasa",
          "Rabu",
          "Kamis",
          "Jumat",
          "Sabtu",
          "Minggu"
        ];
        if (now.weekday >= startWeek && now.weekday <= endWeek) {
          if (now.compareTo(endHour) < 0 && now.compareTo(startHour) > 0) {
            return true;
          }
        }
        if (contex != null) {
          showDialog(
            context: contex,
            builder: (contex) {
              return DialogConfirmation(
                title: "Konfirmasi",
                desc: "Terima kasih telah menghubungi kami. Mohon maaf, saat ini LiveChat Support kami sedang offline. \n\nSilakan hubungi kami kembali di hari ${dayOfWeek[startWeek]}-${dayOfWeek[endWeek]} pukul ${DateFormat("HH:mm").format(startHour)} -  ${DateFormat("HH:mm").format(endHour)} WIB. \n\nAtau tinggalkan pesan melalui Whatsapp kami di: ${schedule["wa"].toString().replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ")}",
                tapWidget: ElevatedButton.icon(
                  icon: Image.asset("assets/icon-wa-white.png", width: 20),
                  label: const Text(
                    "HUBUNGI KAMI",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  onPressed: () {
                    launchURL("https://api.whatsapp.com/send?phone=62" + schedule["wa"].toString().replaceRange(0, 1, ""));
                  },
                ),
              );
            }
          );
        }
      } else {
        return true;
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }

  Future<void> startChat({context}) async {
    try {
      if (!hasVisitorInfo()) {
        if (appStateController!.users.value.id! > 0) {
          setVisitorInfo(
          email: '${appStateController?.users.value.email}',
          name: '${appStateController?.users.value.fullname}',
          phone: '${appStateController?.users.value.phone}');
        }
      }
      List<String>? listUserInfo = await getVisitorInfo();
      zendesk.setVisitorInfo(name: listUserInfo![1], email: listUserInfo[0], phoneNumber: listUserInfo[2]).then((value) => print("Success SetVisitor")).catchError((e) => print(e));
      if (appStateController!.userMrg.value.realAccounts!.isNotEmpty) {
        addTag(ZendeskTag.mrgReal).then((value) => null).catchError((e) => print(e));
      }
      if (appStateController!.userMrg.value.hasDeposit!) {
        addTag(ZendeskTag.mrgInvestor).then((value) => null).catchError((e) => print(e));
      }
      if (appStateController!.userAskap.value.hasDeposit!) {
        addTag(ZendeskTag.askapInvestor).then((value) => null).catchError((e) => print(e));
      }
      if (appStateController!.userAskap.value.realAccounts!.isNotEmpty) {
        addTag(ZendeskTag.askapReal).then((value) => null).catchError((e) => print(e));
      }
      if (appStateController?.users.value.cabang != null) {
        addTag(appStateController!.users.value.cabang!).then((value) => null).catchError((e) => print(e));
      }
      gs.write(CacheKey.openLivechat, true);
      await zendesk.startChat(
          messagingName: "XYZ",
          isPreChatFormEnabled: false,
          isChatTranscriptPromptEnabled: false,
          isAgentAvailabilityEnabled: true,
          isOfflineFormEnabled: false);
    } catch (e) {
      print(e);
    }
  }
}