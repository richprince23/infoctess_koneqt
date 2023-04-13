import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/event_item.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      height: double.infinity,
      child: RefreshIndicator(
        onRefresh: () async => print("refreshed"),
        child: ListView(
          children: const [
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
