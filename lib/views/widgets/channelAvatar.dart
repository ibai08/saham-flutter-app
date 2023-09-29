import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../views/widgets/imageFromNetwork.dart';

class ChannelAvatar extends StatelessWidget {
  const ChannelAvatar({Key? key, this.width, this.imageUrl}) : super(key: key);
  final double? width;
  final String? imageUrl;
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
    return imageUrl != null && imageUrl != ""
        ? ImageFromNetwork(
            imageUrl,
            width: width ?? 40,
            defaultImage: defaultImage,
          )
        : defaultImage;
    // return CachedNetworkImage(
    //   imageUrl: "https://gssc.esa.int/navipedia/images/a/a9/Example.jpg",
    //   cacheKey: DateTime.now().toString(),
    //   progressIndicatorBuilder: (context, b, s) {
    //     return CircularProgressIndicator();
    //   },
    //   errorWidget: (context, b, s) {
    //     return defaultImage;
    //   },
    // );
  }
}
