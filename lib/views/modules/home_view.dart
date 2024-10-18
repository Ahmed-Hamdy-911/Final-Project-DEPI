import 'package:bs_rashhuli/widgets/custom_carousel_slider.dart';
import 'package:bs_rashhuli/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../constants/colors.dart';
import '../../cubits/app_cubit/app_cubit.dart';
import '../../helper/helper.dart';
import '../../widgets/custom_card_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    fetchData(); // Trigger data fetch when the screen loads
    BlocProvider.of<AppCubit>(context).fetchBanners();
  }

  Future<void> fetchData() async {
    final appCubit = BlocProvider.of<AppCubit>(context);
    await appCubit.fetchPlaces(); // Trigger data fetch when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    final appCubit = BlocProvider.of<AppCubit>(context);

    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              CustomCarouselSlider(
                  height: MediaQuery.of(context).size.height * 0.25,
                  images: appCubit.banners
                      .map((banner) => banner['image_url'] as String)
                      .toList()),
              Divider(
                endIndent: 20,
                indent: 20,
                color: kMainColor,
              ),
              Container(
                color: Colors.grey[200],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: CustomText(
                              text: appCubit.places.length.toString() +
                                  ' اماكن موجودة',
                              textColor: kMainColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () {
                                showSnakBar(context, message: 'قريبا...');
                              },
                              label: Row(
                                children: [
                                  CustomText(
                                    text: 'تصفية',
                                    textColor: Colors.blue,
                                  ),
                                  Icon(
                                    IconlyLight.filter,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: appCubit.places.length,
                      itemBuilder: (context, index) {
                        final place = appCubit.places[index];
                        return CustomItemCard(
                          imageUrl: place.images!.isNotEmpty
                              ? place.images![0]
                              : null,
                          placeName: place.name,
                          placeLocation: place.location,
                          placeId: place.id,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
