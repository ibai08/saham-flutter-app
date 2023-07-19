import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class RegisterHint extends StatefulWidget {
  const RegisterHint({Key? key}) : super(key: key);

  @override
  State<RegisterHint> createState() => _RegisterHintState();
}

class _RegisterHintState extends State<RegisterHint> {
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Belum punya akun? ",
        style: const TextStyle(
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pushNamed(context, '/forms/register',
                    arguments: ModalRoute.of(context)?.settings.arguments),
              text: "Daftar Sekarang",
              style: TextStyle(
                  decorationThickness: 1,
                  decorationColor: AppColors.primaryGreen,
                  decorationStyle: TextDecorationStyle.solid,
                  decoration: TextDecoration.underline,
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}