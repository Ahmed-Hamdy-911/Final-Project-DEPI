import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import 'custom_text.dart';

class AppLogoWithName extends StatelessWidget {
  const AppLogoWithName({
    super.key,
    this.defualtColor = kMainColor,
  });
  final Color defualtColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.2, vertical: 20),
      child: Column(
        children: [
          Image.asset(
            "assets/icons/icon.png",
            fit: BoxFit.contain,
            height: 75,
            width: 75,
          ),
          CustomText(
            text: "BNS Rashhuli",
            customStyle: GoogleFonts.jomhuria(
              fontSize: 50,
              color: kMainColor,
              // fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
