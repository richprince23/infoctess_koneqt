import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/event_item.dart';
import 'package:infoctess_koneqt/components/news_item.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: RefreshIndicator(
        onRefresh: () async => print("refreshed"),
        child: ListView(
          children: [
            EventItem(),
            EventItem(),
            EventItem(),
            EventItem(),
            EventItem(),
            EventItem(),
          ],
        ),
      ),
    );
  }
}
