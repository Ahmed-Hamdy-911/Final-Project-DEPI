import 'package:bs_rashhuli/constants/colors.dart';
import 'package:bs_rashhuli/cubits/app_cubit/app_cubit.dart';
import 'package:bs_rashhuli/cubits/app_cubit/app_states.dart';
import 'package:bs_rashhuli/models/place_details_model.dart';
import 'package:bs_rashhuli/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/constants.dart';
import '../../widgets/custom_carousel_slider.dart';
import '../../widgets/custom_text.dart';

class PlaceDetailsView extends StatefulWidget {
  const PlaceDetailsView({
    super.key,
    required this.placeId,
  });
  final String placeId;

  @override
  State<PlaceDetailsView> createState() => _PlaceDetailsViewState();
}

class _PlaceDetailsViewState extends State<PlaceDetailsView> {
  @override
  void initState() {
    super.initState();
    // Fetch the place details when the view is initialized
    context.read<AppCubit>().fetchPlaceDetails(placeId: widget.placeId);
  }

  @override
  Widget build(BuildContext context) {
    var place = BlocProvider.of<AppCubit>(context).placeDetailsModel;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: ' التفاصيل',
          textColor: kMainColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the place image if available
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomCarouselSlider(images: place!.images!),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.05),
                          Colors.white.withOpacity(0.5),
                          Colors.white,
                          Colors.white,
                        ])),
                  )
                ],
              ),
              // Display the place name
              CustomText(
                text: place.name,
                textColor: kMainColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 16),
              // Display the place description
              CustomText(
                text: place.description,
                fontSize: 16,
                textColor: Colors.grey[600],
              ),
              SizedBox(height: 16),
              // Display the location
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_pin, color: kMainColor, size: 18),
                      CustomText(
                        text: "الموقع: ",
                        textColor: Colors.black,
                        fontSize: 18,
                      ),
                    ],
                  ),
                  CustomText(
                    text: place.location,
                    fontSize: 15,
                    textColor: Colors.grey[700],
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Display the category
              Row(
                children: [
                  Icon(Icons.category, color: kMainColor, size: 18),
                  CustomText(
                    text: 'الفئة: ',
                    textColor: Colors.black,
                    fontSize: 18,
                  ),
                  Expanded(
                    child: CustomText(
                      text: place.category,
                      textColor: AppServices().getCategoryColor(place.category),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Icon(Icons.access_time, color: kMainColor, size: 18),
                  CustomText(
                    text: 'ساعات العمل: ',
                    textColor: Colors.black,
                    fontSize: 18,
                  ),
                  if (place.fixedHours == null && place.variableHours == null)
                    Expanded(
                      child: CustomText(
                        text: 'لا يوجد',
                        textColor: Colors.grey[700],
                      ),
                    ),
                ],
              ),

              DataTable(
                columns: [
                  DataColumn(label: Text('اليوم')),
                  DataColumn(label: Text('من')),
                  DataColumn(label: Text('إلى')),
                ],
                showBottomBorder: true,
                rows: [
                  if (place.fixedHours != null)
                    DataRow(cells: [
                      DataCell(
                          CustomText(fontSize: 14, text: 'جميع ايام الاسبوع ')),
                      DataCell(CustomText(
                        text: place.fixedHours!.fromTime.toString(),
                        fontSize: 13,
                      )),
                      DataCell(CustomText(
                        text: place.fixedHours!.toTime.toString(),
                        fontSize: 13,
                      )),
                    ]),
                  if (place.variableHours != null &&
                      place.variableHours!.isNotEmpty)
                    ...List<DataRow>.generate(
                      place.variableHours!.length,
                      (index) {
                        return DataRow(cells: [
                          DataCell(CustomText(
                            text: daysOfWeek[index], // Show day of the week
                            fontSize: 14,
                          )),
                          DataCell(CustomText(
                            text: place.variableHours![index].isVacation
                                ? 'اجازة'
                                : place.variableHours![index].fromTime
                                    .toString(),
                            fontSize: 13,
                          )),
                          DataCell(CustomText(
                            text: place.variableHours![index].isVacation
                                ? ''
                                : place.variableHours![index].toTime.toString(),
                            fontSize: 13,
                          )),
                        ]);
                      },
                    ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Divider(
                endIndent: 20,
                indent: 20,
                color: kMainColor,
              ),
              CustomText(
                text: 'اماكن ذات صلة',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                textColor: AppServices().getCategoryColor(place.category),
              ),
              Center(
                child: CustomText(text: "لا يوجد اماكن لهذه الفئة بعد !"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowSomeCategoriesOnPlaceDetailsView extends StatefulWidget {
  const ShowSomeCategoriesOnPlaceDetailsView({
    super.key,
    required this.place,
  });

  final PlaceDetailsModel place;

  @override
  State<ShowSomeCategoriesOnPlaceDetailsView> createState() =>
      _ShowSomeCategoriesOnPlaceDetailsViewState();
}

class _ShowSomeCategoriesOnPlaceDetailsViewState
    extends State<ShowSomeCategoriesOnPlaceDetailsView> {
  Future<void> fetchData() async {
    final appCubit = BlocProvider.of<AppCubit>(context);
    await appCubit.fetchPlacesWithCustomCategory(
      widget.place as String,
    ); // Trigger data fetch when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        if (state is SuccessfulFetchPlaceWithCategoryState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: BlocProvider.of<AppCubit>(context).categoryList.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.105,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  BlocProvider.of<AppCubit>(context)
                                      .categoryList[index]
                                      .images![0]),
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: CustomText(
                          text: BlocProvider.of<AppCubit>(context)
                              .categoryList[index]
                              .name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                          textColor: AppServices()
                              .getCategoryColor(widget.place.category),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        }
        return Center(
          child: CustomText(text: "لا يوجد اماكن لهذه الفئة بعد !"),
        );
      },
    );
  }
}
