import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomCarouselSlider extends StatelessWidget {
  const CustomCarouselSlider({
    super.key,
    required this.images,
    this.viewportFraction = 1,
    this.height,
    this.color,
  });
  final List images;
  final double? viewportFraction;
  final double? height;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    var defualtHeight = MediaQuery.of(context).size.height * 0.5;
    var defualtImage = [
      'https://st.depositphotos.com/2934765/53192/v/450/depositphotos_531920820-stock-illustration-photo-available-vector-icon-default.jpg',
    ];
    return CarouselSlider.builder(
      itemCount: images.isNotEmpty ? images.length : defualtImage.length,
      itemBuilder: (context, index, realIndex) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(0),
            image: DecorationImage(
              image: NetworkImage(
                  images.isNotEmpty ? images[index] : defualtImage[0]),
              fit: BoxFit.contain,
            ),
          ),
        );
      },
      options: CarouselOptions(
        viewportFraction: 1,
        height: height ?? defualtHeight,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(seconds: 2),
        autoPlayCurve: Curves.easeInOut,
      ),
    );
  }
}
