import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../task_model.dart';

class TaskProvider with ChangeNotifier {
  final Box<Task> _taskBox = Hive.box<Task>('tasks');

  List<Task> get tasks => _taskBox.values.toList();

  void addTask(Task task) {
    _taskBox.add(task);
    notifyListeners();
  }

  void updateTask(int index, Task task) {
    _taskBox.putAt(index, task);
    notifyListeners();
  }

  void deleteTask(int index) {
    _taskBox.deleteAt(index);
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    Task task = _taskBox.getAt(index)!;
    task.isCompleted = !task.isCompleted;
    _taskBox.putAt(index, task);
    notifyListeners();
  }
}
