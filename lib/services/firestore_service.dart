import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/todo_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get a reference to the user's todos collection
  CollectionReference _todosCollection(String userId) {
    return _db.collection('users').doc(userId).collection('todos');
  }

  // Stream of to-do items
  Stream<List<Todo>> getTodos(String userId) {
    return _todosCollection(userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Todo.fromFirestore(doc)).toList();
    });
  }

  // Add a new to-do
  Future<void> addTodo(String userId, String task) {
    return _todosCollection(userId).add({
      'task': task,
      'isDone': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Update a to-do's status
  Future<void> updateTodoStatus(String userId, String todoId, bool isDone) {
    return _todosCollection(userId).doc(todoId).update({'isDone': isDone});
  }

  // Delete a to-do
  Future<void> deleteTodo(String userId, String todoId) {
    return _todosCollection(userId).doc(todoId).delete();
  }
}
