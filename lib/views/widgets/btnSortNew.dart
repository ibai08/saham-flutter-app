import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class SortButtonNew extends StatelessWidget {
  SortButtonNew({
    Key? key,
    @required this.text,
    @required this.onTap,
    this.isActive = false,
  }) : super(key: key) {
    isActives?.value = isActive!;
  }

  final String? text;
  final Function? onTap;
  final bool? isActive;

  final RxBool? isActives = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.only(right: 10),
        child: TextButton(
          onPressed: () {
            onTap!();
            print("test boolean: ${isActives?.value}");
          },
          child: Text(
            text! ,
             style: TextStyle(
              color: isActives?.value != false ? Colors.black : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: isActives?.value != false ? const Color.fromRGBO(46, 42, 255, 0.5) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isActives?.value != false ? const Color.fromRGBO(53, 6, 153, 1.0) : Colors.grey,
                width: 1
              )
            )
          ),
        ),
      );},
    );
  }
}