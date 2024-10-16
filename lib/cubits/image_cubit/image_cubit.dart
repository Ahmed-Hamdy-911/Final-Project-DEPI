import 'dart:io';
import 'package:bs_rashhuli/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'image_states.dart';

class ImageCubit extends Cubit<ImageStates> {
  ImageCubit() : super(InitialImageState());

  /// List of images stored as File objects.
  List<File> images = [];

  /// Image picker instance.
  ImagePicker imagePicker = ImagePicker();

  /// Image cropper instance.
  ImageCropper imageCropper = ImageCropper();

  /// Function to handle image uploading with permission handling.
  Future<void> uploadImage(
    BuildContext context, {
    required ImageSource source,
  }) async {
    emit(LoadingImageState());

    // Check and request permissions based on the image source.
    final permissionGranted = await _checkAndRequestPermission(source);

    if (!permissionGranted) {
      emit(FailureImageState(error: 'Permission denied.'));
      showSnakBar(context, message: 'Permission denied.');
      return;
    }

    try {
      // Pick an image based on the source (camera or gallery).
      XFile? pickedImage = await imagePicker.pickImage(source: source);

      if (pickedImage != null) {
        // Crop the image.
        CroppedFile? croppedFile = await imageCropper.cropImage(
          sourcePath: pickedImage.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropping the Image',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
              ],
            ),
            IOSUiSettings(
              title: 'Cropping the Image',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
              ],
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );

        // If cropping is successful, add the image to the list.
        if (croppedFile != null) {
          images.add(File(croppedFile.path));
          emit(SuccessImageState());
        } else {
          emit(FailureImageState(error: 'Cropping failed'));
        }
      } else {
        emit(FailureImageState(error: 'Image picking failed'));
      }
    } catch (e) {
      emit(FailureImageState(error: e.toString()));
    }
  }

  void deleteImage(int index) {
    images.removeAt(index);
    emit(SuccessDeleteImageState());
  }

  void clearImageList() {
    images.clear();
  }

  /// Helper function to check and request the necessary permissions based on the image source.
  Future<bool> _checkAndRequestPermission(ImageSource source) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      // Request camera permission.
      status = await Permission.camera.request();
    } else {
      // Request storage permission for gallery access.
      status = await Permission.storage.request();
    }

    return status.isGranted;
  }
}
