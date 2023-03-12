import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/models/courses_db.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

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
    '500',
    '600',
    '700',
    '800',
    '900'
  ];

  late List<Course> courses;
  List<Course> courseList = [];
  bool isLoading = false;

  var semValue, levelValue;

  Future newCourse() async {
    // if (keys.currentState!.validate()) {
    //     // int index = courses.length;
    Course course = Course(
      courseCode: _cCode.text,
      courseTitle: _cTitle.text,
      creditHours: _cCHours.text,
      level: levelValue.toString(),
      semester: semValue.toString(),
    );

    await AppDatabase.instance.addCourse(course);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Add Course",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppTheme.themeData(false, context).backgroundColor,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () async {
                Navigator.pop(context);
              })),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // color: Colors.black87,
            alignment: Alignment.center,
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            constraints: BoxConstraints.expand(
              width: MediaQuery.of(context).size.width * .8,
              height: MediaQuery.of(context).size.height,
            ),
            child: Form(
              key: keys,
              // autovalidateMode: AutovalidateMode.always,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InputControl(
                    hintText: "Course Code",
                    controller: _cCode,
                  ),
                  // CustomField(
                  //   title: "Course Code",
                  //   controller: _cCode,
                  // ),
                  InputControl(
                    hintText: "Course Title",
                    controller: _cTitle,
                  ),
                  // CustomField(
                  //   title: "Course Title",
                  //   controller: _cTitle,
                  // ),
                  DropdownButtonFormField<String>(
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "Raleway"),
                      menuMaxHeight: 200,
                      decoration: InputDecoration(
                          fillColor: const Color.fromRGBO(209, 209, 209, 0.35),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          // labelText: "Semester",
                          hintText: "Level",
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: "Raleway"),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.pinkAccent,
                                width: 3,
                              )),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25))),
                      items: levels.map((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          levelValue = newValue;
                        });
                      },
                      validator: (e) {
                        if (e == null) {
                          return "Please fill this field";
                        } else {
                          return null;
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: "Raleway"),
                    decoration: InputDecoration(
                        fillColor: const Color.fromRGBO(209, 209, 209, 0.35),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        // labelText: "Semester",
                        hintText: "Semester",
                        hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: "Raleway"),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Colors.pinkAccent,
                              width: 3,
                            )),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(25))),
                    items: sems.map((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        semValue = newValue;
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
                  // CustomField(
                  //   title: "Credit Hours",
                  //   controller: _cCHours,
                  //   type: TextInputType.number,
                  // ),
                  InputControl(
                    hintText: "Credit Hours",
                    controller: _cCHours,
                    type: TextInputType.number,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height > 760 ? 60 : 40,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.pinkAccent,
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (keys.currentState!.validate()) {
                          await newCourse().then((value) {
                            // print(value);
                            Navigator.of(context).popAndPushNamed('/courses');
                          });
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Raleway",
                            fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
