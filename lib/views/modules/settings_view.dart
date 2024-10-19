import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../cache/cache_helper.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../helper/helper.dart';
import '../../widgets/custom_list_title.dart';
import '../auth/profile/profile_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          CustomListTitle(
            title: "الحساب",
            icon: Icons.person_2_outlined,
            onTap: () {
              naviPush(context, widgetName: const ProfileView());
            },
          ),
          CustomListTitle(
            title: 'تغيير الدور',
            icon: Icons.admin_panel_settings_outlined,
            onTap: () {
              showSnakBar(context, message: 'قريبا...');
            },
          ),
          CustomListTitle(
            title: 'تغيير السيم',
            icon: Icons.brightness_4_outlined,
            onTap: () {
              showSnakBar(context, message: 'قريبا...');
            },
          ),
          CustomListTitle(
            title: 'تواصل معنا',
            icon: Icons.support_agent_outlined,
            onTap: () {
              showSnakBar(context, message: 'قريبا...');
            },
          ),
          CustomListTitle(
            title: 'سياسة الخصوصية',
            icon: Icons.privacy_tip_outlined,
            onTap: () {
              showSnakBar(context, message: 'قريبا...');
            },
          ),
          CustomListTitle(
            title: 'فتح التطبيق من البدايه ل العرض ',
            subtitle: '(للاختبار)',
            icon: Icons.restart_alt,
            onTap: () {
              CacheHelper.clearData();
              BlocProvider.of<AuthCubit>(context).logOut(context);
              showSnakBar(context, message: 'اعد تشغيل التطبيق');
            },
          ),
          CustomListTitle(
            title: "تسجيل الخروج",
            icon: Icons.logout_rounded,
            onTap: () {
              BlocProvider.of<AuthCubit>(context).logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
