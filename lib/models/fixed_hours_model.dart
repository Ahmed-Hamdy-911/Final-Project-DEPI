class FixedHoursModel {
  final String? toTime;
  final String? fromTime;

  FixedHoursModel({
    this.toTime,
    this.fromTime,
  });

  factory FixedHoursModel.fromJson(json) {
    return FixedHoursModel(
      toTime: json['to'],
      fromTime: json['from'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': fromTime,
      'to': toTime,
    };
  }
}
