// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:todo_app/services/cloud/cloud_storage_exception.dart';
// import 'package:todo_app/services/cloud/cloud_task.dart';

// class FirebaseCloudStorage {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   Future<CloudTask> createNewTask({required String ownerUserId}) async {
//     final docRef = _db.collection('tasks').doc();
//     final newTask = CloudTask(
//       documentId: docRef.id,
//       title: '',
//       text: '',
//       time: '',
//       date: '',
//       ownerUserId: '',
//     );
//     try {
//       await docRef.set({
//         'ownerUserId': ownerUserId,
//         'title': newTask.title,
//         'text': newTask.text,
//         'time': newTask.time,
//         'date': newTask.date,
//       });
//     } catch (e) {
//       throw CouldNotCreateTaskException();
//     }
//     return newTask;
//   }

//   Future<void> updateTask({
//     required String documentId,
//     required String title,
//     required String text,
//     required String time,
//     required String date,
//   }) async {
//     try {
//       await _db.collection('tasks').doc(documentId).update({
//         'title': title,
//         'text': text,
//         'time': time,
//         'date': date,
//       });
//     } catch (e) {
//       throw CouldNotUpdateTaskException();
//     }
//   }

//   Future<void> deleteTask({required String documentId}) async {
//     try {
//       await _db.collection('tasks').doc(documentId).delete();
//     } catch (e) {
//       throw CouldNotDeleteTaskException();
//     }
//   }

//   Stream<List<CloudTask>> allTasks({required String ownerUserId}) {
//     try {
//       return _db
//           .collection('tasks')
//           .where('ownerUserId', isEqualTo: ownerUserId)
//           .snapshots()
//           .map((snapshot) {
//         return snapshot.docs.map((doc) {
//           return CloudTask.fromSnapshot(doc);
//         }).toList();
//       });
//     } catch (e) {
//       throw CouldNotGetAllTaskException();
//     }
//   }
// }
