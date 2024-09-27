class Task {
  String name;
  String description;
  bool isCompleted;
  DateTime startDate;
  DateTime endDate;

  Task({
    required this.name,
    required this.description,
    required this.isCompleted,
    required this.startDate,
    required this.endDate,
  });
}

class TaskStorage {
  final List<Task> tasks = [];

  static final TaskStorage _instance = TaskStorage._internal();

  factory TaskStorage() {
    return _instance;
  }

  TaskStorage._internal();
}
