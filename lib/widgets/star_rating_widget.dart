import 'package:flutter/material.dart';
import 'custom_text.dart';


class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.color = Colors.amber,
    this.iconSize = 20,
    required this.ratingCount,
  });
  final double rating;
  final int ratingCount;
  final int starCount;
  final Color color;
  final double iconSize;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List.generate(
            starCount,
            (index) {
              return Icon(
                index < rating.roundToDouble() ? Icons.star : Icons.star_border,
                color: color,
                size: iconSize,
              );
            },
          ),
        ),
        const SizedBox(width: 5),
        CustomText(
          text:
              rating.toStringAsFixed(1), // Format the rating to 1 decimal place
          fontSize: 14,
          fontWeight: FontWeight.bold,
          textColor: Colors.black,
        ),
        const SizedBox(width: 5),
        CustomText(
          text: '($ratingCount) تقييم',
          fontSize: 12,
          textColor: Colors.grey,
        ),
      ],
    );
  }
}
