import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/events_controller.dart';
import 'package:infoctess_koneqt/models/event_model.dart';
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
        title: const  Text('My Calendar'),
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
                  initialDate: DateTime.parse(DateTime.now().toString()),
                  firstDate: DateTime.parse(DateTime.now().toString()),
                  lastDate: DateTime(2030, 11, 20),
                  onDateSelected: (date) => selectedDate = date,
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
              color: Colors.white,
              child: FutureBuilder(
                  // future: getEventsByDate(
                  //     // DateFormat("d/M/yyyy").format(selectedDate)),
                  //     "15/05/2023"),
                  builder: (context, AsyncSnapshot snapshot) {
                print(snapshot.data);
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index]['title']),
                        subtitle: Text(snapshot.data[index]['description']),
                        trailing: Text(
                          DateFormat('dd/MM/yyyy')
                              .format(snapshot.data[index]['date']),
                        ),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
            ),
          ),
        ],
      ),
    );
  }
}
