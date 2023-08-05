import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/components/select_control1.dart';
import 'package:infoctess_koneqt/models/courses_db.dart';
import 'package:resize/resize.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({Key? key}) : super(key: key);

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final keys = GlobalKey<FormState>();

  final TextEditingController _cCode = TextEditingController();
  final TextEditingController _cTitle = TextEditingController();
  // final TextEditingController _cYear = TextEditingController();
  // final TextEditingController _cSem = TextEditingController();
  final TextEditingController _cCHours = TextEditingController();

  final List<String> sems = ["Semester 1", "Semester 2"];

  final List<String> levels = [
    '100',
    '200',
    '300',
    '400',
  ];

  late List<Course> courses;
  List<Course> courseList = [];
  bool isLoading = false;

  late String semValue, levelValue;

  Future newCourse() async {
    // if (keys.currentState!.validate()) {
    //     // int index = courses.length;
    Course course = Course(
      courseCode: _cCode.text.toUpperCase(),
      courseTitle: _cTitle.text,
      creditHours: int.parse(_cCHours.text),
      level: int.parse(levelValue),
      semester: semValue.toString(),
    );

    await AppDatabase.instance.addCourse(course);
    // }
  }

  @override
  void dispose() {
    _cCode.dispose();
    _cTitle.dispose();
    // _cYear.dispose();
    // _cSem.dispose();
    _cCHours.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Course",
          // style: TextStyle(
          //   color: Colors.white,
          // ),
        ),
        centerTitle: true,
        elevation: 0,
        // backgroundColor: AppTheme.themeData(false, context).backgroundColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: keys,
            // autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputControl(
                  hintText: "Course Code",
                  controller: _cCode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Course Code is required";
                    }
                    return null;
                  },
                ),
                // CustomField(
                //   title: "Course Code",
                //   controller: _cCode,
                // ),
                InputControl(
                  hintText: "Course Title",
                  controller: _cTitle,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Course Title is required";
                    }
                    return null;
                  },
                ),

                SelectControl(
                  hintText: "Level",
                  items: levels.map((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      levelValue = newValue!;
                    });
                  },
                  validator: (e) {
                    if (e == null) {
                      return "Please fill this field";
                    } else {
                      return null;
                    }
                  },
                ),

                SelectControl(
                  hintText: "Semester",
                  items: sems.map((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      semValue = newValue!;
                    });
                  },
                  validator: (e) {
                    if (e == null) {
                      return "Please fill this field";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),

                InputControl(
                  hintText: "Credit Hours",
                  controller: _cCHours,
                  type: TextInputType.number,
                  validator: (e) {
                    if (e == null) {
                      return "Please fill this field";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(74, 19, 193, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: Size(size.width, 56),
                  ),
                  onPressed: () async {
                    if (keys.currentState!.validate()) {
                      await newCourse().then((value) {
                        // print(value);
                        Navigator.of(context).popAndPushNamed('/my-courses');
                      });
                    }
                  },
                  child: Text(
                    "save",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
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
