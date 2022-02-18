import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shop/models/home_model.dart';

class HomeCarouselSlider extends StatelessWidget {
  const HomeCarouselSlider({Key? key, required this.banners}) : super(key: key);

  final List<Banners> banners;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: banners
          .map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: '${e.image}',
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ))
          .toList(),
      options: CarouselOptions(
        aspectRatio: 2,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        autoPlay: true,
      ),
    );
  }
}
