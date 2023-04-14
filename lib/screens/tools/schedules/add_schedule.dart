import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/components/select_control1.dart';
import 'package:infoctess_koneqt/controllers/notification_service.dart';
import 'package:infoctess_koneqt/models/courses_db.dart';
import 'package:infoctess_koneqt/models/timetable_db.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';
import 'package:timezone/timezone.dart' as tz;

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cCode = TextEditingController();
  final TextEditingController _lecturer = TextEditingController();
  final TextEditingController _venue = TextEditingController();
  final TextEditingController _startTime = TextEditingController();
  final TextEditingController _endTime = TextEditingController();

  final List<DropdownMenuItem<String>> _days = const [
    DropdownMenuItem(
      value: 'Monday',
      child: Text('Monday'),
    ),
    DropdownMenuItem(
      value: 'Tuesday',
      child: Text('Tuesday'),
    ),
    DropdownMenuItem(
      value: 'Wednesday',
      child: Text('Wednesday'),
    ),
    DropdownMenuItem(
      value: 'Thursday',
      child: Text('Thursday'),
    ),
    DropdownMenuItem(
      value: 'Friday',
      child: Text('Friday'),
    ),
    DropdownMenuItem(
      value: 'Saturday',
      child: Text('Saturday'),
    ),
    DropdownMenuItem(
      value: 'Sunday',
      child: Text('Sunday'),
    ),
  ];

  List<DropdownMenuItem<String>> courseList = [];
  List<Course> courses = [];
  late String selectCourse;
  late String selectedCourseCode;
  late String selectedDay;

  Map<String, dynamic> courseMap = {};

  Future getCourses() async {
    courses = await AppDatabase.instance.getCourses();

    setState(() {
      for (var element in courses) {
        courseMap[element.courseCode!] = element.courseTitle;
      }
      courseList.addAll(
        courses.map(
          (e) => DropdownMenuItem(
            value: e.courseTitle,
            child: Text(e.courseTitle!),
          ),
        ),
      );
    });
    // return courses;
  }

  @override
  void initState() {
    getCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SelectControl(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter end time';
                    }
                    return null;
                  },
                  items: courseList,
                  hintText: 'Select Subject',
                  onChanged: (value) async {
                    setState(() {
                      selectCourse = value.toString();
                      selectedCourseCode = courseMap.keys.firstWhere(
                          (element) => courseMap[element] == selectCourse);
                      _cCode.text = selectedCourseCode;
                    });
                  },
                ),
                InputControl(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter end time';
                    }
                    return null;
                  },
                  hintText: 'Course Code',
                  readOnly: true,
                  controller: _cCode,
                ),
                InputControl(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter end time';
                    }
                    return null;
                  },
                  hintText: 'Lecturer Name',
                  controller: _lecturer,
                ),
                SelectControl(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter end time';
                    }
                    return null;
                  },
                  items: _days,
                  hintText: 'Select Day',
                  onChanged: (value) {
                    setState(() {
                      selectedDay = value.toString();
                    });
                  },
                ),
                InputControl(
                  hintText: 'Venue',
                  controller: _venue,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter end time';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputControl(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter end time';
                          }
                          return null;
                        },
                        hintText: 'Start Time',
                        controller: _startTime,
                        readOnly: true,
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            setState(() {
                              _startTime.text = value!.format(context);
                            });
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InputControl(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter end time';
                          }
                          return null;
                        },
                        controller: _endTime,
                        hintText: "End Time",
                        readOnly: true,
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            setState(() {
                              _endTime.text = value!.format(context);
                            });
                          });
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppTheme.themeData(false, context).backgroundColor,
                      foregroundColor:
                          AppTheme.themeData(false, context).primaryColorDark,
                      fixedSize: Size(size.width * 0.8, 50)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Timetable schedule = Timetable(
                        courseTitle: selectCourse,
                        courseCode: _cCode.text,
                        lecturer: _lecturer.text,
                        venue: _venue.text,
                        startTime: _startTime.text,
                        endTime: _endTime.text,
                        day: selectedDay,
                      );
                      // inspect(schedule);
                      await AppDatabase.instance
                          .addSchedule(schedule)
                          .then((value) => NotificationService()
                              .scheduleNotification(
                                  day: selectedDay, time: _startTime.text))
                          .then(
                            (value) => StatusAlert.show(
                              context,
                              title: "Schedule Added",
                              maxWidth: 50.vw,
                              titleOptions: StatusAlertTextConfiguration(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              configuration: IconConfiguration(
                                icon: Icons.check,
                                color: Colors.green,
                                size: 50.w,
                              ),
                            ),
                          )
                          .then((value) => Navigator.pop(context));
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
