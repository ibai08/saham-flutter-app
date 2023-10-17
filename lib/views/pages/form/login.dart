// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/controller/homeTabController.dart';
import 'package:saham_01_app/controller/newSignalController.dart';
import 'package:saham_01_app/controller/signalTabController.dart';
import 'package:saham_01_app/views/widgets/getAlert.dart';
import '../../../constants/app_colors.dart';
import '../../../controller/appStatesController.dart';
import '../../../function/changeFocus.dart';
import '../../../function/helper.dart';
import '../../../function/removeFocus.dart';
import '../../../function/showAlert.dart';
import '../../../models/user.dart';
import '../../../views/appbar/navtxt.dart';
import '../../../views/pages/form/verifyEmail.dart';
import '../../../views/widgets/btnBlock.dart';
import '../../../views/widgets/dialogCabang.dart';
import '../../../views/widgets/dialogConfirmation.dart';
import '../../../views/widgets/line.dart';
import '../../../views/widgets/passwordIcon.dart';
import '../../../views/widgets/registerHint.dart';
import '../../../views/widgets/toast.dart';

// class Login extends StatefulWidget {
//   const Login({Key? key}) : super(key: key);

//   @override
//   _LoginState createState() => _LoginState();
// }

class Login extends StatelessWidget {
  final AppStateController appStateController = Get.find();
  final DialogController dialogController = Get.find();

  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        bottomNavigationBar: appStateController.users.value.id < 1 ? Container(
          height: 55,
          child: Column(
            children: const [
              Line(),
              SizedBox(
                height: 15,
              ),
              RegisterHint()
            ],
          ),
        ) : const SizedBox(),
        appBar: NavTxt(
          title: "Login",
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: appStateController.users.value.id < 1 ? LoginForm() : VerifyEmail(),
        ),
      );
    });
  }
}

class LoginFormController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  DialogController dialogController = Get.find();
  HomeTabController homeTabController = Get.find();
  NewHomeTabController newHomeTabController = Get.find();
  AppStateController appStateController = Get.find();
  ListChannelWidgetController listChannelWidgetController = Get.find();
  ListSignalWidgetController listSignalWidgetController = Get.find();
  NewSignalController newSignalController = Get.find();

  RxBool seePass = true.obs;

  void toggle() {
    seePass.value = false;
  }

  Future<void> performLogin(BuildContext ctx) async {
    removeFocus(ctx);
    dialogController.setProgress(LoadingState.progress, "Mohon Tunggu");
    try {
      String email = emailController.text;
      String password = passwordController.text;
      if (email == "" && password == "") {
        dialogController.showToast("Email dan password tidak boleh kosong", "TUTUP");
        Get.back();
        return;
      }
      var arguments = Get.arguments;
      Map res = await UserModel.instance.login(email, password, arguments: arguments);
      if (res.containsKey("error")) {
        dialogController.showToast(res["error"], "TUTUP");
      } else  {
        if (res.containsKey("users")) {
          await Future.delayed(Duration(milliseconds: 0));
          Navigator.pop(ctx);
          DialogCabang? dc;
          await showDialog(
              context: ctx,
              builder: (ctx) {
                dc = DialogCabang(
                    res["users"],
                    ModalRoute.of(ctx)?.settings.arguments
                        as Map<dynamic, dynamic>?);
                return dc as Widget;
              });
          dc?.cekLogin();
          if (dc?.login == true && dc?.error == null) {
            // Navigator.pop(context);
            // Navigator.popUntil(context, ModalRoute.withName("/home"));
          } else if (dc?.error != null) {
            // Navigator.pop(context);
            // showToast(context, dc.error, "CLOSE_TOAST");
            dialogController.showToast(dc!.error!, "CLOSE TOAST");
          } else {
            // Navigator.pop(context);
            dialogController.showToast("PLEASE TRY AGAIN", "CLOSE TOAST");
          }
        } else {
          // Navigator.popUntil(context, ModalRoute.withName("/home"));
          listChannelWidgetController.initializePageChannelAsync();
          listSignalWidgetController.initializePageSignalAsync();
          newSignalController.initializePageChannelAsync();
          homeTabController.onRefresh();
          if (ModalRoute.of(Get.context!)?.settings.name != "/home") {
            Get.until((route) => route.settings.name == "/home");
            newHomeTabController.tab.value = HomeTab.home;
            newHomeTabController.tabController.animateTo(0,duration: const Duration(milliseconds: 200),curve:Curves.easeIn);
          }
          dialogController.setProgress(LoadingState.success, "Login Berhasil");
          emailController.text = "";
          passwordController.text = "";
        }
      }
    } catch (ex) {
      Get.back();
      if (ex.toString().contains("PLEASE_VERIFY_YOUR_EMAIL")) {
        if (await showDialog(
            context: Get.context!,
            builder: (context) => const DialogConfirmation(
                  title: "Email belum terverifikasi",
                  desc:
                      "Silahkan cek email Anda untuk melakukan verifikasi email atau kirim ulang email verifikasi jika belum menerima email verifikasi",
                  caps: "RESEND",
                ))) {
          // Navigator.pushNamed(context, '/forms/resendverify',
          //     arguments: _emailController.text);
          Get.toNamed("/forms/resendverify", arguments: emailController.text);
        }
      } else {
        // showAlert(
        //     context, LoadingState.error, translateFromPattern(x.toString()));
        dialogController.setProgress(LoadingState.error, translateFromPattern(ex.toString()));
      }
    }
  }

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 0)).then((_) {
      if (appStateController.users.value.id > 0) {
        if (appStateController.users.value.isProfileComplete() == false) {
          Get.offAndToNamed("/forms/editprofile");
        } else if (appStateController.users.value.verify == true) {
          Get.until((route) => route.settings.name == "/home");
        }
      }
    });
    super.onInit();
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super(key: key);

  final LoginFormController controller = Get.put(LoginFormController());
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white3,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                  autocorrect: false,
                  key: const Key("email-field"),
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    labelText: 'Email atau Username',
                    labelStyle: TextStyle(color: AppColors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.2,
                        color: AppColors.darkGrey4,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  focusNode: controller.emailFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    changeFocus(context, controller.emailFocus, controller.passwordFocus);
                  }),
              TextFormField(
                  key: const Key("password-field"),
                  controller: controller.passwordController,
                  obscureText: controller.seePass.value,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.toggle();
                        },
                        padding: const EdgeInsets.only(top: 20),
                        icon: PasswordIcon(
                          seePass: controller.seePass.value,
                        )),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: AppColors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.2,
                        color: AppColors.darkGrey4,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  focusNode: controller.passwordFocus,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (term) async {
                    controller.passwordFocus.unfocus();
                    await controller.performLogin(context);
                  }),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, '/forms/forgot');
                    Get.toNamed("/forms/forgot");
                  },
                  child: Text(
                    "Lupa Password?",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              BtnBlock(
                onTap: () async {
                  await controller.performLogin(context);
                },
                title: "MASUK",
              ),
              const SizedBox(
                height: 20,
              ),
              // TextAccent(
              //   title: "Atau",
              // ),
              // Container(
              //   margin: EdgeInsets.only(top: 20),
              //   child: BtnBlock(
              //     onTap: () {
              //       Navigator.pushNamed(
              //         context,
              //         '/forms/login/mt4',
              //       );
              //     },
              //     isWhite: true,
              //     icon: Image.asset(
              //       'assets/icon/brands/mt4.png',
              //       width: 25,
              //     ),
              //     title: "Sign in with Metatrader 4",
              //   ),
              // ),
              // LoginWithGoogleButton(),
            ],
          ),
        ],
      ),
    );
  }
}

// class _LoginState extends State<Login> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   final AppStateController appStateController = Get.find();
//   final DialogController dialogController = Get.put(DialogController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         bottomNavigationBar: appStateController.users.value.id < 1
//             ? Container(
//                 height: 55,
//                 child: Column(
//                   children: const [
//                     Line(),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     RegisterHint()
//                   ],
//                 ),
//               )
//             : const SizedBox(),
//         appBar: NavTxt(
//           title: 'Login',
//         ),
//         body: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).requestFocus(FocusNode());
//           },
//           child: appStateController.users.value.id < 1
//               ? const LoginForm()
//               : VerifyEmail(),
//         ));
//   }
// }

// class LoginForm extends StatefulWidget {
//   const LoginForm({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _LoginForm();
//   }
// }

// class _LoginForm extends State<LoginForm> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   DialogController dialogController = Get.find();
//   HomeTabController homeTabController = Get.find();
//   NewHomeTabController newHomeTabController = Get.find();

//   final FocusNode _emailFocus = FocusNode();
//   final FocusNode _passwordFocus = FocusNode();

//   bool _seePass = true;

//   void _toggle() {
//     setState(() {
//       _seePass = !_seePass;
//     });
//   }

//   Future<void> performLogin(BuildContext ctx) async {
//     print("keklikk");
//     removeFocus(ctx);
//     // DialogLoading dlg = DialogLoading();
//     // showDialog(
//     //     barrierDismissible: false,
//     //     context: ctx,
//     //     builder: (ctx) {
//     //       return dlg;
//     //     });
//     dialogController.setProgress(LoadingState.progress, "Mohon Tunggu");
//         print("sebleum");
//     try {
//       String email = _emailController.text;
//       String password = _passwordController.text;
//       print("email: $email");
//       if (email == "" && password == "") {
//         print("kenas");
//         showToast(ctx, "Email dan password tidak boleh kosong", "TUTUP");
//         await Future.delayed(const Duration(milliseconds: 0));
//         Navigator.pop(ctx);
//         return;
//       }
//       print("sebelum resi");
//       print("atas ansj: ${ModalRoute.of(context)?.settings.arguments}");
//       Map res = await UserModel.instance.login(email, password,
//           arguments: ModalRoute.of(context)?.settings.arguments);
//           print("ressss: $res");
//       if (res.containsKey("error")) {
//         showToast(ctx, res["error"], "TUTUP");
//       } else {
//         if (res.containsKey("users")) {
//           await Future.delayed(const Duration(milliseconds: 0));
//           Navigator.pop(ctx);
//           DialogCabang? dc;
//           await showDialog(
//               context: ctx,
//               builder: (ctx) {
//                 dc = DialogCabang(
//                     res["users"],
//                     ModalRoute.of(context)?.settings.arguments
//                         as Map<dynamic, dynamic>?);
//                 return dc as Widget;
//               });
//           dc?.cekLogin();
//           if (dc!.login! && dc!.error == null) {
//             // Navigator.pop(context);
//             print("CSDFFS");
//             // Navigator.popUntil(context, ModalRoute.withName("/home"));
//           } else if (dc!.error != null) {
//             // Navigator.pop(context);
//             print("CLOSTE");
//             showToast(context, dc!.error!, "CLOSE_TOAST");
//           } else {
//             // Navigator.pop(context);
//             print("TRY AGAIN");
//             showToast(context, "PLEASE_TRY_AGAIN", "CLOSE_TOAST");
//           }
//         } else {
//           // Navigator.popUntil(context, ModalRoute.withName("/home"));
//           // print("kennaksdjsdjhsdjfh");
//           // showAlert(context, LoadingState.success, "LOGIN SUCCESS");
//           print("rute sekarang: ${ModalRoute.of(context)?.settings.name}");
//           if (ModalRoute.of(context)?.settings.name != "/home") {
//             print("kena ini dong harusnya");
//             // appStateController?.setAppState(Operation.bringToHome, HomeTab.home);
//             Get.until((route) => route.settings.name == "/home");
//             newHomeTabController.tab.value = HomeTab.home;
//             newHomeTabController.tabController.animateTo(0,duration: Duration(milliseconds: 200),curve:Curves.easeIn);
//           }
//           print("LOGIN SUCCESS");
//           dialogController.setProgress(LoadingState.success, "Login Berhasil");

//         }
//       }
//     } catch (x) {
//       print("kena sinsis");
//       Navigator.pop(ctx);
//       if (x.toString().contains("PLEASE_VERIFY_YOUR_EMAIL")) {
//         if (await showDialog(
//             context: context,
//             builder: (context) => const DialogConfirmation(
//                   title: "Email belum terverifikasi",
//                   desc:
//                       "Silahkan cek email Anda untuk melakukan verifikasi email atau kirim ulang email verifikasi jika belum menerima email verifikasi",
//                   caps: "RESEND",
//                 ))) {
//           Navigator.pushNamed(context, '/forms/resendverify',
//               arguments: _emailController.text);
//         }
//       } else {
//         print("kennnsjsnjd");
//         // showAlert(
//         //     context, LoadingState.error, translateFromPattern(x.toString()));
//         dialogController.setProgress(LoadingState.error, translateFromPattern(x.toString()));
        
//       }
//     }
//   }

//   @override
//   void initState() {
//     // use delay then check username if empty then redirect to edit profile
//     Future.delayed(const Duration(milliseconds: 0)).then((_) {
//       // print(ap);

//       final usersValue = appStateController?.users.value;
//       final isProfileComplete = usersValue?.isProfileComplete() ?? false;
//       final verify = usersValue?.verify ?? false;

//       if (usersValue?.id != null && usersValue!.id > 0) {
//         if (isProfileComplete) {
//           Navigator.popAndPushNamed(context, "/forms/editprofile");
//         } else if (verify) {
//           Navigator.popUntil(context, ModalRoute.withName("/home"));
//         }
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.white3,
//       width: MediaQuery.of(context).size.width,
//       child: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
//         children: <Widget>[
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               TextFormField(
//                   autocorrect: false,
//                   key: const Key("email-field"),
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
//                     labelText: 'Email atau Username',
//                     labelStyle: TextStyle(color: AppColors.black),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         width: 0.2,
//                         color: AppColors.darkGrey4,
//                       ),
//                     ),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   focusNode: _emailFocus,
//                   textInputAction: TextInputAction.next,
//                   onFieldSubmitted: (term) {
//                     changeFocus(context, _emailFocus, _passwordFocus);
//                   }),
//               TextFormField(
//                   key: const Key("password-field"),
//                   controller: _passwordController,
//                   obscureText: _seePass,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
//                     suffixIcon: IconButton(
//                         onPressed: () {
//                           _toggle();
//                         },
//                         padding: const EdgeInsets.only(top: 20),
//                         icon: PasswordIcon(
//                           seePass: _seePass,
//                         )),
//                     labelText: 'Password',
//                     labelStyle: TextStyle(color: AppColors.black),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         width: 0.2,
//                         color: AppColors.darkGrey4,
//                       ),
//                     ),
//                   ),
//                   keyboardType: TextInputType.text,
//                   focusNode: _passwordFocus,
//                   textInputAction: TextInputAction.done,
//                   onFieldSubmitted: (term) async {
//                     _passwordFocus.unfocus();
//                     await performLogin(context);
//                   }),
//               const SizedBox(
//                 height: 15,
//               ),
//               Container(
//                 width: double.infinity,
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(context, '/forms/forgot');
//                   },
//                   child: Text(
//                     "Lupa Password?",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.primaryGreen),
//                     textAlign: TextAlign.right,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               BtnBlock(
//                 onTap: () async {
//                   await performLogin(context);
//                 },
//                 title: "MASUK",
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               // TextAccent(
//               //   title: "Atau",
//               // ),
//               // Container(
//               //   margin: EdgeInsets.only(top: 20),
//               //   child: BtnBlock(
//               //     onTap: () {
//               //       Navigator.pushNamed(
//               //         context,
//               //         '/forms/login/mt4',
//               //       );
//               //     },
//               //     isWhite: true,
//               //     icon: Image.asset(
//               //       'assets/icon/brands/mt4.png',
//               //       width: 25,
//               //     ),
//               //     title: "Sign in with Metatrader 4",
//               //   ),
//               // ),
//               // LoginWithGoogleButton(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
