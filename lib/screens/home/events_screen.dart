import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/event_item.dart';
import 'package:resize/resize.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: RefreshIndicator(
        onRefresh: () async => print("refreshed"),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 2.0.h),
              child: const EventItem(
                  // event: Event(
                  //   id: "id",
                  //   title: "title",
                  //   body: "body",
                  //   timestamp: DateTime.now(),
                  // ),
                  ),
            );
          },
        ),
      ),
    );
  }
}
