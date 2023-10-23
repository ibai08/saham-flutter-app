import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class UploadBtn extends StatelessWidget {
  const UploadBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(5)),
            child: const Text(
              "Upload",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        )
      ],
    );
  }
}
