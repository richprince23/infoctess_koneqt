import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/news_item.dart';
import 'package:infoctess_koneqt/components/event_item.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // color: Colors.blue,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.black38, Colors.blue, Colors.pink],
          stops: [0.1, 0.2, 1],
        ),
      ),
      height: double.infinity,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
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
      ),
    );
  }
}
