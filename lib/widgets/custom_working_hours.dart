import 'package:bs_rashhuli/constants/colors.dart';
import 'package:bs_rashhuli/cubits/app_cubit/app_cubit.dart';
import 'package:bs_rashhuli/cubits/app_cubit/app_states.dart';
import 'package:bs_rashhuli/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_text.dart';

class CustomWorkingHours extends StatelessWidget {
  const CustomWorkingHours({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "حدد  ساعات العمل",
                fontSize: 15,
              ),
              CustomTitleForWorkingHours(),
              SizedBox(
                height: 8,
              ),
              if (context.read<AppCubit>().isFixiedTimings)
                FixedWorkingHours()
              else
                VariableWorkingHours(),
            ],
          ),
        );
      },
    );
  }
}

class CustomTitleForWorkingHours extends StatelessWidget {
  const CustomTitleForWorkingHours({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color defaultTextColor = Colors.black;
    Color defaultSelectedButtonTextColor = Colors.white;
    Color defaultBtnColor = Colors.white;
    Color defaultSelectedBtnColor = kMainColor.withOpacity(0.5);
    var appCubit = BlocProvider.of<AppCubit>(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              appCubit.changeFixiedTimings(true);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(appCubit.isFixiedTimings
                  ? defaultSelectedBtnColor
                  : defaultBtnColor),
            ),
            child: CustomText(
              text: "مواعيد ثابتة",
              fontSize: 14,
              textColor: appCubit.isFixiedTimings
                  ? defaultSelectedButtonTextColor
                  : defaultTextColor,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              appCubit.changeFixiedTimings(false);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                  appCubit.isFixiedTimings == false
                      ? defaultSelectedBtnColor
                      : defaultBtnColor),
            ),
            child: CustomText(
              text: "مواعيد متغيرة",
              fontSize: 14,
              textColor: appCubit.isFixiedTimings == false
                  ? defaultSelectedButtonTextColor
                  : defaultTextColor,
            ),
          ),
        ),
      ],
    );
  }
}

class FixedWorkingHours extends StatelessWidget {
  const FixedWorkingHours({super.key});

  @override
  Widget build(BuildContext context) {
    final appCubit = BlocProvider.of<AppCubit>(context);

    // Format selected time or show default hint if time not set
    String formattedFromTime =
        appCubit.fromTime != null ? appCubit.fromTime!.format(context) : "من";
    String formattedToTime =
        appCubit.toTime != null ? appCubit.toTime!.format(context) : "إلى";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              text: "كل ايام الاسبوع: ",
              fontSize: 14,
            ),
            Expanded(
              child: CustomTextFormField(
                readOnly: true,
                onTap: () {
                  appCubit.selectFixiedTime(
                      context, true); // Select 'from' time
                },
                contentPadding: EdgeInsets.all(0),
                hintText: formattedFromTime, // Display selected or default time
                prefixIcon: Icon(
                  Icons.timer,
                  color: Colors.grey,
                  size: 22,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: CustomTextFormField(
                readOnly: true,
                onTap: () {
                  appCubit.selectFixiedTime(context, false); // Select 'to' time
                },
                contentPadding: EdgeInsets.all(0),
                hintText: formattedToTime, // Display selected or default time
                prefixIcon: Icon(
                  Icons.timelapse,
                  color: Colors.grey,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class VariableWorkingHours extends StatelessWidget {
  const VariableWorkingHours({super.key});

  @override
  Widget build(BuildContext context) {
    final appCubit = BlocProvider.of<AppCubit>(context);
    return Column(
      children: [
        CustomVariableWorkingHoursItem(
          appCubit: appCubit,
          dayName: "السبت",
          dayIndex: 0,
        ),
        CustomVariableWorkingHoursItem(
          appCubit: appCubit,
          dayName: "الأحد",
          dayIndex: 1,
        ),
        CustomVariableWorkingHoursItem(
          appCubit: appCubit,
          dayName: "الاثنين",
          dayIndex: 2,
        ),
        CustomVariableWorkingHoursItem(
          appCubit: appCubit,
          dayName: "الثلاثاء",
          dayIndex: 3,
        ),
        CustomVariableWorkingHoursItem(
          appCubit: appCubit,
          dayName: "الأربعاء",
          dayIndex: 4,
        ),
        CustomVariableWorkingHoursItem(
          appCubit: appCubit,
          dayName: "الخميس",
          dayIndex: 5,
        ),
        CustomVariableWorkingHoursItem(
          appCubit: appCubit,
          dayName: "الجمعة",
          dayIndex: 6,
        ),
        // ListView.builder(
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   itemCount: appCubit.weekSchedule.length,
        //   itemBuilder: (context, index) {
        //     TimeOfDay? fromTime = appCubit.weekSchedule[index].fromTime;

        //     // If fromTime is not null, convert to DateTime and format, otherwise show "No Time Set"
        //     String formattedTime = fromTime != null
        //         ? fromTime.format(context) // Use TimeOfDay's format method
        //         : "No Time Set";

        //     return CustomText(
        //       text: formattedTime, // Display the formatted time or fallback
        //     );
        //   },
        // )
      ],
    );
  }
}

class CustomVariableWorkingHoursItem extends StatelessWidget {
  const CustomVariableWorkingHoursItem({
    super.key,
    required this.appCubit,
    required this.dayName,
    required this.dayIndex,
  });

  final AppCubit appCubit;
  final String dayName;
  final int dayIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.16,
            child: CustomText(
              text: dayName,
              fontSize: 14,
            ),
          ),
          Expanded(
            flex: 1,
            child: CustomTextFormField(
              readOnly: true,
              contentPadding: EdgeInsets.all(0),
              hintText: appCubit.getFromTime(context, dayIndex) ?? "من",
              enabled: !appCubit.isVacation(dayIndex),
              onTap: () {
                if (!appCubit.isVacation(dayIndex)) {
                  appCubit.selectTime(
                      context, dayIndex, true); // Select "from" time
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9:]+$')),
                LengthLimitingTextInputFormatter(5)
              ],
              prefixIcon: Icon(
                Icons.timer,
                color: Colors.grey,
                size: 22,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: CustomTextFormField(
              readOnly: true,
              contentPadding: EdgeInsets.all(0),
              hintText: appCubit.getToTime(context, dayIndex) ?? "إلى",
              enabled: !appCubit.isVacation(dayIndex),
              onTap: () {
                if (!appCubit.isVacation(dayIndex)) {
                  appCubit.selectTime(
                      context, dayIndex, false); // Select "to" time
                }
              },
              prefixIcon: Icon(
                Icons.timelapse,
                color: Colors.grey,
                size: 22,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Checkbox(
                  value: appCubit.isVacation(dayIndex),
                  checkColor: Colors.white,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onChanged: (value) {
                    appCubit.changeVacation(dayIndex, value!);
                  },
                ),
                const CustomText(
                  fontSize: 14,
                  text: "اجازة",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
