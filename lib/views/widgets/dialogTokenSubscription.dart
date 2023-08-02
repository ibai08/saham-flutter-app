import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/function/helper.dart';
import 'package:saham_01_app/function/showAlert.dart';
import 'package:saham_01_app/models/entities/ois.dart';
import 'package:saham_01_app/models/ois.dart';
import 'package:saham_01_app/views/widgets/btnBlock.dart';
import 'package:saham_01_app/views/widgets/dialogLoading.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

// class DialogTokenSubscription extends GetWidget<DialogTokenSubscriptionController> {
//   final ChannelCardSlim? channel;

//   DialogTokenSubscription({Key? key, this.channel}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(25),
//       ),
//       elevation: 0.0,
//       backgroundColor: Colors.transparent,
//       child: Stack(
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//             margin: EdgeInsets.only(top: 66),
//             decoration: new BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: const Offset(0.0, 10.0),
//                 ),
//               ],
//             ),
//             child: Form(
//               key: controller.formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min, // To make the card compact
//                 children: <Widget>[
//                   Text(
//                     "Masukkan TOKEN channel",
//                     style: TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(height: 16.0),
//                   TextFormField(
//                     textAlign: TextAlign.center,
//                     controller: controller.tokenChannels,
//                     keyboardType: TextInputType.text,
//                     textInputAction: TextInputAction.next,
//                     focusNode: controller.tokenChannelsFocus,
//                     decoration: InputDecoration(
//                       hintText: "Masukkan TOKEN",
//                       labelStyle: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return "Mohon untuk mengisi TOKEN";
//                       }
//                       return null;
//                     },
//                     onFieldSubmitted: (term) {
//                       controller.submitToken();
//                     },
//                   ),
//                   SizedBox(height: 24.0),
//                   BtnBlock(
//                     title: "SUBMIT",
//                     onTap: () async {
//                       controller.submitToken();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class DialogTokenSubscription extends StatelessWidget {
  final ChannelCardSlim? channel;

  const DialogTokenSubscription({Key? key, this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _tokenChannels = TextEditingController();
    final _tokenChannelsFocus = FocusNode();

    return GetBuilder<DialogTokenSubscriptionController>(
      init: DialogTokenSubscriptionController(),
      initState: (_) {},
      builder: (controller) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                margin: const EdgeInsets.only(top: 66),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        "Masukkan TOKEN channel",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        textAlign: TextAlign.center,
                        controller: _tokenChannels,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        focusNode: _tokenChannelsFocus,
                        decoration: const InputDecoration(
                          hintText: "Masukkan TOKEN",
                          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Mohon untuk mengisi TOKEN";
                          }
                          return null;
                        },
                        onFieldSubmitted: (term) {
                          controller.submitToken(channel);
                        },
                      ),
                      const SizedBox(height: 24.0),
                      BtnBlock(
                        title: "SUBMIT",
                        onTap: () async {
                          controller.submitToken(channel);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DialogTokenSubscriptionController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tokenChannels = TextEditingController();
  final FocusNode tokenChannelsFocus = FocusNode();

  void submitToken(channel) async {
    if (formKey.currentState!.validate()) {
      DialogLoading dlg = DialogLoading();
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) {
            return dlg;
          });
      try {
        await OisModel.instance.subscribe(channel, token: tokenChannels.text);
        Get.back();
        Get.back();
        showAlert(Get.context!, LoadingState.success, "Subscribe Berhasil");
      } catch (ex) {
        Get.back();
        showAlert(Get.context!, LoadingState.error,
            translateFromPattern(ex.toString()));
      }
    }
  }

  @override
  void onClose() {
    tokenChannels.dispose();
    tokenChannelsFocus.dispose();
    super.onClose();
  }
}

// class DialogTokenSubscription extends StatefulWidget {
//   final ChannelCardSlim channel;

//   const DialogTokenSubscription({Key key, this.channel}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _DialogTokenSubscription();
// }

// class ChannelCardSlim {
// }

// class _DialogTokenSubscription extends State<DialogTokenSubscription> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   var _tokenChannels = TextEditingController();
//   final FocusNode _tokenChannelsFocus = FocusNode();

//   submitToken() async {
//     if (_formKey.currentState.validate()) {
//       DialogLoading dlg = DialogLoading();
//       showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) {
//             return dlg;
//           });
//       try {
//         await OisModel.instance
//             .subscribe(widget.channel, token: _tokenChannels.text);
//         Navigator.pop(context);
//         Navigator.pop(context);
//         showAlert(context, LoadingState.success, "Subscribe Berhasil");
//       } catch (ex) {
//         Navigator.pop(context);
//         showAlert(
//             context, LoadingState.error, translateFromPattern(ex.message));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) => Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(25),
//       ),
//       elevation: 0.0,
//       backgroundColor: Colors.transparent,
//       child: Stack(
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//             margin: EdgeInsets.only(top: 66),
//             decoration: new BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: const Offset(0.0, 10.0),
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min, // To make the card compact
//                 children: <Widget>[
//                   Text(
//                     "Masukkan TOKEN channel",
//                     style: TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(height: 16.0),
//                   TextFormField(
//                       textAlign: TextAlign.center,
//                       controller: _tokenChannels,
//                       keyboardType: TextInputType.text,
//                       textInputAction: TextInputAction.next,
//                       focusNode: _tokenChannelsFocus,
//                       decoration: InputDecoration(
//                           hintText: "Masukkan TOKEN",
//                           labelStyle: TextStyle(fontWeight: FontWeight.w600)),
//                       validator: (val) {
//                         if (val.isEmpty) {
//                           return "Mohon untuk mengisi TOKEN";
//                         }
//                         return null;
//                       },
//                       onFieldSubmitted: (term) {
//                         submitToken();
//                       }),
//                   SizedBox(height: 24.0),
//                   BtnBlock(
//                     title: "SUBMIT",
//                     onTap: () async {
//                       submitToken();
//                     },
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ));
// }
