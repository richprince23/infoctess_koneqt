import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/utils.dart';
import 'package:infoctess_koneqt/screens/admin/manage_event_attendees.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:infoctess_koneqt/widgets/status_snack.dart';
import 'package:resize/resize.dart';

class ManageEventsScreen extends StatefulWidget {
  const ManageEventsScreen({super.key});

  @override
  State<ManageEventsScreen> createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Events'),
      ),
      body: Container(
        color: cSec.withOpacity(0.03),
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            ColoredBox(
              color: cSec.withOpacity(0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Select event to edit or delete  '),
                  Icon(Icons.info_outline_rounded),
                ],
              ),
            ),
            SizedBox(height: 20.w),
            Expanded(
              child: FutureBuilder(
                  future: getEvents(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data?.docs.isEmpty ?? true) {
                        return const Center(
                            child: EmptyList(
                          text: 'No events found',
                        ));
                      }
                      return RefreshIndicator(
                        onRefresh: () {
                          return Future.delayed(
                            const Duration(seconds: 1),
                            () {
                              setState(() {});
                            },
                          );
                        },
                        child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data?.docs[index];
                            return ListTile(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ManageEventAttendeesScreen(
                                      eventID: data?.id ?? '',
                                    ),
                                  ),
                                );
                              },
                              title: Text(data?['title'] ?? 'No title'),
                              subtitle: Text(
                                  "${convertToMonthDayString(data?['date'])}, ${data?['date'].split('/')[2]}"),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  CustomDialog.showWithAction(context,
                                      message:
                                          "Are you sure you want to delete this event?",
                                      alertStyle: AlertStyle.warning,
                                      actionText: "Delete", action: () async {
                                    await db
                                        .collection('events')
                                        .doc(data?.id)
                                        .delete()
                                        .then(
                                          (value) => CustomSnackBar.show(
                                            context,
                                            message:
                                                "Event deleted successfully",
                                          ),
                                        );
                                    setState(() {});
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Image.asset(
                          "assets/images/preload.gif",
                          width: 30.w,
                          height: 30.w,
                        ),
                      );
                    }
                  }),
            ),
            const Spacer(),
            SizedBox(height: 20.w),
            SizedBox(
              width: 100.vw,
              height: 48.w,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cPri,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/new-event');
                },
                child:
                    Text('Create New Event', style: TextStyle(fontSize: 16.sp)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getEvents() async =>
      await db.collection('events').orderBy("date", descending: true).get();
}
