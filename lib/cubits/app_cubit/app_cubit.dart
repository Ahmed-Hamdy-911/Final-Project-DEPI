import 'dart:developer';
import 'package:path/path.dart';
import 'package:bs_rashhuli/helper/helper.dart';
import 'package:bs_rashhuli/views/main_home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bs_rashhuli/cubits/app_cubit/app_states.dart';

import '../../models/category_model.dart';
import '../../models/day_schedule_model.dart';
import '../../models/place_model.dart';
import '../auth_cubit/auth_cubit.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());
  static AppCubit get(context) => BlocProvider.of(context);
  TextEditingController? addLocationController;
  Category? selectedCategory;
  void setAddLocationController(TextEditingController controller) {
    addLocationController = controller;
  }

  bool isFixiedTimings = true;

  // Reset the other type of hours
  void changeFixiedTimings(bool isFixedSelected) {
    isFixiedTimings = isFixedSelected;

    if (isFixedSelected) {
      // Clear variable hours if fixed is selected
      weekSchedule = List.generate(7, (index) => DaySchedule());
    } else {
      // Clear fixed hours if variable is selected
      fromTime = null;
      toTime = null;
    }

    emit(SwitchTimingsState());
  }

  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  // Method to select time
  Future<void> selectFixiedTime(BuildContext context, bool isFrom) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          isFrom ? (fromTime ?? TimeOfDay.now()) : (toTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      if (isFrom) {
        fromTime = picked;
        emit(TimeSelectedState()); // Emit a state to rebuild the UI
      } else {
        toTime = picked;
        emit(TimeSelectedState()); // Emit a state to rebuild the UI
      }
    }
  }

  // // Emit state to update UI
  // void emitTimeState() {
  //   emit(TimeSelectedState());
  // }
  // String formattedFromTime =
  //     appCubit.fromTime != null ? appCubit.fromTime!.format(context) : "من";
  // String formattedToTime =
  //     appCubit.toTime != null ? appCubit.toTime!.format(context) : "إلى";

  List<DaySchedule> weekSchedule = List.generate(7, (index) => DaySchedule());

  Future<void> selectTime(
      BuildContext context, int? dayIndex, bool isFromTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setDayTime(dayIndex, pickedTime, isFromTime);
    }
    weekSchedule.forEach((e) {
      if (e.fromTime != null && e.toTime != null && e.isVacation == false) {
        // log(e.fromTime.toString());
        // log(e.toTime.toString());
        // log(e.isVacation.toString());
      }
    });
  }

  // Function to change vacation state for a specific day
  void changeVacation(int dayIndex, bool isVacation) {
    weekSchedule[dayIndex].isVacation = isVacation;
    emit(SwitchingState());
  }

  // Function to set the "from" or "to" time for a specific day
  void setDayTime(int? dayIndex, TimeOfDay time, bool isFromTime) {
    if (isFromTime) {
      weekSchedule[dayIndex!].fromTime = time;
    } else {
      weekSchedule[dayIndex!].toTime = time;
    }
    emit(SetTimeState());
  }

  // Getter to check if a day is marked as vacation
  bool isVacation(int dayIndex) {
    return weekSchedule[dayIndex].isVacation;
  }

  // Get the "from" time in formatted string
  String? getFromTime(context, int dayIndex) {
    final time = weekSchedule[dayIndex].fromTime;

    return time != null ? time.format(context) : null;
  }

  // Get the "to" time in formatted string
  String? getToTime(context, int dayIndex) {
    final time = weekSchedule[dayIndex].toTime;
    return time != null ? time.format(context) : null;
  }

  void setPlaceLocation(String region) {
    addLocationController?.text = region; // Update the controller text
    emit(SuccessfulSetPlaceLocationState());
  }

  void setCategory(Category category) {
    selectedCategory = category;
    emit(SuccessfulSetCategoryState());
  }

  CollectionReference appRef = FirebaseFirestore.instance.collection('data');

  Future addNewPlace(
    BuildContext context, {
    required String name,
    required String description,
    required String location,
    required String category,
    required List images,
  }) async {
    emit(LoadingAppState());

    List<String> imageUrls = [];
    FixiedHoursModel? fixiedHours;
    List<DaySchedule>? variableHours;

    try {
   
      if (images.isNotEmpty) {
        await uploadImageToFirebaseStorage(images, imageUrls);
      }
      if (isFixiedTimings) {
        fixiedHours = FixiedHoursModel(
          fromTime: fromTime != null ? fromTime!.format(context) : null,
          toTime: toTime != null ? toTime!.format(context) : null,
        );
      } else {
        // Set variable hours
        variableHours = weekSchedule;
      }

      // Firestore upload logic
      await appRef.add({
        'name': name,
        'description': description,
        'location': location,
        'category': category,
        'images': imageUrls,
        'fixed_hours': fixiedHours != null ? fixiedHours.toJson() : null,
        'week_schedule': variableHours != null
            ? variableHours.map((schedule) => schedule.toJson(context)).toList()
            : null,
        'create_at': DateTime.now().toString(),
      });
      naviPushAndRemoveUntil(context, widgetName: MainHomeView());
      emit(SuccessfulAddPlaceState());
    } catch (e) {
      emit(ErrorAddPlaceState(e.toString()));
    }
  }

// Upload images to Firebase Storage
  Future<void> uploadImageToFirebaseStorage(
      List<dynamic> images, List<String> imageUrls) async {
    for (var image in images) {
      var imagePath = basename(image.path);
      var refStorage = FirebaseStorage.instance.ref(imagePath);
      await refStorage.putFile(image);
      String downloadUrl =
          await refStorage.getDownloadURL(); // Get the download URL
      imageUrls.add(downloadUrl); // Add the URL to the list
      // log('image url' + imageUrls[0]);
    }
  }

  // get the data
  List<PlaceModel> places = [];
  PlaceModel? placeModel;

  Future<void> fetchPlaces() async {
    emit(LoadingAppState());
    try {
      // Fetch the data from Firebase Firestore
      QuerySnapshot snapshot = await appRef.get();
      places.clear();
      // Loop through each document and map to PlaceModel
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Use the named constructor 'fromJson'
        placeModel = PlaceModel.fromJson(data, doc.id);

        // Add the place model to the list
        places.add(placeModel!);
      });

      // Emit success state after data is fetched
      // log('image url' +
      //     '${placeModel!.images!.isNotEmpty ? placeModel!.images![0] : null}');
      emit(SuccessfulFetchPlaceState());
    } on FirebaseException catch (e) {
      log(e.message.toString());
      emit(ErrorFetchPlaceState(e.code));
    } catch (error) {
      log(error.toString());
      emit(ErrorFetchPlaceState(error.toString()));
    }
  }
}
