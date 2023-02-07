import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotoPreview extends StatelessWidget {
  String image;
  PhotoPreview({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: CachedNetworkImage(
              imageUrl:
                  'https://imagedbspringboot.blob.core.windows.net/imagecontainer/$image',
              placeholder: (context, url) =>
                  Image.asset('images/category_default.jpg'),
              errorWidget: (context, url, error) =>
                  Image.asset('images/category_default.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}
