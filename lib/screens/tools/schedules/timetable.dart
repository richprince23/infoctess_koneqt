import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infoctess_koneqt/app_db.dart';
import 'package:infoctess_koneqt/models/timetable_db.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class AllSchedules extends StatefulWidget {
  const AllSchedules({super.key});

  @override
  State<AllSchedules> createState() => AllSchedulesState();
}

class AllSchedulesState extends State<AllSchedules> {
  bool isLoading = false;
  List<Timetable> allScehdules = [];
  List<Timetable> todaySchedules = [];
  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  Future getAllSchedules() async {
    setState(() {
      isLoading = true;
    });
    allScehdules = await AppDatabase.instance.getAllSchedules();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllSchedules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Timetable'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.today),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/add-schedule'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.themeData(false, context).backgroundColor,
        strokeWidth: 3,
        displacement: 10,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: AppTheme.themeData(false, context).backgroundColor,
              ))
            : Container(
                decoration: const BoxDecoration(
                  // color: Colors.blue,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue, Colors.pink],
                    stops: [0.2, 1],
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                  // child: buildAllSchedules(),
                  child: ListView(
                    children: generateExpansionTiles(),
                  ),
                ),
              ),
        onRefresh: () async {
          getAllSchedules();
          generateExpansionTiles();
          setState(() {
            // buildAllSchedules();
          });
        },
      ),
    );
  }

  List<ExpansionTile> generateExpansionTiles() {
    List<ExpansionTile> expansionTiles = [];
    for (String weekday in weekdays) {
      expansionTiles.add(
        ExpansionTile(
          textColor: Colors.white,
          collapsedBackgroundColor: AppTheme.themeData(false, context)
              .backgroundColor
              .withOpacity(0.3),
          collapsedTextColor: Colors.white,
          // backgroundColor: Colors.black,
          subtitle: Text(allScehdules
                  .where((element) => element.day == weekday)
                  .toList()
                  .isEmpty
              ? 'No schedules yet'
              : "${allScehdules.where((element) => element.day == weekday).toList().length.toString()} schedules"),
          title: Text(weekday),
          children: [
            SizedBox(
              height: allScehdules
                      .where((element) => element.day == weekday)
                      .toList()
                      .length *
                  80,
              child: ListView.builder(
                itemCount: allScehdules
                    .where((element) => element.day == weekday)
                    .toList()
                    .length,
                itemBuilder: (context, index) {
                  List<Timetable> schedules = allScehdules
                      .where((element) => element.day == weekday)
                      .toList();
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
                                          content:
                                              const Text("Delete this course?"),
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
                                                    .deleteSchedule(
                                                        schedules[index].id!)
                                                    .then(
                                                      (value) =>
                                                          getAllSchedules()
                                                              .then(
                                                        (value) =>
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                "${schedules[index].courseTitle} deleted from timetable"),
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
                                          content:
                                              const Text("Delete this course?"),
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
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  elevation: 0,
                                                  foregroundColor: Colors.white,
                                                  backgroundColor:
                                                      Colors.red.shade600),
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                await AppDatabase.instance
                                                    .deleteSchedule(
                                                        schedules[index].id!)
                                                    .then(
                                                      (value) =>
                                                          getAllSchedules()
                                                              .then(
                                                        (value) =>
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                "${schedules[index].courseTitle} deleted from timetable"),
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
                      color: AppTheme.themeData(false, context)
                          .cardColor
                          .withOpacity(0.5),
                      child: ListTile(
                        title: Text(schedules[index].courseTitle ?? ''),
                        subtitle: Text(schedules[index].startTime ?? ''),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    }
    return expansionTiles;
  }
}
