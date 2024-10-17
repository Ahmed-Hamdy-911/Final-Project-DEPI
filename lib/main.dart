import 'package:bs_rashhuli/cubits/app_cubit/app_cubit.dart';
import 'package:bs_rashhuli/cubits/image_cubit/image_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bs_rashhuli/cache/cache_helper.dart';
import 'package:bs_rashhuli/constants/colors.dart';
import 'package:bs_rashhuli/cubits/auth_cubit/auth_cubit.dart';
import 'package:bs_rashhuli/cubits/timer_cubit/timer_cubit.dart';
import 'package:bs_rashhuli/on_Boarding/on_boarding_view.dart';
import 'package:bs_rashhuli/splash/splash_view.dart';
import 'package:bs_rashhuli/views/main_home_view.dart';
import 'constants/constants.dart';
import 'cubits/bloc_observer.dart';
import 'firebase_options.dart';
import 'views/auth/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init(); // Initialize the cache helper
  Bloc.observer = MyBlocObserver();
  onBoardingFinished = CacheHelper.getData(key: 'onBoardingFinished');
  // print(onBoardingFinished);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(
    onBoardingFinished: onBoardingFinished,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.onBoardingFinished,
  });
  final bool? onBoardingFinished;
  Widget _returnStartWidget() {
    if (onBoardingFinished != null) {
      if (onBoardingFinished == true) {
        if (FirebaseAuth.instance.currentUser?.uid != null &&
            FirebaseAuth.instance.currentUser!.emailVerified) {
          return const MainHomeView();
        }
        return const LoginView();
      } else {
        return const OnBoardingView();
      }
    } else {
      return const OnBoardingView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => TimerCubit()),
        BlocProvider(create: (context) => ImageCubit()),
      ],
      child: MaterialApp(
        title: 'BNS Rashhuli',
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar'), // Set the app's language to Arabic
        supportedLocales: const [
          Locale('ar'), // Arabic locale
        ],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale != null) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
          }
          return supportedLocales.first;
        },
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
          colorScheme: ColorScheme.fromSeed(seedColor: kMainColor),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(
                color: kMainColor,
                fontWeight: FontWeight.bold,
              )),
          useMaterial3: true,
        ),
        home: SplashView(
          startWidget: _returnStartWidget(),
        ),
      ),
    );
  }
}
