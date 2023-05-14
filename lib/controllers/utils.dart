import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Utils {
  XFile? selectedMedia;
  CroppedFile? croppedMedia;
  Future<void> cropImage() async {
    if (selectedMedia != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: selectedMedia!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        // setState(() {
        croppedMedia = croppedFile;
        // });
      }
    }
  }

  Future<void> uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // setState(() {
      selectedMedia = pickedFile;
      // });
    }
  }

  void clear() {
    // setState(() {
    selectedMedia = null;
    croppedMedia = null;
    // });
  }
}

String convertDateString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate =
      DateFormat('MMMM d, yyyy \'at\' h:mm a').format(dateTime);
  return formattedDate;
}

String convertToElapsedString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  int weeksElapsed = difference.inDays ~/ 7;
  int daysElapsed = difference.inDays;
  int hoursElapsed = difference.inHours - (daysElapsed * 24);
  int minutesElapsed = difference.inMinutes - (hoursElapsed * 60);

  String output = "";
  if (weeksElapsed > 0) {
    if (daysElapsed % 7 == 0) {
      output = "$weeksElapsed w";
      return output;
    }
    output = "$weeksElapsed w, ${daysElapsed % 7} d";
    return output;
  }
  if (daysElapsed > 0) {
    output = "$daysElapsed d";
    return output;
  }
  if (hoursElapsed > 0) {
    output = "$hoursElapsed h";
    return output;
  }
  if (minutesElapsed < 2) {
    return "now";
  }
  output = "$minutesElapsed m";
  return output;
}
