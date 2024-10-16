import 'package:bs_rashhuli/constants/colors.dart';
import 'package:bs_rashhuli/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

import '../../cubits/app_cubit/app_cubit.dart';
import '../../cubits/app_cubit/app_states.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    final appCubit = BlocProvider.of<AppCubit>(context);
    appCubit.fetchPlaces(); // Trigger data fetch when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    final appCubit = BlocProvider.of<AppCubit>(context);

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        if (state is LoadingAppState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SuccessfulFetchPlaceState) {
          if (appCubit.places.isEmpty) {
            return Center(child: CustomText(text: "No places found"));
          }

          return ListView.builder(
            itemCount: appCubit.places.length,
            itemBuilder: (context, index) {
              final place = appCubit.places[index];
              return CustomItemCard(
                imageUrl: place.images!.isNotEmpty ? place.images![0] : '',
                placeName: place.name,
                placeLocation: place.location ?? 'No location available',
              );
            },
          );
        } else if (state is ErrorFetchPlaceState) {
          return Center(child: CustomText(text: "Error: ${state.error}"));
        }
        return SizedBox();
      },
    );
  }
}

class CustomItemCard extends StatelessWidget {
  final String imageUrl;
  final String placeName;
  final String placeLocation;
  final double? rating;
  final int? ratingCount;

  const CustomItemCard({
    super.key,
    required this.imageUrl,
    required this.placeName,
    required this.placeLocation,
    this.rating,
    this.ratingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        image: NetworkImage(imageUrl),
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
    );
  }
}

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
