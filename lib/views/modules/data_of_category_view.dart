import 'package:bs_rashhuli/services/app_services.dart';
import 'package:bs_rashhuli/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/app_cubit/app_cubit.dart';
import '../../cubits/app_cubit/app_states.dart';
import '../../widgets/custom_card_item.dart';

class DataOfCategoryView extends StatefulWidget {
  const DataOfCategoryView({super.key, required this.category});
  final String category;
  @override
  State<DataOfCategoryView> createState() => _DataOfCategoryViewState();
}

class _DataOfCategoryViewState extends State<DataOfCategoryView> {
  Future<void> fetchData() async {
    final appCubit = BlocProvider.of<AppCubit>(context);
    await appCubit.fetchPlacesWithCustomCategory(
      widget.category,
    ); // Trigger data fetch when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    final appCubit = BlocProvider.of<AppCubit>(context);
    return Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: widget.category,
            textColor: AppServices().getCategoryColor(widget.category),
          ),
        ),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            return BlocBuilder<AppCubit, AppStates>(
              builder: (context, state) {
                if (state is LoadingState) {
                  
                return const Center(
                  child: CircularProgressIndicator(),
                );
                } else if (state is ErrorFetchPlaceWithCategoryState) {
                  return Center(
                    child: CustomText(text: state.error.toString()),
                  );
                }
                return ListView.builder(
                    itemCount: appCubit.categoryList.length,
                    itemBuilder: (context, index) {
                      final category = appCubit.categoryList[index];
                      return CustomItemCard(
                        imageUrl: category.images!.isNotEmpty
                            ? category.images![0]
                            : null,
                        placeName: category.name,
                        placeLocation: category.location,
                        placeId: category.id,
                      );
                    },
                  );
              },
            );
          },
        ));
  }
}
