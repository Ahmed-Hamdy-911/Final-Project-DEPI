class DaySchedule {
  String? fromTime;
  String? toTime;
  bool isVacation;

  DaySchedule({
    this.fromTime,
    this.toTime,
    this.isVacation = false,
  });

  // Convert DaySchedule from JSON
  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      fromTime: json['from'],
      toTime: json['to'],
      isVacation: json['isVacation'] ?? false,
    );
  }

  // Convert DaySchedule to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'from': fromTime,
      'to': toTime,
      'isVacation': isVacation,
    };
  }
}
