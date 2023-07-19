import 'package:flutter/material.dart';

class ServiceDetail extends StatelessWidget {
  const ServiceDetail({
    Key? key,
    this.image,
    this.title,
    this.desc,
    this.action,
    this.seeMore,
  }) : super(key: key);

  final Image? image;
  final String? title;
  final String? desc;
  final Widget? action;
  final Function? seeMore;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, 0),
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          image!,
          Text(
            title!,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            desc!,
            style: const TextStyle(height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          action!,
          const SizedBox(
            height: 5,
          ),
          seeMore != null
              ? GestureDetector(
                  onTap: () {
                    seeMore!;
                  },
                  child: Text("Lihat Selengkapnya",
                      style: TextStyle(
                          color: Colors.blue[700],
                          decoration: TextDecoration.underline)),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}