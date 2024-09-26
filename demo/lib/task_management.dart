import 'package:flutter/material.dart';

class TaskManagementScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tasks = [
    {'title': 'Book Venue', 'status': 'Pending'},
    {'title': 'Send Invitations', 'status': 'In Progress'},
    {'title': 'Finalize Menu', 'status': 'Completed'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Task Management'),
        ),
        body: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(tasks[index]['title']),
                subtitle: Text('Status: ${tasks[index]['status']}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Action to edit task status
                  },
                ),
              );
            },
             ),
            );
      }
}