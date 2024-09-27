import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'task_storage.dart'; // Import the task storage class
import 'translation_service.dart'; // Import your translation service

class TaskManagementScreen extends StatefulWidget {
  final String selectedLanguage;

  const TaskManagementScreen({super.key, required this.selectedLanguage});

  @override
  _TaskManagementScreenState createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  final TaskStorage _taskStorage =
      TaskStorage(); // Use singleton for task storage
  String? _translatedTitle;
  String? _translatedNoTasks;
  String? _translatedAddTask;
  String? _translatedTaskPlaceholder;
  String? _translatedCancel;

  // Variable to store search query
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _translateUIStrings();
  }

  Future<void> _translateUIStrings() async {
    // Translation logic
  }

  // Function to show a full-screen modal for adding a new task
  void _showAddTaskModal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(onAddTask: (Task newTask) {
          setState(() {
            _taskStorage.tasks.add(newTask);
          });
          Navigator.pop(context); // Close the add task screen
        }),
      ),
    );
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _taskStorage.tasks[index].isCompleted =
          !_taskStorage.tasks[index].isCompleted;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _taskStorage.tasks.removeAt(index);
    });
  }

  void _editTask(int index) {
    final task = _taskStorage.tasks[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          onAddTask: (Task editedTask) {
            setState(() {
              _taskStorage.tasks[index] = editedTask; // Update the task
            });
            Navigator.pop(context); // Close the edit task screen
          },
          existingTask: task, // Pass existing task for editing
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translatedTitle ?? 'Task Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0), // Make full screen
        child: SingleChildScrollView(
          // Add this to enable scrolling when keyboard opens
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search Tasks',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              _taskStorage.tasks.isEmpty
                  ? Center(
                      child: Text(_translatedNoTasks ??
                          'No tasks available. Add a task!'),
                    )
                  : ListView.builder(
                      itemCount: _taskStorage.tasks
                          .where((task) => task.name
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                          .length,
                      shrinkWrap:
                          true, // Ensure the ListView takes only the required space
                      physics:
                          NeverScrollableScrollPhysics(), // Disable scrolling for ListView
                      itemBuilder: (context, index) {
                        final filteredTasks = _taskStorage.tasks
                            .where((task) => task.name
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase()))
                            .toList();
                        final task = filteredTasks[index];
                        final remainingDays =
                            task.endDate.difference(DateTime.now()).inDays;

                        return TaskCard(
                          task: task,
                          remainingDays: remainingDays,
                          onToggleCompletion: () => _toggleTaskCompletion(
                              _taskStorage.tasks.indexOf(task)),
                          onDelete: () =>
                              _deleteTask(_taskStorage.tasks.indexOf(task)),
                          onEdit: () =>
                              _editTask(_taskStorage.tasks.indexOf(task)),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskModal,
        tooltip: 'Add Task',
        child: const Icon(Icons.add), // "+" icon
      ),
    );
  }
}

// New screen for adding or editing a task
class AddTaskScreen extends StatelessWidget {
  final Function(Task) onAddTask;
  final Task? existingTask; // Optional existing task for editing

  const AddTaskScreen({super.key, required this.onAddTask, this.existingTask});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: existingTask?.name);
    final TextEditingController descriptionController =
        TextEditingController(text: existingTask?.description);
    DateTime? startDate =
        existingTask?.startDate; // Use existing start date if editing
    DateTime? endDate =
        existingTask?.endDate; // Use existing end date if editing

    return Scaffold(
      appBar: AppBar(
        title: Text(existingTask == null ? 'Add a New Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          // Add this to enable scrolling when keyboard opens
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Date Range',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SfDateRangePicker(
                initialSelectedRange: existingTask != null
                    ? PickerDateRange(
                        existingTask!.startDate, existingTask!.endDate)
                    : null,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is PickerDateRange) {
                    startDate = args.value.startDate;
                    endDate = args.value.endDate ?? args.value.startDate;
                  }
                },
                selectionMode: DateRangePickerSelectionMode.range,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Task Description',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(existingTask == null ? 'Add Task' : 'Update Task'),
                onPressed: () {
                  String taskName = titleController.text;
                  String taskDescription = descriptionController.text;
                  if (taskName.isNotEmpty &&
                      startDate != null &&
                      endDate != null) {
                    onAddTask(Task(
                      name: taskName,
                      description: taskDescription,
                      startDate: startDate!,
                      endDate: endDate!,
                      isCompleted: existingTask?.isCompleted ?? false,
                    ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Task Card Widget
class TaskCard extends StatelessWidget {
  final Task task;
  final int remainingDays;
  final VoidCallback onToggleCompletion;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskCard({
    super.key,
    required this.task,
    required this.remainingDays,
    required this.onToggleCompletion,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                onToggleCompletion(); // Toggle completion state
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    task.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Remaining Days: $remainingDays',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            PopupMenuButton<int>(
              onSelected: (value) {
                if (value == 0) {
                  onEdit(); // Edit task
                } else if (value == 1) {
                  onDelete(); // Delete task
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 0,
                  child: Text('Edit Task'),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Text('Delete Task'),
                ),
              ],
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
