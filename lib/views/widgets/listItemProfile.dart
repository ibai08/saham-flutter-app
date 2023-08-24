import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ListItemSettings extends StatelessWidget {
  const ListItemSettings({
    Key? key,
    this.context,
    this.link,
    this.text,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final BuildContext? context;
  final String? text;
  final Widget? icon;
  final String? link;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        onTap!();
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: AppColors.lightGrey, width: 1))),
          child: ListTile(
            title: Text(text!, style: const TextStyle(fontSize: 16)),
            leading:
                Container(margin: const EdgeInsets.only(left: 7), child: icon),
          )),
    );
  }
}
