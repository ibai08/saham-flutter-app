// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../views/widgets/btnBlock.dart';
import '../../views/widgets/customDropdownButton.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

// ignore: must_be_immutable
class DialogCabang extends StatefulWidget {
  final users;
  final Map? arguments;
  String? error;
  String? errors;
  bool? login;
  bool? cekLog;

  cekLogin() {
    if (cekLog != null) {
      login = true;
    } else {
      login = false;
    }
    error = errors;
  }

  DialogCabang(this.users, this.arguments, {Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _DialogCabang();
}

class _DialogCabang extends State<DialogCabang> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    List<dynamic> users = widget.users;
    dropdownValue ??= users[0]["id"].toString();
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              margin: const EdgeInsets.only(top: Consts.avatarRadius),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(Consts.padding),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // To make the card compact
                children: <Widget>[
                  const Text(
                    "Pilih Cabang",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  DropdownWithLabel<String>(
                    value: dropdownValue,
                    title: "Pilih Cabang",
                    label: "Pilih Cabang",
                    onChange: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: users.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value["id"].toString(),
                        child: Text(value["cabang_city"]),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24.0),
                  BtnBlock(
                    title: "Login",
                    onTap: () async {
                      try {
                        widget.cekLog = true;
                        await performLogin(users);
                      } catch (xerr) {
                        print(xerr);
                        widget.cekLog = null;
                        widget.errors = xerr.toString();
                      }
                      // Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Future<bool> performLogin(List<dynamic> users) async {
    for (int i = 0; i < users.length; i++) {
      if (dropdownValue == users[i]["id"].toString()) {
        String jwtToken = users[i]["result"];
        String enc = users[i]["enc"];
        Map user = users[i];
        user.remove("result");
        user.remove("enc");
        bool ul = await UserModel.instance.setUserLogin(
            jwtToken, enc, jsonEncode(user),
            arguments: widget.arguments);
        if (ul) {
          return true;
        } else {
          return false;
        }
      }
    }
    throw Exception("PLEASE_LOGIN_AGAIN");
  }
}
