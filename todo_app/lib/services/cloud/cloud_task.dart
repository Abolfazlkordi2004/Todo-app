import 'package:cloud_firestore/cloud_firestore.dart';

class CloudTask {
  final String documentId;
  final String ownerUserId;
  final String title;
  final String text;
  final String time;
  final String date;

  CloudTask({
    required this.documentId,
    required this.ownerUserId,
    required this.title,
    required this.text,
    required this.time,
    required this.date,
  });

  // Factory method to create a CloudTask from a Firestore document snapshot
  factory CloudTask.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CloudTask(
      documentId: snapshot.id,
      ownerUserId: data['ownerUserId'] ?? '',
      title: data['title'] ?? '',
      text: data['text'] ?? '',
      time: data['time'] ?? '',
      date: data['date'] ?? '',
    );
  }

  // Method to convert CloudTask to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'ownerUserId': ownerUserId,
      'title': title,
      'text': text,
      'time': time,
      'date': date,
    };
  }
}
