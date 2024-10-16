import 'package:bs_rashhuli/cubits/app_cubit/app_cubit.dart';
import 'package:bs_rashhuli/cubits/app_cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bs_rashhuli/cubits/image_cubit/image_cubit.dart';
import 'package:bs_rashhuli/widgets/image_builder_view.dart';
import 'package:bs_rashhuli/widgets/image_view.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../models/category_model.dart';
import '../../widgets/custom_set_location_widget.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_form.dart';
import '../../widgets/custom_working_hours.dart';
import '../../widgets/cutom_material_button.dart';

class AddPlacesView extends StatefulWidget {
  const AddPlacesView({super.key});

  @override
  State<AddPlacesView> createState() => _AddPlacesViewState();
}

class _AddPlacesViewState extends State<AddPlacesView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addLocationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AppCubit>(context)
        .setAddLocationController(_addLocationController);
    BlocProvider.of<ImageCubit>(context).clearImageList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        var appCubit = BlocProvider.of<AppCubit>(context);
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const CustomText(text: 'اضف مكان'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        customBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "هذه الخانة مطلوبه";
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100),
                        ],
                        minLines: 1,
                        maxLines: 2,
                        suffixIcon: const Icon(
                          Icons.text_fields,
                          color: Colors.grey,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: kMainColor.withOpacity(0.5)),
                        ),
                        hintText: "ادخل اسم المكان",
                        customHintStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Divider(
                        height: 25,
                        color: Colors.grey[300],
                        indent: 20,
                        endIndent: 20,
                        thickness: 1,
                      ),
                      CustomTextFormField(
                        customBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        controller: _descriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "هذه الخانة مطلوبه";
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100),
                        ],
                        suffixIcon: const Icon(
                          Icons.description,
                          color: Colors.grey,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: kMainColor.withOpacity(0.5)),
                        ),
                        minLines: 1,
                        maxLines: 3,
                        hintText: "ادخل وصف المكان (يفضل وضع وصف دقيق للمكان).",
                        customHintStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Divider(
                        height: 25,
                        color: Colors.grey[300],
                        indent: 20,
                        endIndent: 20,
                        thickness: 1,
                      ),
                      CustomSetLocationWidget(
                        addLocationController: _addLocationController,
                        regions: regions,
                      ),
                      Divider(
                        height: 25,
                        color: Colors.grey[300],
                        indent: 20,
                        endIndent: 20,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomText(text: "اختار الفئة"),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              style: BorderStyle.solid,
                              width: 0.5,
                              color: kMainColor.withOpacity(0.5),
                            )),
                        child: DropdownButton<Category>(
                          underline: CustomText(text: ""),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          isExpanded: true,
                          value: appCubit.selectedCategory,
                          hint: CustomText(text: "اختيار"),
                          onChanged: (Category? newValue) {
                            appCubit.setCategory(newValue!);
                          },
                          items: categories.map((Category category) {
                            return DropdownMenuItem<Category>(
                              value: category,
                              child: Row(
                                children: [
                                  Icon(category.icon,
                                      color: Colors.teal), // Display the icon.
                                  const SizedBox(
                                      width:
                                          10), // Space between icon and text.
                                  Text(category
                                      .name), // Display the category name.
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Divider(
                        height: 25,
                        color: Colors.grey[300],
                        indent: 20,
                        endIndent: 20,
                        thickness: 1,
                      ),
                      CustomWorkingHours(),
                      Divider(
                        height: 25,
                        color: Colors.grey[300],
                        indent: 20,
                        endIndent: 20,
                        thickness: 1,
                      ),
                      Builder(builder: (context) {
                        return const Column(
                          children: [
                            ImageView(),
                            SizedBox(
                              height: 15,
                            ),
                            ImageBuilderView(),
                          ],
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 15,
                        color: Colors.grey[300],
                        indent: 20,
                        endIndent: 20,
                        thickness: 1,
                      ),
                      CustomMaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // await appCubit.uploadImagesToCloudStorage();
                            await appCubit.addNewPlace(context,
                                name: _titleController.text,
                                description: _descriptionController.text,
                                location: _addLocationController.text,
                                category: appCubit.selectedCategory!.name,
                                images: BlocProvider.of<ImageCubit>(context)
                                    .images);
                          }
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        widget: state is LoadingAppState
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const CustomText(
                                text: "اضافة",
                                textColor: Colors.white,
                                fontSize: 17,
                              ),
                        color: kMainColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final List<Category> categories = [
  Category(name: 'طعام', icon: Icons.fastfood),
  Category(name: 'الدراسة و العمل', icon: Icons.school),
  Category(name: 'الإقامة', icon: Icons.home),
  Category(name: 'الصحة', icon: Icons.health_and_safety),
  Category(name: 'النقل والمواصلات', icon: Icons.directions_bus),
  Category(name: 'الترفيه و التسلية', icon: Icons.movie),
  Category(name: 'التسوق و الاحتياجات', icon: Icons.shopping_cart),
  Category(name: 'خدمات الطلاب', icon: Icons.support),
  Category(name: 'البنوك و الشؤون المالية', icon: Icons.account_balance),
  Category(name: 'الفعاليات و الأنشطة', icon: Icons.event),
  Category(name: 'اماكن للعبادة', icon: Icons.place_outlined),
  Category(name: 'التكنولوجيا و الدعم', icon: Icons.computer),
  Category(name: 'السلامة و خدمات الطوارئ', icon: Icons.local_police),
  Category(name: "غير ذلك", icon: Icons.more_horiz)
];
