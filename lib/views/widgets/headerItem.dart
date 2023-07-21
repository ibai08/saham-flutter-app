import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderItem extends StatelessWidget {
  const HeaderItem({
    Key? key,
    this.images,
    this.title,
    this.link,
    this.icon,
    this.onTap,
  }) : super(key: key);
  final String? images;
  final String? title;
  final String? link;
  final Widget? icon;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double fontSize = 11;
    double letterSpacing = 0;
    double width = 84;
    double sizedSize = 5;
    if (queryData.size.width < 380) {
      fontSize = 10;
      letterSpacing = 0;
      width = 60;
      sizedSize = 0;
    }
    return GestureDetector(
      // onTap: onTap == null
      //     ? () {
      //         Navigator.pushNamed(context, link);
      //       }
      //     : onTap,
      onTap: () {
        onTap == null ? Get.toNamed(link!) : onTap!();
      },
      child: Container(
        color: Colors.transparent,
        width: width,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: sizedSize == 5 && icon != null ? 2 : 6,
            ),
            icon ?? Image.asset(
                    images!,
                    width: 31,
                    height: 31,
                    fit: BoxFit.contain,
                  ),
            SizedBox(
              height: icon == null ? 8 : sizedSize,
            ),
            Text(
              title!,
              softWrap: false,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
                  letterSpacing: letterSpacing),
            )
          ],
        ),
      ),
    );
  }
}