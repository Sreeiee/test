import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime dueDate;

  @HiveField(3)
  String priority;

  @HiveField(4)
  bool isCompleted;

  Task({
    required this.title,
    this.description = '',
    required this.dueDate,
    this.priority = 'Low',
    this.isCompleted = false,
  });
}
