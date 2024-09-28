// task_storage.dart

class StorageTask {
  String name;
  String description;
  DateTime startDate;
  DateTime endDate;
  bool isCompleted;

  StorageTask({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
  });
}

class TaskStorage {
  List<StorageTask> tasks = [];

}
