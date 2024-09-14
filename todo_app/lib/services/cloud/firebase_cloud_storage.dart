import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/services/cloud/cloud_storage_constant.dart';
import 'package:todo_app/services/cloud/cloud_storage_exception.dart';
import 'package:todo_app/services/cloud/cloud_task.dart';

class FirebaseCloudStorage {
  final tasks = FirebaseFirestore.instance.collection('Task');

  Future<void> deleteTask({required String documentId}) async {
    try {
      await tasks.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteTaskException();
    }
  }

  Future<void> updateTask(
      {required String documentId,
      required String title,
      required String text,
      required String time,
      required String date}) async {
    try {
      await tasks.doc(documentId).update({
        titleFieldName: title,
        textTaskFieldName: text,
        timeFieldName: time,
        dateFieldName: date
      });
    } catch (e) {
      throw CouldNotUpdateTaskException();
    }
  }

  Stream<Iterable<CloudTask>> allTasks({required String ownerUserId}) =>
      tasks.snapshots().map(
            (event) => event.docs
                .map(
                  (e) => CloudTask.fromSnapshot(e),
                )
                .where(
                  (element) => element.ownerUserId == ownerUserId,
                ),
          );

  Future<CloudTask> createNewTask({required String ownerUserId}) async {
    final docs = await tasks.add({
      ownerUserId: ownerUserId,
      titleFieldName: '',
      textTaskFieldName: '',
      timeFieldName: '',
      dateFieldName: '',
    });
    final fetchTask = await docs.get();
    return CloudTask(
      documentId: fetchTask.id,
      ownerUserId: ownerUserId,
      title: '',
      text: '',
      time: '',
      date: '',
    );
  }

  Future<Iterable<CloudTask>> getTasks({required String ownerUserId}) async {
    try {
      return await tasks
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) => value.docs.map(
              (e) => CloudTask.fromSnapshot(e),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllTaskException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstace();
  FirebaseCloudStorage._sharedInstace();
  factory FirebaseCloudStorage() => _shared;
}
