import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/models/courses_db.dart';

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
                flex: 2,
                onPressed: (context) async {
                  await AppDatabase.instance.deleteCourse(course.id).then(
                        (value) => readCourses().then(
                          (value) => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Course deleted"),
                            ),
                          ),
                        ),
                      );
                },
                backgroundColor: Colors.red.shade300,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: Colors.blue.shade300,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),
          child: ListTile(
            tileColor: ThemeData.light().secondaryHeaderColor,
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
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Courses"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
        padding: const EdgeInsets.all(20.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : courses.isEmpty
                ? const Align(
                    alignment: Alignment.center,
                    child: Text("No courses added"))
                : buildCourses(),
      ),
    );
  }
}
