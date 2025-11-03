import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String task;
  final bool isDone;
  final Timestamp? timestamp;

  Todo({
    required this.id,
    required this.task,
    required this.isDone,
    this.timestamp,
  });

  // Factory constructor to create a Todo instance from a Firestore document
  factory Todo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Todo(
      id: doc.id,
      task: data['task'] ?? '',
      isDone: data['isDone'] ?? false,
      timestamp: data['timestamp'] as Timestamp?,
    );
  }
}
