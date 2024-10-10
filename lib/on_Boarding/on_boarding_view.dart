import 'package:flutter/material.dart';
import 'package:bs_rashhuli/constants/colors.dart';
import 'package:bs_rashhuli/models/on_borading_model.dart';
import 'package:bs_rashhuli/services/app_services.dart';
import 'package:bs_rashhuli/views/auth/login_view.dart';
import 'package:bs_rashhuli/widgets/custom_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/cutom_material_button.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController();

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
    );
  }

  bool _isLastPage = false;
  final List<OnBoradingModel> _onBoardingList = [
    OnBoradingModel(
      image:
          "https://walnuthillcollege.edu/wp-content/uploads/2021/08/WH_Header_Degree_Programs-360x300.png",
      title: 'Lorem Ipsum is simply dummy text ',
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's .",
    ),
    OnBoradingModel(
      image:
          "https://walnuthillcollege.edu/wp-content/uploads/2021/08/WH_Header_Degree_Programs-360x300.png",
      title: 'Lorem Ipsum is simply dummy text ',
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's .",
    ),
    OnBoradingModel(
      image:
          "https://walnuthillcollege.edu/wp-content/uploads/2021/08/WH_Header_Degree_Programs-360x300.png",
      title: 'Lorem Ipsum is simply dummy text ',
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's .",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: PageView.builder(
                  onPageChanged: (value) {
                    _onPageChanged(value);
                    if (value == _onBoardingList.length - 1) {
                      setState(() {
                        _isLastPage = true;
                      });
                    } else {
                      setState(() {
                        _isLastPage = false;
                      });
                    }
                  },
                  controller: _pageController,
                  itemCount: _onBoardingList.length,
                  itemBuilder: (context, index) {
                    var model = _onBoardingList[index];
                    return Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.elliptical(
                                  MediaQuery.of(context).size.width * 0.5, 90),
                              bottomRight: Radius.elliptical(
                                  MediaQuery.of(context).size.width * 0.5, 90),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                model.image,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              CustomText(
                                text: model.title,
                                textColor: kMainColor,
                                maxLines: 2,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                text: model.description,
                                fontSize: 17,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height *
                    0.58, // Adjust this value as needed
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    effect: ExpandingDotsEffect(
                      activeDotColor: kMainColor,
                      dotColor: Colors.grey[300]!,
                      spacing: 4,
                      dotWidth: 11,
                      dotHeight: 11,
                    ),
                    count: _onBoardingList.length,
                  ),
                ),
              ),
              Positioned(
                top: 29,
                left: 15,
                child: CustomMaterialButton(
                  onPressed: () {
                    AppServices().skipAndFinished(context,
                        keyName: "onBoardingFinished", widgetName: LoginView());
                  },
                  text: "تخطى",
                  color: kMainColor,
                  textColor: Colors.white,
                  minWidth: 96,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomMaterialButton(
              onPressed: () {
                AppServices().getStartAction(
                  context,
                  pageController: _pageController,
                  isLastPage: _isLastPage,
                );
              },
              text: _isLastPage ? "لنبدأ!" : "التالي",
              color: kMainColor,
              textColor: Colors.white,
              textSized: 17,
              minWidth: MediaQuery.of(context).size.width * 0.9,
            ),
          ),
        ],
      ),
    );
  }
}
