import 'dart:convert';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/event_item.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/events_controller.dart';
import 'package:infoctess_koneqt/models/event_model.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:intl/intl.dart';
import 'package:resize/resize.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  List<Event> userEvents = []; // List of user's events
  late var selectedDate;

  @override
  void initState() {
    selectedDate = DateTime.parse(DateTime.now().toString());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Calendar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              child: Container(
                padding: EdgeInsets.all(10.h),
                child: CalendarTimeline(
                  showYears: true,
                  initialDate: selectedDate,
                  firstDate: DateTime(2023, 5, 1),
                  lastDate: DateTime(2030, 11, 20),
                  onDateSelected: (date) => {
                    setState(() {
                      selectedDate = date;
                    }),
                  },
                  leftMargin: 20,
                  monthColor: cPri.withOpacity(0.5),
                  dayColor: cPri,
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: cSec,
                  // dotsColor: Color(0xFF333A47),
                  // selectableDayPredicate: (date) => date.day >= DateTime.now().day,
                  locale: 'en_ISO',
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: cSec.withOpacity(0.05),
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: getEventsByDate(
                      DateFormat('d/MM/yyyy').format(selectedDate)),
                  // "15/05/2023"),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Image.asset(
                          'assets/images/preload.gif',
                          height: 30.w,
                          width: 30.w,
                        ),
                      );
                    }
                    if (snapshot.data == null || snapshot.data?.docs.isEmpty) {
                      return Center(
                        child: EmptyList(
                          text:
                              "You haven't booked any events for today\nBook an event to see it here",
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.all(10.w),
                            surfaceTintColor: Colors.white,
                            color: Colors.white,
                            // padding: EdgeInsets.all(10.w),

                            child: ListTile(
                              onTap: () {
                                // print('${snapshot.data.docs[index].id}');
                                // print('${snapshot.data.docs[index].data()}');
                                Event event = Event.fromJson(
                                    snapshot.data.docs[index].data());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return OpenEventItem(
                                        event: event.copy(
                                            id: snapshot.data.docs[index].id,
                                            timestamp: null),
                                      );
                                    },
                                  ),
                                );
                              },
                              isThreeLine: true,
                              leading: Icon(
                                Icons.event,
                                color: cPri,
                              ),
                              title: Text(
                                snapshot.data.docs[index]['title'] + "\n",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.sp + 1,
                                ),
                              ),
                              // trailing: Text(
                              //   snapshot.data.docs[index]['mode'],
                              // ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Text(
                                      snapshot.data.docs[index]['venue'],
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 10.w,
                                  // ),
                                  Text(
                                    snapshot.data.docs[index]['time']
                                        .toString()
                                        .trim(),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
