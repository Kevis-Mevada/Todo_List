import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/firestore_service.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  final TextEditingController _taskController = TextEditingController();

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C3E50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add New Task'),
          content: TextField(
            controller: _taskController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'What do you want to do?',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
              onPressed: () {
                _taskController.clear();
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary),
              child:
              const Text('Add', style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  _firestoreService.addTodo(
                      widget.user.uid, _taskController.text);
                  _taskController.clear();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Welcome, ${widget.user.displayName?.split(' ')[0] ?? 'User'}!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Todo>>(
        stream: _firestoreService.getTodos(widget.user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox_rounded, size: 100, color: Colors.white24),
                  const SizedBox(height: 20),
                  const Text('No tasks yet.', style: TextStyle(fontSize: 22)),
                  const Text('Tap "+" to add your first task.',
                      style: TextStyle(color: Colors.white54)),
                ],
              ),
            );
          }

          final todos = snapshot.data!;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Animate(
                effects: const [FadeEffect(), SlideEffect(begin: Offset(0, 0.5))],
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 4,
                    color: todo.isDone ? Colors.grey.withOpacity(0.2) : const Color(0xFF2C3E50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      leading: Checkbox(
                        value: todo.isDone,
                        onChanged: (val) {
                          _firestoreService.updateTodoStatus(
                              widget.user.uid, todo.id, val!);
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                        checkColor: Colors.white,
                      ),
                      title: Text(
                        todo.task,
                        style: TextStyle(
                          fontSize: 18,
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: todo.isDone ? Colors.white54 : Colors.white,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent),
                        onPressed: () => _firestoreService.deleteTodo(
                            widget.user.uid, todo.id),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ).animate().scale(delay: 500.ms),
    );
  }
}
