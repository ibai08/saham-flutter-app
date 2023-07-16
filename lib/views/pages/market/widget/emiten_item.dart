import 'package:flutter/material.dart';
import 'package:tradersfamily_app/config/const.dart';

class EmitenItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only( bottom: 10),
        ),
        Container(
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // padding: EdgeInsets.symmetric(horizontal: 10),
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                // ITEM 1
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
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
                              SizedBox(width: 8),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ASLC',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Manrope'
                                      ),
                                    ),
                                    Text(
                                      'Autopedia Sukses Lestari Tbk.',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Manrope'
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 95,),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
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
                                        color: ConstColor.textGreenLight
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
              SizedBox(width: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
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
                              SizedBox(width: 8),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                              SizedBox(width: 135,),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
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
                                        color: ConstColor.textGreenLight
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
              SizedBox(width: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
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
                              SizedBox(width: 8),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                              SizedBox(width: 110,),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
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
                                        color: ConstColor.textGreenLight
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
              // ITEM 4
              SizedBox(width: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
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
                              SizedBox(width: 8),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                              SizedBox(width: 125,),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
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
                                        color: ConstColor.accentRed
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
              SizedBox(width: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 45,
                                child: CircleAvatar(
                                  child: Image.asset(
                                    'assets/slis.png',
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                              SizedBox(width: 110,),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
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
                                        color: ConstColor.textGrayLight
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