import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'task_storage.dart'; // Update this to point to your renamed Task class

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  _TaskManagementScreenState createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  final TaskStorage _taskStorage = TaskStorage();
  String _searchQuery = '';

  void _showAddTaskModal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(onAddTask: (StorageTask newTask) {
          setState(() {
            _taskStorage.tasks.add(newTask);
          });
          Navigator.pop(context);
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
          onAddTask: (StorageTask editedTask) {
            setState(() {
              _taskStorage.tasks[index] = editedTask;
            });
            Navigator.pop(context);
          },
          existingTask: task,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Task Manager',
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.deepOrangeAccent,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search Tasks',
                    labelStyle:
                        GoogleFonts.roboto(color: Colors.orange.shade900),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.deepOrange),
                  ),
                ),
                SizedBox(height: 20),
                _taskStorage.tasks.isEmpty
                    ? Center(
                        child: Text(
                          'No tasks available. Add a task!',
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: FloatingActionButton(
            onPressed: _showAddTaskModal,
            backgroundColor: Colors.deepOrange,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ));
  }
}

class AddTaskScreen extends StatelessWidget {
  final Function(StorageTask) onAddTask; // Updated type
  final StorageTask? existingTask; // Updated type

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
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: Text(existingTask == null ? 'Add a New Task' : 'Edit Task'),
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Date Range',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                selectionColor: Colors.orangeAccent,
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
                backgroundColor: Colors.white,
                selectionColor: Colors.orange,
                startRangeSelectionColor: Colors.deepOrangeAccent,
                endRangeSelectionColor: Colors.orangeAccent,
                rangeSelectionColor: Colors.orange.withOpacity(0.3),
                todayHighlightColor: Colors.deepOrange,
                headerStyle: DateRangePickerHeaderStyle(
                  backgroundColor: Colors.orange.withOpacity(0.3),
                  textStyle: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  filled: true,
                  fillColor: Colors.white,
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
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(existingTask == null ? 'Add Task' : 'Update Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final task = StorageTask(
                    // Updated type
                    name: titleController.text,
                    description: descriptionController.text,
                    startDate: startDate ?? DateTime.now(),
                    endDate:
                        endDate ?? DateTime.now().add(const Duration(days: 1)),
                    isCompleted: false,
                  );

                  onAddTask(task);
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
  final StorageTask task; // Updated type
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  Text(
                    task.description,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Remaining Days: $remainingDays',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          remainingDays > 0 ? Colors.green : Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                task.isCompleted
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: Colors.deepOrange,
              ),
              onPressed: onToggleCompletion,
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
