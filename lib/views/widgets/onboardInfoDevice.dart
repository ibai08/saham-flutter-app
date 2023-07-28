// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class OnBoardInfoDevice extends StatelessWidget {
  final double? opacity;
  final String? imagePop;
  final double? align;
  final String? dText;
  const OnBoardInfoDevice({
    Key? key,
    this.opacity,
    this.imagePop,
    this.align,
    this.dText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: MediaQuery.of(context).size.height * 0.16,
                    child: AnimatedOpacity(
                        opacity: opacity!,
                        duration: const Duration(seconds: 1),
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.35,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Image.asset(
                            imagePop!,
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 45,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: opacity!,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  dText!,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightGreen,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}