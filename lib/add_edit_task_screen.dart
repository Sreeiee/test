import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../task_model.dart';
import '../task_provider.dart';

class AddEditTaskScreen extends StatefulWidget {
  final int? taskIndex;

  AddEditTaskScreen({this.taskIndex});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String _description = '';
  late DateTime _dueDate;
  String _priority = 'Low';

  @override
  void initState() {
    super.initState();
    if (widget.taskIndex != null) {
      final task = Provider.of<TaskProvider>(context, listen: false)
          .tasks[widget.taskIndex!];
      _title = task.title;
      _description = task.description;
      _dueDate = task.dueDate;
      _priority = task.priority;
    } else {
      _dueDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskIndex == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.taskIndex == null ? '' : _title,
                decoration: InputDecoration(labelText: 'Task Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration:
                    InputDecoration(labelText: 'Description (Optional)'),
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Due Date:'),
                  Spacer(),
                  TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dueDate = pickedDate;
                        });
                      }
                    },
                    child: Text('${_dueDate.toLocal()}'.split(' ')[0]),
                  ),
                ],
              ),
              DropdownButtonFormField(
                value: _priority,
                items: ['Low', 'Medium', 'High']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Priority'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final taskProvider =
                        Provider.of<TaskProvider>(context, listen: false);
                    final task = Task(
                      title: _title,
                      description: _description,
                      dueDate: _dueDate,
                      priority: _priority,
                    );
                    if (widget.taskIndex == null) {
                      taskProvider.addTask(task);
                    } else {
                      taskProvider.updateTask(widget.taskIndex!, task);
                    }
                    Navigator.pop(context);
                  }
                },
                child:
                    Text(widget.taskIndex == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
