// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'package:saham_01_app/core/config.dart';
import 'package:saham_01_app/function/launchUrl.dart';

class SocialMedia extends StatelessWidget {
  const SocialMedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      padding:const EdgeInsets.symmetric(vertical: 5),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 45,
              child: TextButton(
                onPressed: () {
                  launchURL(remoteConfig.getString("link_instagram"));
                },
                child: Image.asset('assets/icon/brands/ig.png'),
              ),
            ),
            Container(
              width: 45,
              child: TextButton(
                onPressed: () {
                  launchURL(remoteConfig.getString("link_facebook"));
                },
                child: Image.asset('assets/icon/brands/fb.png'),
              ),
            ),
            Container(
              width: 45,
              child: TextButton(
                onPressed: () {
                  launchURL(remoteConfig.getString("link_youtube"));
                },
                child: Image.asset('assets/icon/brands/yt.png'),
              ),
            ),
            Container(
              width: 45,
              child: TextButton(
                onPressed: () {
                  launchURL(remoteConfig.getString("link_tiktok"));
                },
                child: Image.asset('assets/icon/brands/tt.png'),
              ),
            ),
            Container(
              width: 45,
              child: TextButton(
                onPressed: () {
                  launchURL(remoteConfig.getString("link_linkedin"));
                },
                child: Image.asset('assets/icon/brands/li.png'),
              ),
            ),
          ]));
}

class SocialMediaItem extends StatelessWidget {
  const SocialMediaItem({Key? key, this.images, this.link}) : super(key: key);
  final IconData? images;
  final String? link;

  @override
  Widget build(BuildContext context) => IconButton(
        iconSize: 24,
        icon: Icon(images),
        onPressed: () async {
          try {
            await launchURL(link);
          } catch (e) {
            print(e);
          }
        },
      );
}