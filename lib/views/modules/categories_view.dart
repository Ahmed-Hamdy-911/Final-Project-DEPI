import 'package:bs_rashhuli/helper/helper.dart';
import 'package:bs_rashhuli/services/app_services.dart';
import 'package:bs_rashhuli/views/modules/add_places_view.dart';
import 'package:bs_rashhuli/views/modules/data_of_category_view.dart';
import 'package:bs_rashhuli/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            Color defaultColor =
                AppServices().getCategoryColor(categories[index].name);
            return OutlinedButton(
              onPressed: () {
                naviPush(context,
                    widgetName:
                        DataOfCategoryView(category: categories[index].name));
              },
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(
                    EdgeInsets.all(2).copyWith(right: 4)),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    categories[index].icon,
                    size: 35,
                    color: defaultColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    text: categories[index].name,
                    fontSize: 13,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textColor: defaultColor,
                  )
                ],
              ),
            );
          },
        ));
  }
}
