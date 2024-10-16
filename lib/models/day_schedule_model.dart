import 'package:flutter/material.dart';

class DaySchedule {
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  bool isVacation;

  DaySchedule({
    this.fromTime,
    this.toTime,
    this.isVacation = false,
  });

  // Convert DaySchedule from JSON
  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      fromTime: json['from'] != null
          ? TimeOfDay(
              hour: int.parse(json['from'].split(':')[0]),
              minute: int.parse(json['from'].split(':')[1]))
          : null,
      toTime: json['to'] != null
          ? TimeOfDay(
              hour: int.parse(json['to'].split(':')[0]),
              minute: int.parse(json['to'].split(':')[1]))
          : null,
      isVacation: json['isVacation'] ?? false,
    );
  }

  Map<String, dynamic> toJson(BuildContext context) {
    return {
      'from': fromTime != null ? fromTime!.format(context) : null,
      'to': toTime != null ? toTime!.format(context) : null,
      'isVacation': isVacation,
    };
  }
}
