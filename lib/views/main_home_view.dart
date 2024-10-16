import 'package:bs_rashhuli/cache/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:bs_rashhuli/constants/colors.dart';
import 'package:bs_rashhuli/cubits/bottom_navi_cubit/bottom_navi_cubit.dart';
import 'package:bs_rashhuli/helper/helper.dart';
import 'package:bs_rashhuli/widgets/custom_text.dart';

import 'modules/add_places_view.dart';

class MainHomeView extends StatelessWidget {
  const MainHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNaviCubit(),
      child: const MainHomeViewBuilder(),
    );
  }
}

class MainHomeViewBuilder extends StatelessWidget {
  const MainHomeViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNaviCubit, int>(
      builder: (context, state) {
        var cubit = BlocProvider.of<BottomNaviCubit>(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: CustomText(
              text: cubit.titlesList[cubit.currentIndex],
              textColor: kMainColor,
              fontSize: 17,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              naviPush(context, widgetName: const AddPlacesView());
              // naviPush(context, widgetName: const RegionSelectionView());
            },
            tooltip: "اضف  مكان",
            child: const Icon(
              Icons.add,
              size: 27,
            ),
          ),
          body: cubit.screensList[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: cubit.changeSelectedIndex,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: kMainColor,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: cubit.currentIndex == 0
                    ? const Icon(IconlyBold.home)
                    : const Icon(IconlyLight.home),
                label: cubit.titlesList[0],
              ),
              BottomNavigationBarItem(
                icon: cubit.currentIndex == 1
                    ? const Icon(IconlyBold.category)
                    : const Icon(IconlyLight.category),
                label: cubit.titlesList[1],
              ),
              BottomNavigationBarItem(
                icon: cubit.currentIndex == 2
                    ? const Icon(IconlyBold.heart)
                    : const Icon(IconlyLight.heart),
                label: cubit.titlesList[2],
              ),
              BottomNavigationBarItem(
                icon: cubit.currentIndex == 3
                    ? const Icon(IconlyBold.setting)
                    : const Icon(IconlyLight.setting),
                label: cubit.titlesList[3],
              ),
            ],
          ),
        );
      },
    );
  }
}
