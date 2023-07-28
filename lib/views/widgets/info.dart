import 'package:flutter/material.dart';
import 'package:saham_01_app/constants/app_colors.dart';

class Info extends StatefulWidget {
  Info({
    this.marginTop,
    this.title,
    this.desc,
    this.image,
    this.bgColorBtn,
    this.iconButton,
    this.caption,
    this.colorCaption,
    @required this.onTap,
  });
  final double? marginTop;
  final String? title;
  final String? desc;
  final Widget? image;
  final Color? bgColorBtn;
  final Widget? iconButton;
  final String? caption;
  final Color? colorCaption;
  final Function? onTap;

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    double? marginTop = widget.marginTop;
    String? title = widget.title;
    String? desc = widget.desc;
    Widget? image = widget.image;
    Color? bgColorBtn = widget.bgColorBtn;
    Widget? iconButton = widget.iconButton;
    String? caption = widget.caption;
    Color? colorCaption = widget.colorCaption;
    Function? onTap = widget.onTap;

    if (widget.title == null) {
      title = "Tidak Ada Koneksi...";
    }
    if (widget.desc == null) {
      desc =
          "Anda kehilangan akses internet, periksa kembali Wi-Fi atau koneksi data Anda";
    }
    if (widget.image == null) {
      image = Image.asset("assets/icon-no-connections.png");
    }
    if (widget.caption == null) {
      caption = "REFRESH";
    }
    if (widget.bgColorBtn == null) {
      bgColorBtn =const Color.fromARGB(255, 187, 193, 197);
      colorCaption = AppColors.black;
    }
    if (widget.iconButton == null) {
      iconButton = Image.asset(
        "assets/icon-refresh.png",
        width: 18,
        height: 18,
      );
    }
    return Container(
        margin:
            EdgeInsets.only(bottom: 25, top: marginTop ?? 0),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            image!,
            const SizedBox(
              height: 15,
            ),
            Text(
              title!,
              textAlign: TextAlign.center,
              style:const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              desc!,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            widget.caption != " "
                ? ElevatedButton.icon(
                  onPressed: () {
                    onTap!();
                  },
                  style: ElevatedButton.styleFrom(
                      padding:const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      primary: bgColorBtn),
                  icon: iconButton!,
                  label: Text(
                    caption!,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorCaption,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
                : const Text(""),
          ],
        ));
  }
}