import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/models/courses_db.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';

class ManageCourses extends StatefulWidget {
  const ManageCourses({Key? key}) : super(key: key);

  @override
  State<ManageCourses> createState() => _ManageCoursesState();
}

class _ManageCoursesState extends State<ManageCourses> {
  late List<Course> courses;

  bool isLoading = false;

  readCourse() {
    var res = AppDatabase.instance.getCourse(0);
    setState(() {
      // courses.add(res);
    });
  }

  @override
  void initState() {
    super.initState();
    readCourses();
    // PortalDatabase.instance.delDB();
  }

  @override
  void dispose() {
    courses.clear();
    super.dispose();
  }

  Future readCourses() async {
    setState(() {
      isLoading = true;
    });
    courses = await AppDatabase.instance.getCourses();

    setState(() {
      isLoading = false;
    });
  }

  Widget buildCourses() => ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, int index) {
        var course = courses[index];
        return Slidable(
          direction: Axis.horizontal,
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                // An action can be bigger than the others.
                flex: 1,
                onPressed: (context) async {
                  Platform.isIOS
                      ? showCupertinoDialog(
                          context: context,
                          builder: ((context) => CupertinoAlertDialog(
                                content: const Text("Delete this course?"),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await AppDatabase.instance
                                          .deleteCourse(course.id!)
                                          .then(
                                            (value) => readCourses().then(
                                              (value) =>
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "${course.courseTitle} deleted"),
                                                ),
                                              ),
                                            ),
                                          );
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              )),
                        )
                      : showDialog(
                          context: context,
                          builder: ((context) => AlertDialog(
                                content: const Text("Delete this course?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 0,
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.red.shade600),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await AppDatabase.instance
                                          .deleteCourse(course.id!)
                                          .then(
                                            (value) => readCourses().then(
                                              (value) =>
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                const SnackBar(
                                                  content:
                                                      Text("Course deleted"),
                                                ),
                                              ),
                                            ),
                                          );
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              )),
                        );
                },
                borderRadius: BorderRadius.circular(10),
                backgroundColor: Colors.red.shade300,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
              SlidableAction(
                onPressed: (context) {},
                borderRadius: BorderRadius.circular(10),
                backgroundColor: Colors.blue.shade300,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            surfaceTintColor: Colors.white.withOpacity(0.5),
            color:
                AppTheme.themeData(false, context).cardColor.withOpacity(0.5),
            child: ListTile(
              // tileColor: ThemeData.light().secondaryHeaderColor,
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(CupertinoIcons.book),
              subtitle: Text(
                  "Level:  ${course.level.toString()} ${course.semester} Credit Hours: ${course.creditHours} "),
              // subtitle: Text(course.courseCode.toString()),
              // title: course.courseTitle, // replace with course code and semester
              title: Text(
                course.courseTitle.toString(),
                style: const TextStyle(fontSize: 18),
              ),

              onTap: () {},
            ),
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Courses"),
        centerTitle: true,
        leading: IconButton(
          icon: const BackButtonIcon(),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // backgroundColor: AppTheme.themeData(false, context).backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/add-course');
            },
            icon: const Icon(Icons.add),
            tooltip: "Add new course",
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: isLoading
            ? Center(
                child: Image.asset(
                "assets/images/preload.gif",
                height: 20.h,
                width: 20.h,
              ))
            : courses.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EmptyList(
                        text: "No courses added\nAdd courses to view them here",
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/add-course');
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add Course"),
                      ),
                    ],
                  )
                : buildCourses(),
      ),
    );
  }
}
