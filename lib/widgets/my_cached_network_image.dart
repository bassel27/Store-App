import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_app/controllers/error_handler.dart';
import 'package:store_app/models/constants.dart';

class MyCachedNetworkImage extends StatelessWidget with ErrorHandler {
  const MyCachedNetworkImage(this.imageUrl);
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl,
      placeholder: (context, url) => Image.asset(kPlaceHolder),
      errorWidget: (context, url, error) {
        handleException(error);
        return const Icon(Icons.error);
      },
    );
  }
}
