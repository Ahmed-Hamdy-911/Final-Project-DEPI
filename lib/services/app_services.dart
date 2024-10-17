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

  Color getCategoryColor(String categoryName) {
    switch (categoryName) {
      case 'طعام':
        return Colors.red;
      case 'الدراسة و العمل':
        return Colors.blue;
      case 'الإقامة':
        return Colors.green;
      case 'الصحة':
        return Colors.pink;
      case 'النقل والمواصلات':
        return Colors.orange;
      case 'الترفيه و التسلية':
        return Colors.purple;
      case 'التسوق و الاحتياجات':
        return Colors.teal;
      case 'خدمات الطلاب':
        return Colors.yellow;
      case 'البنوك و الشؤون المالية':
        return Colors.grey;
      case 'الفعاليات و الأنشطة':
        return Colors.indigo;
      case 'اماكن للعبادة':
        return Colors.brown;
      case 'التكنولوجيا و الدعم':
        return Colors.blueGrey;
      case 'السلامة و خدمات الطوارئ':
        return Colors.redAccent;
      case 'غير ذلك':
        return Colors.black;
      default:
        return Colors.black54;
    }
  }
}
