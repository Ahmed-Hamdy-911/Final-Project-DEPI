import 'package:bs_rashhuli/constants/colors.dart';
import 'package:bs_rashhuli/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FavouriteView extends StatelessWidget {
  const FavouriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: CustomText(
        text: "قريبا...",
        textColor: kMainColor,
      ),
    ));
  }
}
