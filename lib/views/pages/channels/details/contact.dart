import 'package:flutter/material.dart';
import 'package:saham_01_app/function/launchUrl.dart';
import 'package:saham_01_app/models/entities/ois.dart';

// class ContactChannel extends StatefulWidget {
//   final ChannelCardSlim _channelDetail;
//   ContactChannel(this._channelDetail);
//   @override
//   _ContactChannelState createState() => _ContactChannelState();
// }

class ContactChannel extends StatelessWidget {
  final ChannelCardSlim channelDetail;
  ContactChannel(this.channelDetail);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "Channel ini merupakan channel private, hubungi ",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                  children: <InlineSpan>[
                    TextSpan(
                      text: channelDetail.contactEmail,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: " untuk mendapatkan TOKEN channel ini.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                String contact = Uri(
                    scheme: 'mailto',
                    path: channelDetail.contactEmail,
                    queryParameters: {
                      'subject':
                          "Subscribe Channel ${channelDetail.name}"
                    }).toString();
                launchURL(contact);
              },
              child: Text("Hubungi Sekarang"),
            )
          ],
        ),
      ),
    );
  }
}