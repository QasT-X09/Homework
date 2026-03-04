import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get tasks => db.collection("tasks");

  QueryDocumentSnapshot? lastDocument;

  /// CREATE
  Future<void> addTask({
    required String title,
    required String category,
  }) async {

    await tasks.add({
      "title": title,
      "category": category,
      "status": "open",
      "tags": [],
      "createdAt": FieldValue.serverTimestamp(),
      "userId": uid
    });

  }

  /// UPDATE
  Future<void> updateTask(String id, Map<String, dynamic> data) async {

    await tasks.doc(id).update(data);

  }

  /// DELETE
  Future<void> deleteTask(String id) async {

    await tasks.doc(id).delete();

  }

  /// REALTIME LIST
  Stream<QuerySnapshot> taskStream() {

    return db
        .collection("tasks")
        .where("userId", isEqualTo: uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// PAGINATION
  Future<List<QueryDocumentSnapshot>> loadTasks() async {

    Query query = db
        .collection("tasks")
        .where("userId", isEqualTo: uid)
        .orderBy("createdAt", descending: true)
        .limit(10);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      lastDocument = snapshot.docs.last;
    }

    return snapshot.docs;

  }

  /// FILTER BY STATUS
  Stream<QuerySnapshot> filterByStatus(String status) {

    return db
        .collection("tasks")
        .where("userId", isEqualTo: uid)
        .where("status", isEqualTo: status)
        .snapshots();

  }

  /// SEARCH BY TAG
  Stream<QuerySnapshot> searchByTag(String tag) {

    return db
        .collection("tasks")
        .where("userId", isEqualTo: uid)
        .where("tags", arrayContains: tag)
        .snapshots();

  }

}
