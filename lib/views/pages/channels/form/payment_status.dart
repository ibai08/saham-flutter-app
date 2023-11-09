// ignore_for_file: unnecessary_null_comparison, prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:saham_01_app/controller/payment_status_controller.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/widgets/get_alert.dart' as alert;
import 'package:saham_01_app/views/widgets/info.dart';

import '../../../../function/helper.dart';
import '../../../../models/entities/ois.dart';
import '../../../../models/ois.dart';
import '../../../widgets/dialog_confirmation.dart';
import '../../../widgets/dialog_loading.dart';

class PaymentStatus extends StatelessWidget {
  final PaymentStatusController controller = Get.put(PaymentStatusController());

  PaymentStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map args = Get.arguments as Map;
    int billNo = int.parse(args["billNo"].toString());
    if (billNo == null) {
      controller.paymentDetail.close();
      Get.back();
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: NavTxt(
        title: "Status Pembayaran",
      ),
      body: Obx(() {
        if (controller.hasError.value) {
          return Center(
            child: Info(
              onTap: controller.onRefresh(context),
            ),
          );
        }
        if (args["message"] != null && controller.count.value == 0) {
          controller.count.value++;
          Future.delayed(Duration.zero).then((x) {
            Get.find<alert.DialogController>().setProgress(alert.LoadingState.warning, "Anda memiliki pembayaran yang belum terselesaikan", null, null, null);
          });
        }
        return SmartRefresher(
          controller: controller.refreshController,
          enablePullUp: false,
          enablePullDown: true,
          onRefresh: () {
            controller.onRefresh(context);
          },
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListItemChannelsPaymentStatus(paymentDetails: controller.paymentDetail.value),
              const SizedBox(
                height: 10,
              ),
              controller.paymentDetail.value.status == 0 ? CancelChannelsPayment(
                billNo: billNo,
                paymentDetails: controller.paymentDetail
              ) : const Text("")
            ],
          ),
        );
      }),
    );
  }
}

class CancelChannelsPayment extends StatefulWidget {
  final int? billNo;
  final Rx<PaymentDetails> paymentDetails;

  const CancelChannelsPayment({Key? key, this.billNo, required this.paymentDetails})
      : super(key: key);

  @override
  _CancelChannelsPaymentState createState() => _CancelChannelsPaymentState();
}

class _CancelChannelsPaymentState extends State<CancelChannelsPayment> {
  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)],
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Selesaikan/batalkan pembayaran untuk dapat men-subscribe channel lainnya",
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (ctx) {
                    return DialogConfirmation(
                      desc: "Yakin ingin membatalkan pembayaran?",
                      action: () async {
                        Navigator.pop(ctx);
                        DialogLoading dlg = DialogLoading();
                        showDialog(
                            context: context,
                            builder: (context) => dlg,
                            barrierDismissible: false);
                        try {
                          if (await OisModel.instance
                              .cancelPayment(widget.billNo!)) {
                            // refreshStatusPayment(context, widget.streamController)
                            //     .then((_) {});
                            widget.paymentDetails.close();
                            // Navigator.pop(context);
                            Get.back();
                            await Get.find<alert.DialogController>().setProgress(alert.LoadingState.success, "CANCEL_PAYMENT_SUCCESS", null, null, null);
                            Navigator.popUntil(context, ModalRoute.withName("/home"));
                            // showAlert(context, LoadingState.success,
                            //     "CANCEL_PAYMENT_SUCCESS", then: (x) {
                            //   Navigator.popUntil(
                            //       context, ModalRoute.withName("/home"));
                            // });
                          } else {
                            throw Exception("CANNOT_CONNECT");
                          }
                        } catch (ex) {
                          widget.paymentDetails.close();
                          Get.back();
                          await Get.find<alert.DialogController>().setProgress(alert.LoadingState.error, translateFromPattern(ex.toString()), null, null, null);
                          Navigator.popUntil(context, ModalRoute.withName("/home"));
                          // Navigator.pop(context);
                          // showAlert(context, LoadingState.error,
                          //     translateFromPattern(ex.message), then: (x) {
                          //   Navigator.popUntil(
                          //       context, ModalRoute.withName("/home"));
                          // });
                        }
                        // DialogLoading dlg = new DialogLoading();
                        // showDialog(
                        //     context: ctx,
                        //     builder: (context) => dlg,
                        //     barrierDismissible: false);
                        // try {
                        //   if (await OisModel.instance
                        //       .cancelPayment(widget.billNo)) {
                        //     refreshStatusPayment(ctx, widget.streamController)
                        //         .then((_) {});
                        //     dlg.setProgress(
                        //         LoadingState.success, "CANCEL_PAYMENT_SUCCESS");
                        //   } else {
                        //     throw new Exception("CANNOT_CONNECT");
                        //   }
                        // } catch (ex) {
                        //   // Navigator.pop(context);
                        //   // showAlert(context, LoadingState.error, ex.message);
                        //   dlg.setProgress(LoadingState.error, ex.message);
                        // } finally {
                        //   await Future.delayed(Duration(seconds: 2));
                        //   Navigator.popUntil(
                        //       context, ModalRoute.withName("/home"));
                        // }
                      },
                    );
                  });
            },
            child: Text("Batalkan Pembayaran?"),
          )
        ],
      ),
    );
  }
}

class ListItemChannelsPaymentStatus extends StatelessWidget {
  final PaymentDetails paymentDetails;

  const ListItemChannelsPaymentStatus({Key? key, required this.paymentDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String status = "";
    String desc = "";

    switch (paymentDetails.status) {
      case 0:
        status = "MENUNGGU_PEMBAYARAN";
        desc = "Silahkan lakukan pembayaran Anda sebelum tanggal " +
            DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(paymentDetails.billExpired!) +
            " WIB, dengan melakukan transaksi melalui " +
            paymentDetails.paymentMethod!;
        break;
      case 1:
        status = "MENUNGGU_VERIFIKASI";
        desc = "Mohon menunggu, pembayaran Anda sedang diverifikasi";
        break;
      case 2:
        status = "PEMBAYARAN_BERHASIL";
        desc =
            "Terima Kasih atas pembayaran Anda, sekarang Anda dapat melihat signal dari channel " +
                paymentDetails.channelName!;
        break;
      case 4:
        status = "PEMBAYARAN_DIKEMBALIKAN";
        break;
      case 5:
      case 9:
        Navigator.pop(context);
        break;
      case 7:
        status = "PAYMENT_DITOLAK";
        desc =
            "Pembayaran Anda ditolak, silahkan lakukan subscribe pada channel " +
                paymentDetails.channelName! +
                " kembali";
        break;
      case 8:
        status = "PEMBAYARAN_DIBATALKAN";
        desc =
            "Pembayaran Anda telah dibatalkan, silahkan lakukan subscribe pada channel " +
                paymentDetails.channelName! +
                " kembali";
        break;

        //"0 Belum diproses; 1 Dalam proses; 2 Payment Success; 4 Payment Reserval; 5 Tagihan tidak ditemukan; 7 Payment Refused; 8 Payment Cancelled; 9 Unknown"
        // break;
      default:
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey[300]!, blurRadius: 4)],
      ),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          TitleStatus(
            status: status,
            desc: desc,
            va: paymentDetails.trxId,
            method: paymentDetails.paymentMethod,
          ),
          const Divider(
            color: Colors.grey,
          ),
          PriceAmount(
            total: NumberFormat.currency(symbol: "Rp", decimalDigits: 0)
                .format(paymentDetails.billTotal),
          ),
          const Divider(
            color: Colors.grey,
          ),
          RincianPayment(
              channelName: paymentDetails.channelName,
              duration: paymentDetails.qty.toString() + " Bulan",
              price: NumberFormat.currency(symbol: "Rp", decimalDigits: 0)
                  .format(paymentDetails.price),
              total: NumberFormat.currency(symbol: "Rp", decimalDigits: 0)
                  .format(paymentDetails.billTotal)),
        ],
      ),
    );
  }
}

class TitleStatus extends StatefulWidget {
  final String? status;
  final String? desc;
  final String? va;
  final String? method;

  const TitleStatus({Key? key, this.status, this.desc, this.va, this.method})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TitleStatus();
}

class _TitleStatus extends State<TitleStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            const SizedBox(
              height: 5,
            ),
            Text(
              translateFromPattern(widget.status!),
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 18, height: 2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget
                  .desc!, //"Silahkan lakukan pembayaran Anda sebelum tanggal 2019-10-03 16:20:52 WIB, dengan melakukan transaksi melalui BCA Virtual Account Online",
              style: const TextStyle(fontSize: 14, height: 1.3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            widget.method != "OVO"
                ? const Text(
                    "Kode unik Pembayaran",
                    style: TextStyle(fontSize: 14, height: 1.3),
                    textAlign: TextAlign.center,
                  )
                : const SizedBox(),
            widget.method != "OVO"
                ? SelectableText(
                    widget.va == null ? "" : widget.va!, //"3255370200000885",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                    ),
                    textAlign: TextAlign.center,
                  )
                : const SizedBox(),
            SizedBox(
              height: widget.method != "OVO" ? 10 : 0,
            )
          ],
        ));
  }
}

class PriceAmount extends StatefulWidget {
  final String? total;

  const PriceAmount({Key? key, this.total}) : super(key: key);

  @override
  _PriceAmountState createState() => _PriceAmountState();
}

class _PriceAmountState extends State<PriceAmount> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
    const SizedBox(
      height: 10,
    ),
    const Text(
      "Jumlah yang harus dibayarkan",
      style: TextStyle(fontSize: 14, height: 1.3),
      textAlign: TextAlign.center,
    ),
    Text(
      widget.total!,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Colors.blue[900]),
      textAlign: TextAlign.center,
    ),
    const SizedBox(
      height: 10,
    ),
      ],
    );
  }
}

class RincianPayment extends StatefulWidget {
  final String? channelName;
  final String? duration;
  final String? price;
  final String? total;

  const RincianPayment(
      {Key? key, this.channelName, this.duration, this.price, this.total})
      : super(key: key);

  @override
  _RincianPaymentState createState() => _RincianPaymentState();
}

class _RincianPaymentState extends State<RincianPayment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          const Text("Rincian Pembayaran",
              style: TextStyle(
                  fontSize: 16, height: 1.5, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left),
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  "Nama Channel: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(height: 1.5),
                ),
              ),
              Expanded(
                child: Text(widget.channelName!,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.w600)),
              )
            ],
          ),
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  "Lama Berlangganan: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(height: 1.5),
                ),
              ),
              Expanded(
                child: Text(widget.duration!,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.w600)),
              )
            ],
          ),
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  "Biaya Berlangganan: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(height: 1.5),
                ),
              ),
              Expanded(
                child: Text(widget.price!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              )
            ],
          ),
          const Divider(
            color: Colors.grey,
          ),
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  "Total Pembayaran: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(height: 1.5),
                ),
              ),
              Expanded(
                child: Text(
                  widget.total!,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}