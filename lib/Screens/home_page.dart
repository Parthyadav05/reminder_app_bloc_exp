import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/Bloc/reminder_bloc.dart';
import 'package:reminder_app/Bloc/reminder_event.dart';
import 'package:reminder_app/Bloc/reminder_state.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _taskController = TextEditingController();
    TextEditingController _priorityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder App' ,style: TextStyle(color: Colors.cyanAccent),),
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              context.read<reminderBloc>().add(sortReminderEvents(value));
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'High',
                child: Text('Sort by High Priority'),
              ),
              PopupMenuItem(
                value: 'Medium',
                child: Text('Sort by Medium Priority'),
              ),
              PopupMenuItem(
                value: 'Low',
                child: Text('Sort by Low Priority'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<reminderBloc, reminderStates>(
                builder: (context, state) {
                  if (state.listReminderMap == null || state.listReminderMap.isEmpty) {
                    return Center(child: Text("Add Task", style: TextStyle(fontSize: 18, color: Colors.grey)));
                  }
                  return ListView.builder(
                    itemCount: state.listReminderMap.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(state.listReminderMap[index]['Task'].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Priority: ${state.listReminderMap[index]['Priority']}'),
                          leading: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<reminderBloc>().add(deleteReminderEvents(index));
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditDialog(context, index, state.listReminderMap[index]);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            taskInput(_taskController, _priorityController),
            SizedBox(height: 10),
            BlocBuilder<reminderBloc, reminderStates>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<reminderBloc>().add(addReminderEvents({
                      'Task': _taskController.text,
                      'Priority': _priorityController.text,
                      'Time': DateTime.now(),
                    }));
                    _taskController.clear();
                    _priorityController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: Text("Add Task", style: TextStyle(fontSize: 16 ,color: Colors.cyanAccent)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index, Map<String, dynamic> reminder) {
    TextEditingController _editTaskController = TextEditingController(text: reminder['Task']);
    TextEditingController _editPriorityController = TextEditingController(text: reminder['Priority'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editTaskController,
                decoration: InputDecoration(
                  labelText: 'Task',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Enter task',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _editPriorityController,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Enter priority',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<reminderBloc>().add(editReminderEvents(index, {
                  'Task': _editTaskController.text,
                  'Priority': _editPriorityController.text,
                  'Time': reminder['Time'], // Keep the original time
                }));
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget taskInput(TextEditingController taskController, TextEditingController priorityController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Task", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: taskController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Enter task',
          ),
        ),
        SizedBox(height: 20),
        Text("Priority", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: priorityController,

          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: 'Enter priority',
          ),
        ),
      ],
    );
  }
}
