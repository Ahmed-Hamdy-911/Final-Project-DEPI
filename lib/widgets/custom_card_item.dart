import 'package:bs_rashhuli/helper/helper.dart';
import 'package:bs_rashhuli/views/modules/place_details_view.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../constants/colors.dart';
import 'custom_text.dart';
import 'star_rating_widget.dart';

class CustomItemCard extends StatelessWidget {
  final String placeId;
  final String? imageUrl;
  final String placeName;
  final String placeLocation;
  final double? rating;
  final int? ratingCount;

  const CustomItemCard({
    super.key,
    this.imageUrl,
    required this.placeName,
    required this.placeLocation,
    this.rating,
    this.ratingCount,
    required this.placeId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        naviPush(context, widgetName: PlaceDetailsView(placeId: placeId));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(bottom: 0, top: 5),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Card(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.21,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl ??
                              'https://st.depositphotos.com/2934765/53192/v/450/depositphotos_531920820-stock-illustration-photo-available-vector-icon-default.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 3,
                      right: 3,
                      child: GestureDetector(
                        onTap: () {
                          // Handle tap event
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white.withOpacity(0.7),
                          child: Icon(
                            IconlyLight.heart,
                            color: kMainColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: placeName,
                        fontSize: 17,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textColor: kMainColor,
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.place_outlined,
                            size: 22,
                            color: kMainColor,
                          ),
                          Expanded(
                            child: CustomText(
                              text: placeLocation,
                              fontSize: 14,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textColor: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      // if (rating != null && ratingCount != null)
                      StarRating(
                        rating: rating ?? 0.0,
                        ratingCount: ratingCount ?? 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
