import 'package:cloud_firestore/cloud_firestore.dart';

const String eventsTable = "events";

class Event {
  final String? id;
  final String title;
  final String body;
  final String? imgUrl;
  final String? date;
  final String? time;
  final int? fee;
  final String? venue;
  final String? mode;
  final String? posterID;
  final DateTime? timestamp;
  final List<String>? attendees;

  Event({
    this.id,
    required this.title,
    required this.body,
    this.imgUrl,
    this.date,
    this.time,
    this.fee = 0,
    this.venue,
    this.mode,
    this.posterID,
    this.timestamp,
    this.attendees,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      imgUrl: json['imgUrl'],
      date: json['date'],
      time: json['time'],
      fee: json['fee'],
      venue: json['venue'],
      mode: json['mode'],
      posterID: json['posterID'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      attendees: json['attendees'] != null
          ? List<String>.from(json['attendees'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id ?? "",
        'title': title,
        'body': body,
        'imgUrl': imgUrl,
        'date': date,
        'time': time,
        'fee': fee,
        'venue': venue,
        'mode': mode,
        'posterID': posterID,
        'timestamp': timestamp!,
        'attendees': attendees,
      };

  Event copy({
    var id,
    var title,
    var body,
    var imgUrl,
    var date,
    var time,
    var fee,
    var venue,
    var mode,
    var posterID,
    var timestamp,
    var attendees,
  }) =>
      Event(
        id: id ?? this.id ?? "",
        title: title ?? this.title,
        body: body ?? this.body,
        imgUrl: imgUrl ?? this.imgUrl,
        date: date ?? this.date,
        time: time ?? this.time,
        fee: fee ?? 0,
        venue: venue ?? this.venue,
        mode: mode ?? this.mode,
        posterID: posterID ?? this.posterID,
        timestamp: timestamp ?? this.timestamp,
        attendees: attendees ?? this.attendees,
      );
}

class EventModel {
  static const id = 'id';
  static const posterID = 'posterID';
  static const title = 'title';
  static const body = 'body';
  static const imgUrl = 'imgUrl';
  static const timestamp = 'timestamp';
  static const date = 'date';
  static const time = 'time';
  static const fee = 'fee';
  static const venue = 'venue';
  static const mode = 'mode';
  static const attendees = 'attendees';
}
