import 'package:flutter/material.dart';

import 'day_schedule_model.dart';

class PlaceModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String category;
  final List? images;
  final FixiedHoursModel? fixedHours;
  final List<DaySchedule>? variableHours; // Variable hours are added
  final String createdAt;

  PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    this.images,
    this.fixedHours,
    this.variableHours, // Added here
    required this.createdAt,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json, String id) {
    return PlaceModel(
      id: id,
      name: json['name'],
      description: json['description'],
      location: json['location'],
      category: json['category'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      createdAt: json['create_at'] ?? '',
      fixedHours: json['fixed_hours'] != null
          ? FixiedHoursModel.fromJson(json['fixed_hours'])
          : null,
      variableHours: json['week_schedule'] != null
          ? List<DaySchedule>.from(json['week_schedule']
              .map((schedule) => DaySchedule.fromJson(schedule)))
          : null,
    );
  }

  // Convert to JSON, handle both hour types
  Map<String, dynamic> toJson(BuildContext context) {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'category': category,
      'images': images,
      'create_at': createdAt,
      'fixed_hours': fixedHours?.toJson(), // Only add if it's not null
      'week_schedule': variableHours != null
          ? variableHours!.map((schedule) => schedule.toJson(context)).toList()
          : null,
    };
  }
}

class FixiedHoursModel {
  final String? toTime;
  final String? fromTime;

  FixiedHoursModel({
    this.toTime,
    this.fromTime,
  });

  factory FixiedHoursModel.fromJson(json) {
    return FixiedHoursModel(
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
