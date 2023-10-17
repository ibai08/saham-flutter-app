import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/controller/homeTabController.dart';
import 'package:saham_01_app/controller/newSignalController.dart';
import 'package:saham_01_app/function/removeFocus.dart';
import 'package:saham_01_app/models/channel.dart';
import 'package:saham_01_app/views/appbar/navmain.dart';
import 'package:saham_01_app/views/widgets/getAlert.dart';
import 'package:saham_01_app/views/widgets/searchIconFormWidget.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/config.dart';
import '../../core/formatter/symbol.dart';
import '../../core/string.dart';
import '../../function/changeFocus.dart';
import '../../function/showAlert.dart' as showAlert;
import '../../models/entities/ois.dart';
import '../../models/signal.dart';
import '../widgets/dialogLoading.dart' as dl;
import '../widgets/headChannelRow.dart';
import '../widgets/homeTopRankShimmer.dart';
import '../widgets/info.dart';
import 'form/login.dart';

class AddNewSignal extends StatelessWidget {
  AddNewSignal({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final appStateController = Get.find<AppStateController>();
  final controlle = Get.put(NewSignalController());
  final NewHomeTabController newHomeTabController = Get.find();
  final DialogController dialogController = Get.find();

  Future<void> performBuatSignal(BuildContext context, GlobalKey<FormState> formKey) async {
    bool dialog = false;
    // print("jalan 1");
    // print("formkey: $formKey");
    
    try {
      controlle.trySubmit.value = true;
      bool valid = false;
      if (formKey.currentState!.validate() && controlle.data['isSelected'] != null) {
        // print("kena uyy");
        valid = true;
      }
      // print("data: ${controlle.data['price']}");
      // print("jalan 2");
      if (valid) {
        formKey.currentState?.save();
        print("jalan 3");
        double price = double.parse(controlle.data['price'].toString().replaceAll(',', '.'));
        double sl = controlle.data['sl'] == null || controlle.data['sl'] == '' ? 0 : double.parse(controlle.data['sl'].toString().replaceAll(',', '.'));
        double tp = controlle.data['tp'] == null || controlle.data['tp'] == '' ? 0 : double.parse(controlle.data['tp'].toString().replaceAll(',', '.'));

        // print("sl: $sl");
        // print("tp: $tp");
        // print("price: $price");
        // print("data: ${controlle.data['price']}");
        // print("dataselected: ${controlle.data['pair']}");
        // print("dataselected: ${controlle.data['isSelected']}");
        // print("expired at: ${controlle.expiredAtValue.value}");
        int digit = controlle.getSymbol()!.digit!;
        num digitMulti = pow(10, digit);

        String cmd = "BUY";

        if (sl > price) {
          throw Exception("SL_MUST_BE_LOWER_THAN_PRICE");
        }

        if (tp < price) {
          throw Exception("TP_MUST_BE_HIGHER_THAN_PRICE");
        }

        double rratio = double.tryParse(remoteConfig.getString("risk_reward_ratio")) ?? 1.5;

        int risk = ((price - sl).abs() * digitMulti).floor();
        int reward = ((price - tp).abs() * digitMulti).floor();

        bool checkrr = remoteConfig.getInt("risk_reward_ratio_check") == 1 ? true : false;

        double rr = risk / reward;

        if (checkrr && rr > rratio) {
          throw Exception("R:R ratio must be $rratio:1 must be equal or better");
        }

        removeFocus(context);
        bool confirm = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            elevation: 0.0,
            backgroundColor:  Colors.transparent,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0)
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        width: double.infinity,
                        child: const Text(
                          "Konfirmasi pembuatan signal",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text("SL", style: TextStyle(fontSize: 14)),
                                Text(
                                  "${pipsConverter(risk)} pips",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Text(
                            ":",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  "TP",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "${pipsConverter(reward)} pips",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                  )
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        "RR Ratio: ${rr.toStringAsFixed(2)}:1",
                        style: const TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.w600
                        )
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            style: TextButton.styleFrom(primary: Colors.blue),
                            child: const Text("CANCEL"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            style: TextButton.styleFrom(primary: Colors.blue),
                            child: const Text("OK"),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        );
        if (!confirm) {
          return;
        }

        dialog = true;

        // DialogLoading dlg = DialogLoading();
        dialogController.setProgress(LoadingState.progress, "Mohon Tunggu");
        int signalid = 0;
        removeFocus(context);
        // showDialog(
        //   barrierDismissible: false,
        //   context: context,
        //   builder: (context) {
        //     return dlg;
        //   }
        // );
        signalid = await SignalModel.instance.createSignal(
          channelid: controlle.data["isSelected"], cmd: cmd, price: price, sl: sl, tp: tp, symbol: controlle.data["pair"], hour: int.parse("10")
        );

        Get.back();
        await dialogController.setProgress(LoadingState.success, "Signal Berhasil Dibuat");
        await Future.delayed(Duration(seconds: 0)).then((_) {
          if (signalid > 0) {
            try {
              //  Navigator.popUntil(context, ModalRoute.withName("/home"));
              Get.toNamed('/dsc/signal/', arguments: {
                "signalId": signalid
              });
            } catch(e, stack) {
              print("erorr: $e");
              print("stack: $stack");
            }
            // appStateController.setAppState(Operation.bringToHome, HomeTab.home);
            // Get.toNamed('/dsc/signal/', arguments: signalid);
          }
        });
        await Future.delayed(Duration(seconds: 0)).then((value) {
          controlle.symbolsCon.clear();
          controlle.priceCon.clear();
          controlle.slCon.clear();
          controlle.tpCon.clear();
          newHomeTabController.tab.value = HomeTab.home;
          newHomeTabController.tabController.animateTo(0,duration: Duration(milliseconds: 200),curve:Curves.easeIn);
        } );
        
        // showAlert(context, LoadingState.success, "Signal berhasil dibuat", thens: (x) {
        //   appStateController.setAppState(Operation.bringToHome, HomeTab.home);
        //   Get.offNamed("/home");
        //   controlle.onClose();
        //   if (signalid > 0) {
        //     try {
        //       //  Navigator.popUntil(context, ModalRoute.withName("/home"));
        //       Get.toNamed('/dsc/signal/', arguments: {
        //         "signalId": signalid
        //       });
        //     } catch(e, stack) {
        //       print("erorr: $e");
        //       print("stack: $stack");
        //     }
        //     // appStateController.setAppState(Operation.bringToHome, HomeTab.home);
        //     // Get.toNamed('/dsc/signal/', arguments: signalid);
        //   }
        //   // print("context: $context");
        //   // Future.delayed(Duration.zero, () {
        //   //   // Navigator.popUntil(context, ModalRoute.withName("/home"));
        //   //   appStateController.setAppState(Operation.bringToHome, HomeTab.home);
        //   //   print("kalau keprint harusnya udah balik home");
        //   // });
        // });
      }
    } catch (e, stack) {
      print("error: $e");
      print("stackerror: $stack");
      if (dialog) {
        Get.back();
      }
      // showAlert(context, LoadingState.error, e.toString());
      dialogController.setProgress(LoadingState.error, e.toString());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (appStateController.users.value.id < 1 &&
        !appStateController.users.value.verify!) {
      return Login();
    } 
    if (appStateController.users.value.id > 0 &&
        !appStateController.users.value.isProfileComplete()) {
      return Scaffold(
        appBar: NavMain(
          currentPage: "Jelajahi",
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Info(
            caption: "Lengkapi Profil",
            title: "Oops...",
            desc: "Mohon lengkapi profil anda terlebih dahulu",
            onTap: () {
              // Navigator.pushNamed(context, "/forms/editprofile");
              Get.toNamed('/forms/editprofile');
            },
          ),
        ),
      );
    }
    return Scaffold(
      appBar: NavMain(
        currentPage: 'Buat Signal',
        backPage: () {
          newHomeTabController.tab.value = HomeTab.home;
          newHomeTabController.tabController.animateTo(0,duration: Duration(milliseconds: 200),curve:Curves.easeIn);
        },
      ),
      backgroundColor: AppColors.light,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            width: double.infinity,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Obx(() {
                    if (controlle.channelStreamCtrl.value == null && controlle.hasError.value == false) {
                      return const Center(
                        child: Text(
                          "Loading",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18
                        ))
                      );
                    } 
                    if (controlle.hasError.value) {
                      return Info(
                        title: "Terjadi Error",
                        caption: "Coba Lagi",
                        onTap: controlle.initializePageChannelAsync,
                        desc: controlle.errorMessage.value,
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 16),
                          child: const Text(
                            "Pilih Channel",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        ListView(
                          padding: const EdgeInsets.only(top: 15),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            ChannelListWidgetCopy(listChannel: controlle.channelStreamCtrl.value?.map((i) => ChannelModel.instance.getDetail(i.id, clearCache: true)).toList(), onSelected: controlle.handleSelected, medal: controlle.medal.value,)
                          ],
                        )
                      ],
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Emiten",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: controlle.symbolsCon,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 11, right: 18),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1
                              )
                            ),
                            suffixIcon: const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: SearchIconFormWidget(),
                            ),
                            filled: true,
                            fillColor: Colors.white
                          ),
                          readOnly: true,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Mohon untuk memilih emiten";
                            }
                            return null;
                          },
                          onTap: () {
                            controlle.navigateToSubPage(context, controlle.symbolsCon.text);
                          },
                          onFieldSubmitted: (term) {
                            removeFocus(context);
                          },
                          onSaved: (val) {
                            print("val: $val");
                            controlle.data["pair"] = val;
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("Harga", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: controlle.priceValue,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 11, right: 18),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textInputAction: TextInputAction.next,
                          inputFormatters: [SymbolInputFormatter(controlle.getSymbol)],
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Mohon untuk mengisi Price";
                            }
                            return null;
                          },
                          onFieldSubmitted: (term) {
                            changeFocus(context, controlle.priceFocus, controlle.slFocus);
                          },
                          onSaved: (val) {
                            print("price val: $val");
                            controlle.data["price"] = val;
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("Stop Loss", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: controlle.stopLosValue,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 11, right: 18),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textInputAction: TextInputAction.next,
                          inputFormatters: [SymbolInputFormatter(controlle.getSymbol)],
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Mohon untuk mengisi Stop Loss";
                            } else {
                              return null;
                            }
                          },
                          onFieldSubmitted: (term) {
                            changeFocus(context, controlle.slFocus, controlle.tpFocus);
                          },
                          onSaved: (val) {
                            controlle.data["sl"] = val;
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("Take Profit", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: controlle.takeProfitValue,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 11, right: 18),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textInputAction: TextInputAction.next,
                          inputFormatters: [SymbolInputFormatter(controlle.getSymbol)],
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Mohon untuk mengisi Take Profit";
                            } else {
                              return null;
                            }
                          },
                          onFieldSubmitted: (term) {
                            changeFocus(context, controlle.tpFocus, controlle.expiredFocus);
                          },
                          onSaved: (val) {
                            controlle.data["tp"] = val;
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("Berlaku Sampai", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        DropdownButtonFormField(
                          icon: const Icon(Icons.arrow_forward, color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 11, right: 18),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          dropdownColor: Colors.white,
                          value: controlle.expiredAtValue.value,
                          onChanged: (newValue) {
                            controlle.expiredAtValue.value = newValue.toString();
                          },
                          items: controlle.expiredList.map<DropdownMenuItem<String>>((Map value) {
                            return DropdownMenuItem<String>(
                              value: value["id"],
                              child: Text(value["title"]),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () async {
                          print("ketap");
                          print("formkeydisini: $formKey");
                          await performBuatSignal(context, formKey);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.purplePrimary,
                        ),
                        child: const Text(
                          "Buat Signal",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
      ),
    );
  }
}

class ChannelListWidgetCopy extends StatelessWidget {
  final List? listChannel;
  final Level? medal;
  final SelectedCallback? onSelected;
  RxInt activeId = (-1).obs;

  final NewSignalController controller = Get.find();

  ChannelListWidgetCopy({Key? key, this.listChannel, this.medal, this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 140,
        margin: const EdgeInsets.only(left: 15),
        child: Row(
          children: List.generate(listChannel!.length, (index) {
            final channel = listChannel?[index];
            return FutureBuilder<ChannelCardSlim>(
              future: channel,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Shimmer.fromColors(
                    highlightColor: Colors.grey[400]!,
                    baseColor: Colors.grey[300]!,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 185,
                      height: 110,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          border: snapshot.data?.id == activeId.value ? Border.all(
                            color: const Color.fromRGBO(53, 6, 153, 1)
                          ) : null
                        ),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10, top: 10),
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey[350],
                                  ),
                                ),
                                // Container(
                                //   margin: const EdgeInsets.only(
                                //       left: 10, right: 10, bottom: 10, top: 10),
                                //   width: 25,
                                //   height: 50,
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(10),
                                //     color: Colors.grey[350],
                                //   ),
                                // ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Container(
                                //       margin: const EdgeInsets.only(top: 20, bottom: 10),
                                //       width: 200,
                                //       height: 15,
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(10),
                                //         color: Colors.grey[350],
                                //       ),
                                //     ),
                                //     Container(
                                //       margin: const EdgeInsets.only(bottom: 20),
                                //       width: 130,
                                //       height: 10,
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(10),
                                //         color: Colors.grey[350],
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ],
                        ),
                    ),
                  );
                }

                final channelData = snapshot.data;

                return Obx(() {
                    return GestureDetector(
                      onTap: () {
                        // print("ketap");
                        if (channelData != null) {
                          // print("kena ini coy");
                          activeId.value = channelData.id!;
                          controller.isSelected.value = channelData.id == activeId.value;
                          if (onSelected != null) {
                            print("kena ini coy2");
                            onSelected!(activeId.value);}
                          //   print("ini boolnya: ${controller.isSelected.value}");
                          // }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          border: channelData?.id == activeId.value ? Border.all(
                            color: const Color.fromRGBO(53, 6, 153, 1)
                          ) : null
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ChannelThumbCopy(
                              level: medal!,
                              id: channelData?.id,
                              name: channelData?.name,
                              username: channelData?.username,
                              avatar: channelData?.avatar,
                              medals: channelData!.medals!,
                            ),
                            Container(
                              // ini harus bawah
                              width: 22,
                              height: 22,
                              margin: const EdgeInsets.only(bottom: 10, right: 5),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(50)),
                                border: Border.all(),
                              ),
                              child:  channelData.id == activeId.value
                                      ? Image.asset(
                                          "assets/icon/light/Checklist.png",
                                          width: 22,
                                        )
                                      : Container()
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                );
              },
            );
          }),
        ),
      ),
    );
  } 
}

typedef void SelectedCallback(int isSelected);

// class ChannelListWidgetCopy extends StatefulWidget {
//   final List listChannel;
//   final Level medal;
//   final SelectedCallback? onSelected;
//   ChannelListWidgetCopy(this.listChannel, this.medal, {this.onSelected});
//   @override
//   State<StatefulWidget> createState() => _ChannelListWidgetCopy();
// }

// typedef void SelectedCallback(int isSelected);

// class _ChannelListWidgetCopy extends State<ChannelListWidgetCopy> {
//   int activeId = -1;

//   Widget listChannelViewCopy(List<Future<ChannelCardSlim>> channels, Level medal) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         height: 140,
//         margin: EdgeInsets.only(left: 15),
//         child: Row(
//           children: List.generate(channels.length, (index) {
//             final channel = channels[index];

//             return FutureBuilder<ChannelCardSlim>(
//               future: channel,
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Container();
//                 }

//                 final channelData = snapshot.data;
//                 final isSelected = channelData?.id == activeId;

//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       activeId = channelData.id;
//                       if (widget.onSelected != null) {
//                         widget.onSelected(activeId);
//                       }
//                     });
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(right: 10),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(5)),
//                       border: isSelected ? Border.all(
//                         color: Color.fromRGBO(53, 6, 153, 1)
//                       ) : null
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         ChannelThumbCopy(
//                           level: medal,
//                           id: channelData?.id,
//                           name: channelData?.name,
//                           username: channelData?.username,
//                           avatar: channelData?.avatar,
//                           medals: channelData?.medals,
                          
//                         ),
//                         Container(
//                           // ini harus bawah
//                           width: 22,
//                           height: 22,
//                           margin: EdgeInsets.only(bottom: 10, right: 5),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(50)),
//                             border: Border.all(),
//                           ),
//                           child: isSelected
//                               ? Image.asset(
//                                   "assets/icon/light/Checklist.png",
//                                   width: 22,
//                                 )
//                               : Container(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return listChannelViewCopy(widget.listChannel, widget.medal);
//   }
// }

class ChannelThumbCopy extends StatelessWidget {
  final int? id;
  final String? username;
  final String? name;
  final String? avatar;
  final double? width;
  final double? marginBottom;
  final String? search;
  final Level level;
  final int medals;
  final bool showIcon;

  ChannelThumbCopy({
    Key? key,
    this.id,
    this.username,
    this.name,
    this.avatar,
    this.width,
    this.marginBottom,
    this.search,
    required this.level,
    required this.medals,
    this.showIcon = false
  }) : super(key: key);

  final controller = Get.put(ChannelThumbController());
  final AppStateController appStateController = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.channel = ChannelCardSlim(
      id: id,
      avatar: avatar,
      name: name,
      username: username
    );
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      controller.channelStream.value = controller.channel;
      controller.channelSubs = await controller.channel.watchChannelCache(appStateController.users.value.id);
      controller.channelSubs?.update((val) {
        if (val == "") {
          return;
        }
        try {
          Map boxData = jsonDecode(val!);
          if (boxData.containsKey("data")) {
            controller.channelStream.value = ChannelCardSlim.fromMap(boxData["data"]);
          }
        } catch (e) {
          print("error: $e");
          controller.hasError.value = true;
        }
      });
    });
    if (level.level == null) {
      return const SizedBox();
    }
    return Obx(() {
      ChannelCardSlim? tChannel = controller.channelStream.value;
      if (controller.channelStream.value == null || controller.hasError.value) {
        tChannel = controller.channel;
      }
      return Container(
        width: 140,
        margin: const EdgeInsets.only(top: 0, bottom: 10, left: 15),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: Colors.white
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            HeadChannelRow(
              isMedium: false,
              isLarge: false,
              avatar: avatar ?? "",
              level: level,
              title: name!,
              medals: medals
            ),
            const SizedBox(
              width: 1,
            )
          ],
        ),
      );
    });
  }
}


class ChannelThumbController extends GetxController {
  late Rx<String?>? channelSubs;
  Rx<ChannelCardSlim?> channelStream = Rx<ChannelCardSlim?>(null);
  late ChannelCardSlim channel;
  RxBool hasError = false.obs;

  RxInt activeId = (-1).obs;

  @override
  void onClose() {
    super.onClose();
    if (channelSubs != null) {
      channelSubs?.close();
    }
  }
}



