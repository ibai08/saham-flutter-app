import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class LoginHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Sudah punya akun? ",
        style: TextStyle(
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pushNamed(context, '/forms/login',
                    arguments: ModalRoute.of(context)?.settings.arguments),
              text: "Log In",
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