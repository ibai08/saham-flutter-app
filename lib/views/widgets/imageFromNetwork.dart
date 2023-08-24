// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'defaultImage.dart';

class ImageFromNetwork extends StatefulWidget {
  final String? url;
  final Widget? defaultImage;
  final double? width;
  final double? paddingTop;

  const ImageFromNetwork(this.url,
      {Key? key, this.defaultImage, this.width, this.paddingTop})
      : super(key: key);

  @override
  _ImageFromNetworkState createState() => _ImageFromNetworkState();
}

class _ImageFromNetworkState extends State<ImageFromNetwork> {
  Widget? defaultImage;
  Widget? image;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.defaultImage == null) {
      defaultImage = const DefaultImage();
    } else {
      defaultImage = widget.defaultImage;
    }

    if (widget.url == null) {
      image = defaultImage;
    } else {
      image = CachedNetworkImage(
          imageUrl: widget.url!,
          useOldImageOnUrlChange: true,
          imageBuilder: (context, imageProvider) {
            try {
              return Container(
                width: widget.width ?? 120,
                height: widget.width ?? 120,
                margin: EdgeInsets.only(top: widget.paddingTop ?? 0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                        image: widget.url == null
                            ? defaultImage as ImageProvider
                            : imageProvider)),
              );
            } catch (oops) {
              print(oops);
            }
            return defaultImage!;
          },
          placeholder: (context, url) => Container(
              width: widget.width ?? 120,
              height: widget.width ?? 120,
              child: const CircularProgressIndicator(
                strokeWidth: 1,
              )),
          errorWidget: (context, url, error) {
            print(error);
            return defaultImage!;
          });
    }
    return image!;
  }
}
