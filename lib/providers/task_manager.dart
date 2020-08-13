import 'package:flutter/cupertino.dart';

import '../enums.dart';

class Task extends ChangeNotifier {
  String taskOwner;
  String title;
  String description;
  Duration timeToFinish;
  TaskStatus status;
  String taskId;
  Task({
    this.taskOwner,
    this.title,
    this.description,
    this.timeToFinish,
    this.status = TaskStatus.Open,
    this.taskId,
  });
  //  {
  //   taskId = DateTime.now().toIso8601String();
  // }
}

class TaskManager extends ChangeNotifier {
  List<Task> _tasks = [
    Task(
      taskId: "dnsj",
      title: "Check the Documentation",
      description:
          "Check the Documentation and make sure that all the parameters are placed correctly",
      status: TaskStatus.Open,
      taskOwner: "Parsa",
      timeToFinish: Duration(hours: 1, minutes: 30),
    ),
    Task(
      taskId: "jjbkbk",
      title: "Check the Documentation",
      description:
          "Check the Documentation and make sure that all the parameters are placed correctly",
      status: TaskStatus.Open,
      taskOwner: "Ali",
      timeToFinish: Duration(hours: 2),
    )
  ];

  List<Task> get tasks {
    return _tasks;
  }

  List<Task> getTasksByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  Task getSingleTask(String taskId) {
    return _tasks.firstWhere((task) => task.taskId == taskId);
  }

  void addTask({
    String taskOwner,
    String title,
    String description,
    Duration timeToFinish,
    TaskStatus status,
  }) {
    _tasks.add(
      Task(
        taskOwner: taskOwner,
        title: title,
        description: description,
        timeToFinish: timeToFinish,
        status: status,
      ),
    );
    notifyListeners();
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.taskId == taskId);
    notifyListeners();
  }

  List<Task> get openTasks {
    return _tasks.where((task) => task.status == TaskStatus.Open).toList();
  }

  List<Task> get inProgressTasks {
    return _tasks
        .where((task) => task.status == TaskStatus.InProgress)
        .toList();
  }

  List<Task> get doneTasks {
    return _tasks.where((task) => task.status == TaskStatus.Done).toList();
  }

  void changeTaskStatus(String taskId, TaskStatus status) {
    final int index = _tasks.indexWhere((task) => task.taskId == taskId);
    _tasks[index].status = status;
    notifyListeners();
  }
}
