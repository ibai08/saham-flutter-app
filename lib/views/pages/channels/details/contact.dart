import 'package:flutter/material.dart';
import '../../../../function/launch_url.dart';
import '../../../../models/entities/ois.dart';

// class ContactChannel extends StatefulWidget {
//   final ChannelCardSlim _channelDetail;
//   ContactChannel(this._channelDetail);
//   @override
//   _ContactChannelState createState() => _ContactChannelState();
// }

class ContactChannel extends StatelessWidget {
  final ChannelCardSlim channelDetail;
  const ContactChannel(this.channelDetail, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "Channel ini merupakan channel private, hubungi ",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                  children: <InlineSpan>[
                    TextSpan(
                      text: channelDetail.contactEmail,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(
                      text: " untuk mendapatkan TOKEN channel ini.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ]),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                String contact = Uri(
                    scheme: 'mailto',
                    path: channelDetail.contactEmail,
                    queryParameters: {
                      'subject': "Subscribe Channel ${channelDetail.name}"
                    }).toString();
                launchURL(contact);
              },
              child: const Text("Hubungi Sekarang"),
            )
          ],
        ),
      ),
    );
  }
}
