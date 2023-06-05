import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  String formattedDate = DateFormat('MMM d, yy').format(dateTime);
  return formattedDate;
}

String convertTime(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('h:mm a').format(dateTime);
  return formattedDate.toLowerCase();
}

String convertDateTimeString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate =
      DateFormat('MMMM d, yyyy \'at\' h:mm a').format(dateTime);
  return formattedDate;
}

String convertToMonthDayString(String dateString) {
  DateTime dateTime = DateFormat('d/M/yyyy').parse(dateString);
  String formattedDate = DateFormat('MMM d').format(dateTime);
  return formattedDate;
}

String convertToDayString(String dateString) {
  DateTime dateTime = DateFormat('d/M/yyyy').parse(dateString);
  String formattedDate = DateFormat('EEEE').format(dateTime);
  return formattedDate;
}

String convertToElapsedString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  // int weeksElapsed = difference.inDays ~/ 7;
  int daysElapsed = difference.inDays;
  int hoursElapsed = difference.inHours - (daysElapsed * 24);
  int minutesElapsed = difference.inMinutes - (hoursElapsed * 60);

  String output = "";

  if (daysElapsed >= 7) {
    output = convertDateString(dateString);
    return output;
  }

  if (daysElapsed > 0) {
    output = "$daysElapsed d";
    return output;
  }
  if (hoursElapsed >= 24 && hoursElapsed <=48) {
    return "Yesterday";
  }
  
  if (hoursElapsed > 0) {
    output = "$hoursElapsed h, $minutesElapsed m";
    return output;
  }
  if (minutesElapsed < 1) {
    return "now";
  }
  output = "$minutesElapsed m";
  // "$minutesElapsed m, ${difference.inSeconds - (minutesElapsed * 60)} s";
  return output;
}

Time getTimeOfDay(String time) {
  var components = time.split(':');
  var hour = int.tryParse(components[0]) ?? 0;
  var minutePart = components[1].substring(0, 2);
  var minute = int.tryParse(minutePart) ?? 0;

  if (time.endsWith('PM') && hour != 12) {
    hour += 12;
  } else if (time.endsWith('AM') && hour == 12) {
    hour = 0;
  }

  return Time(hour, minute, 0);
}

String getSTartTime(String time) {
  String startTime = time.split("-")[0];
  // String endTime = time.split("-")[1];

  // convert to 24 hour format
  if (startTime.contains("PM")) {
    startTime = startTime.replaceAll("PM", "");
    startTime =
        "${int.parse(startTime.split(":")[0]) + 12}:${startTime.split(":")[1]}";
  } else {
    startTime = startTime.replaceAll("AM", "");
  }

  startTime = startTime.trim();

  // _time =
  // "${DateFormat.jm().format(DateFormat("hh:mm").parse(startTime))} - ${DateFormat.jm().format(DateFormat("hh:mm").parse(endTime))}";
  return startTime;
  // return "${DateFormat.jm().format(DateFormat("hh:mm").parse(startTime))} - ${DateFormat.jm().format(DateFormat("hh:mm").parse(endTime))}";
}

Map<String, dynamic> extractModel(String jsonString) {
  final inputMap = jsonDecode(jsonString);
  final dataValue = inputMap['data'];
  if (dataValue is String) {
    final jsonData = jsonDecode(dataValue);
    if (jsonData is Map<String, dynamic>) {
      return jsonData;
    }
  }
  return {};
}

// Map<String, dynamic> extractModel(String jsonString) {
//   final jsonData = jsonDecode(jsonString);
//   if (jsonData is Map<String, dynamic>) {
//     return jsonData;
//   }
//   return {};
// }
