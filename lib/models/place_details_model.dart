import 'day_schedule_model.dart';
import 'fixed_hours_model.dart';

class PlaceDetailsModel {
  final String id;
  final String addedBy;
  final String name;
  final String description;
  final String location;
  final String category;
  final List? images; // Images for the place
  final FixedHoursModel? fixedHours; // Fixed working hours
  final List<DaySchedule>? variableHours; // Variable working hours
  final String createdAt;

  PlaceDetailsModel({
    required this.id,
    required this.addedBy,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    this.images,
    this.fixedHours,
    this.variableHours,
    required this.createdAt,
  });

  // Factory constructor to map JSON to the PlaceDetailsModel
  factory PlaceDetailsModel.fromJson(Map<String, dynamic> json, String id) {
    return PlaceDetailsModel(
      id: id,
      addedBy: json['added_by'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      category: json['category'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      createdAt: json['create_at'],
      fixedHours: json['fixed_hours'] != null
          ? FixedHoursModel.fromJson(json['fixed_hours'])
          : null,
      variableHours: json['week_schedule'] != null
          ? List<DaySchedule>.from(json['week_schedule']
              .map((schedule) => DaySchedule.fromJson(schedule)))
          : null,
    );
  }
}
