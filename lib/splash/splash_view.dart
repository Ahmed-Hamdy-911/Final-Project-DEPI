import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:bs_rashhuli/constants/colors.dart';
import 'package:bs_rashhuli/widgets/custom_text.dart';

class SplashView extends StatelessWidget {
  // const SplashView({super.key});

  const SplashView({super.key, required this.startWidget});
  final Widget startWidget;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kMainColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Image.asset(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            "assets/images/splash_image.png",
            fit: BoxFit.contain,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: AnimatedSplashScreen(
                backgroundColor: kMainColor,
                splash: Container(
                  color: kMainColor,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/icon.png",
                        fit: BoxFit.contain,
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      CustomText(
                        text: "BNS Rashhuli",
                        customStyle: GoogleFonts.jomhuria(
                          fontSize: 55,
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                nextScreen: startWidget,
                // nextScreen: const HomeView(),
                splashIconSize: MediaQuery.of(context).size.height,
                // duration: 10000000,
                duration: 650,
                curve: Curves.bounceOut,
                splashTransition: SplashTransition.scaleTransition,
                pageTransitionType: PageTransitionType.fade,
                animationDuration: const Duration(seconds: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
