// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

class EmitenItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only( bottom: 10),
        ),
        Container(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // padding: EdgeInsets.symmetric(horizontal: 10),
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 10),
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(const Radius.circular(8)),
                ),
                // ITEM 1
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 45,
                                child: CircleAvatar(
                                  child: Image.asset(
                                    'assets/aslc.png',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'ASLC',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Manrope'
                                      ),
                                    ),
                                    const Text(
                                      'Autopedia Sukses Lestari Tbk.',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Manrope'
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 95,),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      '101',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Manrope'
                                      ),
                                    ),
                                    Text(
                                      '+2(+2.02%)',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Manrope',
                                        color: AppColors.textGreenLight
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // ITEM 2
              const SizedBox(width: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 10),
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 45,
                                child: CircleAvatar(
                                  child: Image.asset(
                                    'assets/kayu.png',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'KAYU',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Manrope'
                                      ),
                                    ),
                                    Text(
                                      'Darmi Bersaudara Tbk.',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Manrope'
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 135,),
                              // ignore: avoid_unnecessary_containers
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      '107',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Manrope'
                                      ),
                                    ),
                                    Text(
                                      '+1(0.94%)',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Manrope',
                                        color: AppColors.textGreenLight
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // ITEM 3
              const SizedBox(width: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 10),
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 45,
                                child: CircleAvatar(
                                  child: Image.asset(
                                    'assets/dild.png',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'DILD',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Manrope'
                                      ),
                                    ),
                                    Text(
                                      'Intiland Development Tbk.',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Manrope'
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 110,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    '264',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Manrope'
                                    ),
                                  ),
                                  Text(
                                    '+6(+2.33%)',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Manrope',
                                      color: AppColors.textGreenLight
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // ITEM 4
              const SizedBox(width: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 10),
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 45,
                                child: CircleAvatar(
                                  child: Image.asset(
                                    'assets/dooh.png',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'DOOH',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Manrope'
                                      ),
                                    ),
                                    Text(
                                      'Era Media Sejahtera Tbk.',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Manrope'
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 125,),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      '73',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Manrope'
                                      ),
                                    ),
                                    Text(
                                      '-1(-1.35%)',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Manrope',
                                        color: AppColors.accentRed
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // ITEM 5
              const SizedBox(width: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 10),
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // ignore: sized_box_for_whitespace
                              Container(
                                width: 45,
                                child: CircleAvatar(
                                  child: Image.asset(
                                    'assets/slis.png',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'SLIS',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Manrope'
                                      ),
                                    ),
                                    Text(
                                      'Gaya Abadi Sempurna Tbk.',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Manrope'
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 110,),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      '162',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Manrope'
                                      ),
                                    ),
                                    Text(
                                      '+0(+0.00%)',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Manrope',
                                        color: AppColors.textGrayLight
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}