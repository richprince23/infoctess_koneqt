import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/event_item.dart';
import 'package:infoctess_koneqt/models/event_model.dart';
import 'package:infoctess_koneqt/widgets/empty_list.dart';
import 'package:resize/resize.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: RefreshIndicator(
        onRefresh: () async => FirebaseFirestore.instance
            .collection('news')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('events')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Image.asset(
                    "assets/images/preload.gif",
                    width: 50.h,
                    height: 50.h,
                  ),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: EmptyList(
                    text:
                        "There isn't any Events available \nKeeping checking here for updates",
                  ),
                );
              } else {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final newsData = snapshot.data!.docs[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.0.w, vertical: 2.0.h),
                      child: EventItem(
                        event: Event(
                          id: newsData.id,
                          title: newsData.data()['title'],
                          body: newsData.data()['body'],
                          date: newsData.data()['date'],
                          time: newsData.data()['time'],
                          fee: newsData.data()['fee'] ?? 0.0,
                          venue: newsData.data()['venue'],
                          mode: newsData.data()['mode'],
                          posterID: newsData.data()['posterID'],
                          imgUrl: newsData.data()['imgUrl'],
                          timestamp: newsData.data()['timestamp'].toDate(),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
