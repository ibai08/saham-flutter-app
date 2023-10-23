// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DialogConfirmation extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const DialogConfirmation(
      {this.title, this.desc, this.action, this.caps, this.tapWidget});
  final String? title;
  final String? desc;
  final Function? action;
  final String? caps;
  final Widget? tapWidget;
  @override
  _DialogConfirmationState createState() => _DialogConfirmationState();
}

class _DialogConfirmationState extends State<DialogConfirmation> {
  @override
  Widget build(BuildContext context) {
    String? title = widget.title;
    String? desc = widget.desc;
    String? caps = widget.caps;
    Function? action = widget.action;

    if (widget.title == null) {
      title = "Konfirmasi";
    }

    if (widget.desc == null) {
      desc = "Anda yakin ingin mengkonfirmasi?";
    }

    if (widget.caps == null) {
      caps = "OK";
    }

    if (widget.action == null) {
      action = () {
        Navigator.pop(context, true);
      };
    }

    return AlertDialog(
      contentPadding:
          const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 0),
      actionsPadding: const EdgeInsets.only(bottom: 5, right: 10),
      titlePadding:
          const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        title!,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      content: Text(
        desc!,
        style: const TextStyle(color: Colors.black87, fontSize: 14),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("CANCEL",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                  fontSize: 12)),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        widget.tapWidget ??
            TextButton(
              child: Text(
                caps!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                    fontSize: 12),
              ),
              onPressed: () {
                action!();
              },
            ),
      ],
    );
  }
}
