import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/auth.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/events_controller.dart';
import 'package:infoctess_koneqt/screens/user_screens/profile_screen.dart';
import 'package:infoctess_koneqt/widgets/custom_dialog.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';

class ManageEventAttendeesScreen extends StatefulWidget {
  final String eventID;
  const ManageEventAttendeesScreen({super.key, required this.eventID});
  // const ManageEventAttendeesScreen({super.key});

  @override
  State<ManageEventAttendeesScreen> createState() =>
      _ManageEventAttendeesScreenState();
}

class _ManageEventAttendeesScreenState
    extends State<ManageEventAttendeesScreen> {
  @override
  void initState() {
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
        title: const Text('Manage Event Attendees'),
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
                  Text('Select User to edit or delete  '),
                  Icon(Icons.info_outline_rounded),
                ],
              ),
            ),
            SizedBox(height: 20.w),
            Expanded(
              child: FutureBuilder(
                  future: getEventAttendees(widget.eventID),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data?.isEmpty ?? true) {
                        return const Center(
                            child: EmptyList(
                          text: 'No Attendees found for this event',
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
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            // final data = snapshot.data?[index];
                            Map<String, dynamic>? user;

                            // if (user != null) {
                            return FutureBuilder(
                                future: getUserDetails(snapshot.data?[index]),
                                builder: (context, userDetails) {
                                  // if (userDetails.hasData) {
                                  user = userDetails.data;
                                  // }
                                  if (userDetails.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: Image.asset(
                                        "assets/images/preload.gif",
                                        width: 30.w,
                                        height: 30.w,
                                      ),
                                    );
                                  }

                                  if (userDetails.hasError) {
                                    return const Center(
                                      child: Text("Error"),
                                    );
                                  }
                                  if (userDetails.data!.isEmpty) {
                                    return const Center(
                                        child: EmptyList(
                                      text: "",
                                    ));
                                  }

                                  return ListTile(
                                    onTap: () {},
                                    title: Text(user?["fullName"]),
                                    subtitle: Text(user?["userLevel"]),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UserProfile(
                                                userID: user?["userID"]),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.info_outline),
                                    ),
                                  );
                                });
                          },
                        ),
                      );
                    }
                    return Center(
                      child: Image.asset("assets/images/preload.gif"),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
