import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package
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
        title: Text(
          _translatedTitle ?? 'Task Manager',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            Colors.deepOrangeAccent, // Orange theme color for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0), // Full-screen padding
        child: SingleChildScrollView(
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
                  decoration: InputDecoration(
                    labelText: 'Search Tasks',
                    labelStyle: GoogleFonts.roboto(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: Icon(Icons.search,
                        color: Colors.deepOrange), // Orange icon
                  ),
                ),
              ),
              _taskStorage.tasks.isEmpty
                  ? Center(
                      child: Text(
                        _translatedNoTasks ?? 'No tasks available. Add a task!',
                        style: GoogleFonts.roboto(
                            fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _taskStorage.tasks
                          .where((task) => task.name
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                          .length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
        backgroundColor: Colors.deepOrange, // Orange theme color for FAB
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  final Function(Task) onAddTask;
  final Task? existingTask;

  const AddTaskScreen({super.key, required this.onAddTask, this.existingTask});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: existingTask?.name);
    final TextEditingController descriptionController =
        TextEditingController(text: existingTask?.description);
    DateTime? startDate = existingTask?.startDate;
    DateTime? endDate = existingTask?.endDate;

    return Scaffold(
      appBar: AppBar(
        title: Text(existingTask == null ? 'Add a New Task' : 'Edit Task'),
        backgroundColor: Colors.deepOrange, // Orange theme color for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
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
                backgroundColor: Colors.white, // Set consistent color
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Task Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(existingTask == null ? 'Add Task' : 'Update Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange, // Custom color for button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    onToggleCompletion();
                  },
                  activeColor: Colors.deepOrange, // Orange checkbox color
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<int>(
                  onSelected: (value) {
                    if (value == 0) {
                      onEdit();
                    } else if (value == 1) {
                      onDelete();
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
                  icon: const Icon(Icons.more_vert, color: Colors.deepOrange),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Date range container styled similar to the image
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color:
                    Colors.deepOrange.shade50, // Light orange shade for the box
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      color: Colors.deepOrange, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${formatDate(task.startDate)} - ${formatDate(task.endDate)}',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    // You can use any date formatting package like intl
    return '${date.day} ${monthAbbreviation(date.month)}, ${date.year}';
  }

  String monthAbbreviation(int month) {
    // Returns month abbreviation based on month number
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
