import 'package:bs_rashhuli/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bs_rashhuli/views/auth/login_view.dart';

import '../cache/cache_helper.dart';

class AppServices {
  void getStartAction(
    context, {
    required PageController pageController,
    required bool isLastPage,
  }) {
    pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
    if (isLastPage) {
      CacheHelper.saveData(
        key: "onBoardingFinished",
        value: true,
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false);
    } else {
      CacheHelper.saveData(
        key: "onBoardingFinished",
        value: false,
      );
    }
    // log(CacheHelper.getData(key: "onBoardingFinished").toString());
  }

  void skipAndFinished(BuildContext context,
      {String? keyName, required Widget widgetName}) {
    if (keyName != null) {
      CacheHelper.saveData(
        key: keyName,
        value: true,
      );
    }
    naviPushAndRemoveUntil(context, widgetName: widgetName);
  }

  DateTime convertStringDateToDateTime({String? date}) {
    if (date == null) {
      return DateTime.now();
    } else {
      return DateTime.parse(date);
    }
  }

  String formatDateTime(
    String? date, {
    String? formatStyle = 'MMMMEEEEd',
  }) {
    DateFormat dateFormat = DateFormat(formatStyle);
    return dateFormat.format(convertStringDateToDateTime(date: date));
  }
}
