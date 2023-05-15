import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
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

  Event({
    required this.id,
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
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      imgUrl: json['imgUrl'],
      date: json['date'],
      time: json['time'],
      fee: int.parse(json['fee']),
      venue: json['venue'],
      mode: json['mode'],
      posterID: json['posterID'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
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
      };
}
