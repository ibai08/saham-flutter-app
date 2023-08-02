// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saham_01_app/constants/app_colors.dart';
import 'package:saham_01_app/controller/appStatesController.dart';
import 'package:saham_01_app/function/changeFocus.dart';
import 'package:saham_01_app/function/helper.dart';
import 'package:saham_01_app/function/removeFocus.dart';
import 'package:saham_01_app/function/showAlert.dart';
import 'package:saham_01_app/models/user.dart';
import 'package:saham_01_app/views/appbar/navtxt.dart';
import 'package:saham_01_app/views/pages/form/verifyEmail.dart';
import 'package:saham_01_app/views/widgets/btnBlock.dart';
import 'package:saham_01_app/views/widgets/dialogCabang.dart';
import 'package:saham_01_app/views/widgets/dialogConfirmation.dart';
import 'package:saham_01_app/views/widgets/dialogLoading.dart';
import 'package:saham_01_app/views/widgets/line.dart';
import 'package:saham_01_app/views/widgets/passwordIcon.dart';
import 'package:saham_01_app/views/widgets/registerHint.dart';
import 'package:saham_01_app/views/widgets/toast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  final AppStateController appStateController = Get.put(AppStateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: appStateController.users.value.id < 1
            ? Container(
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
              )
            : const SizedBox(),
        appBar: NavTxt(
          title: 'Login',
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: appStateController.users.value.id < 1 ? const LoginForm() : VerifyEmail(),
        ));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginForm();
  }
}

class _LoginForm extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _seePass = true;

  void _toggle() {
    setState(() {
      _seePass = !_seePass;
    });
  }

  Future<void> performLogin(BuildContext ctx) async {
    print("keklikk");
    removeFocus(ctx);
    DialogLoading dlg = DialogLoading();
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (ctx) {
          return dlg;
        });
    try {
      String email = _emailController.text;
      String password = _passwordController.text;
      print("email: $email");
      if (email == "" && password == "") {
        showToast(ctx, "Email dan password tidak boleh kosong", "TUTUP");
        await Future.delayed(const Duration(milliseconds: 0));
        Navigator.pop(ctx);
        return;
      }
      Map res = await UserModel.instance.login(email, password,
          arguments: ModalRoute.of(context)?.settings.arguments);
      if (res.containsKey("error")) {
        showToast(ctx, res["error"], "TUTUP");
      } else {
        if (res.containsKey("users")) {
          await Future.delayed(const Duration(milliseconds: 0));
          Navigator.pop(ctx);
          DialogCabang? dc;
          await showDialog(
              context: ctx,
              builder: (ctx) {
                dc = DialogCabang(
                    res["users"], ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?);
                return dc as Widget;
              });
          dc?.cekLogin();
          if (dc!.login! && dc!.error == null) {
            // Navigator.pop(context);
            // Navigator.popUntil(context, ModalRoute.withName("/home"));
          } else if (dc!.error != null) {
            // Navigator.pop(context);
            showToast(context, dc!.error!, "CLOSE_TOAST");
          } else {
            // Navigator.pop(context);
            showToast(context, "PLEASE_TRY_AGAIN", "CLOSE_TOAST");
          }
        } else {
          // Navigator.popUntil(context, ModalRoute.withName("/home"));
        }
      }
    } catch (x) {
      Navigator.pop(ctx);
      if (x.toString().contains("PLEASE_VERIFY_YOUR_EMAIL")) {
        if (await showDialog(
            context: context,
            builder: (context) => const DialogConfirmation(
                  title: "Email belum terverifikasi",
                  desc:
                      "Silahkan cek email Anda untuk melakukan verifikasi email atau kirim ulang email verifikasi jika belum menerima email verifikasi",
                  caps: "RESEND",
                ))) {
          Navigator.pushNamed(context, '/forms/resendverify',
              arguments: _emailController.text);
        }
      } else {
        showAlert(context, LoadingState.error, translateFromPattern(x.toString()));
      }
    }
  }

  @override
  void initState() {
    // use delay then check username if empty then redirect to edit profile
    Future.delayed(const Duration(milliseconds: 0)).then((_) {
      // print(ap);

      final usersValue = appStateController?.users.value;
      final isProfileComplete = usersValue?.isProfileComplete() ?? false;
      final verify = usersValue?.verify ?? false;

      if (usersValue?.id != null && usersValue!.id > 0) {
        if (isProfileComplete) {
          Navigator.popAndPushNamed(context, "/forms/editprofile");
        } else if (verify) {
          Navigator.popUntil(context, ModalRoute.withName("/home"));
        }
      }
    });
    super.initState();
  }

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
                  controller: _emailController,
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
                  focusNode: _emailFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    changeFocus(context, _emailFocus, _passwordFocus);
                  }),
              TextFormField(
                  key: const Key("password-field"),
                  controller: _passwordController,
                  obscureText: _seePass,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 5, top: 20),
                    suffixIcon: IconButton(
                        onPressed: () {
                          _toggle();
                        },
                        padding: const EdgeInsets.only(top: 20),
                        icon: PasswordIcon(
                          seePass: _seePass,
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
                  focusNode: _passwordFocus,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (term) async {
                    _passwordFocus.unfocus();
                    await performLogin(context);
                  }),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/forms/forgot');
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
                  await performLogin(context);
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