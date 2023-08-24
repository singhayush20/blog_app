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
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://blogimagesa.blob.core.windows.net/imagecontainer/$image',
                  placeholder: (context, url) =>
                      Image.asset('images/placeholder_image.jpg'),
                  errorWidget: (context, url, error) =>
                      Image.asset('images/placeholder_image.jpg'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
