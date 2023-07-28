import 'package:flutter/material.dart';

class LabelCharts extends StatelessWidget {
  const LabelCharts({
    Key? key,
    this.text1,
    this.text2,
  }) : super(key: key);

  final String? text1;
  final String? text2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 100),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Expanded(child: SizedBox(),),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            color: Colors.blue[600],
                            width: 10,
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Text(text1!),),
                  ],
                )
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            color: Colors.red[500],
                            width: 10,
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Text(text2!),),
                  ],
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}