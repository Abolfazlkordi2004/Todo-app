import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/services/cloud/cloud_storage_constant.dart';

class CloudTask {
  final String ownerUserId;
  final String documentId;
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

  CloudTask.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        title = snapshot.data()[titleFieldName],
        text = snapshot.data()[textTaskFieldName],
        time = snapshot.data()[timeFieldName],
        date = snapshot.data()[dateFieldName];
}
