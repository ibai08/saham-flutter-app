import 'package:flutter/material.dart';
import 'package:saham_01_app/views/widgets/imageFromNetwork.dart';

class ChannelAvatar extends StatelessWidget {
  ChannelAvatar({this.width, this.imageUrl});
  final double width;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    Widget defaultImage = Container(
        width: width ?? 40,
        height: width ?? 40,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/default-channel-icon.jpg"))));
    return imageUrl != null
        ? ImageFromNetwork(
            imageUrl,
            width: width ?? 40,
            defaultImage: defaultImage,
          )
        : defaultImage;
  }
}