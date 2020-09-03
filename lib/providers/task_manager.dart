import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:project_management/credentials.dart';
import '../providers/auth.dart';
import 'dart:math' as math;
import 'dart:async';
import 'dart:convert';

import '../enums.dart';

class Task extends ChangeNotifier {
  String taskOwner;
  String title;
  String description;
  DateTime timeToFinish;
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
  TaskManager(this._tasks, {this.authToken, this.userId, this.setAutoLogOut});

  String authToken;
  String userId;
  Timer timer;
  Function setAutoLogOut;

  List<Task> _tasks = [];

  List<Task> get tasks {
    return [..._tasks];
  }

  List<Task> getTasksByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  Task getSingleTask(String taskId) {
    return _tasks.firstWhere((task) => task.taskId == taskId);
  }

  String statusToString(TaskStatus stat) {
    if (stat == TaskStatus.Open) {
      return "open";
    } else if (stat == TaskStatus.InProgress) {
      return "inProgress";
    } else if (stat == TaskStatus.Done) {
      return "done";
    } else {
      return "";
    }
  }

  void tick(Timer t) {
    // print("Called Tick");
    notifyListeners();
  }

  TaskStatus stringToTaskStatus(String stat) {
    // print(stat);
    if (stat == "open") {
      return TaskStatus.Open;
    } else if (stat == "inProgress") {
      return TaskStatus.InProgress;
    } else if (stat == "done") {
      return TaskStatus.Done;
    } else {
      throw Exception("Problem in converting string status to enum status");
    }
  }

  Future<void> fetchData() async {
    http.Response res;
    Map parsedRes;
    // &orderBy="userId"&equalTo="${userId}"
    try {
      res = await http.get(
          '${dbTasksUrl}?auth=${authToken}&orderBy="userId"&equalTo="${userId}"');
      parsedRes = json.decode(res.body);
      // print(parsedRes);
      if (parsedRes != null) {
        _tasks = [];
        parsedRes.forEach((key, value) {
          // print(value["status"]);
          _tasks.add(
            Task(
              title: value["title"],
              description: value["description"],
              status: stringToTaskStatus(value["status"]),
              taskId: key,
              taskOwner: value["taskOwner"],
              timeToFinish: DateTime.parse(value["timeToFinish"]),
            ),
          );
        });
      }
    } catch (err) {
      // print("From task_manger.dart: $err");
      throw err;
    }
    this.timer = Timer.periodic(Duration(seconds: 1), tick);
    // print("Calling setAutoLogOut");
    setAutoLogOut(timer);
    // print("After calling set auto logout");
    notifyListeners();
  }

  Future<void> addTask({
    String taskOwner,
    String title,
    String description,
    DateTime timeToFinish,
    TaskStatus status,
  }) async {
    http.Response response;
    String taskId;
    try {
      response = await http.post(
        "${dbTasksUrl}?auth=${authToken}",
        body: json.encode(
          {
            "userId": userId,
            "title": title,
            "description": description,
            "taskOwner": taskOwner,
            "status": statusToString(status),
            "timeToFinish": timeToFinish.toIso8601String(),
          },
        ),
      );
      if (json.decode(response.body) == null)
        throw Exception("ERROR: Response was empty.");
      taskId = json.decode(response.body)["name"];
    } catch (err) {
      print(err);
      throw err;
    }

    // print("Task Id: $taskId");

    _tasks.add(
      Task(
        taskOwner: taskOwner,
        title: title,
        description: description,
        timeToFinish: timeToFinish,
        status: status,
        taskId: taskId,
      ),
    );
    notifyListeners();
  }

  Future<void> editTask({
    String taskOwner,
    String title,
    String description,
    DateTime timeToFinish,
    TaskStatus status,
    String taskId,
  }) async {
    final _now = DateTime.now();
    http.Response response;
    try {
      response = await http.patch(
        "${dbTasksBase}/${taskId}.json?auth=$authToken",
        body: json.encode(
          {
            "title": title,
            "description": description,
            "taskOwner": taskOwner,
            "status": statusToString(status),
            "timeToFinish": timeToFinish.toIso8601String(),
          },
        ),
      );
      // print(json.decode(response.body));
      if (json.decode(response.body) == null)
        throw Exception("ERROR: Response was empty.");
    } catch (err) {
      print("${err}");
      throw err;
    }

    // print("Task Id: $taskId");

    final taskIndex = _tasks.indexWhere((element) => element.taskId == taskId);

    _tasks[taskIndex] = Task(
      taskOwner: taskOwner,
      title: title,
      description: description,
      timeToFinish: timeToFinish,
      status: status,
      taskId: taskId,
    );
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final res =
          await http.delete("${dbTasksBase}/${taskId}.json?auth=$authToken");
      _tasks.removeWhere((task) => task.taskId == taskId);
      notifyListeners();
    } catch (err) {
      print(err);
    }
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

  Future<void> changeTaskStatus(String taskId, TaskStatus status) async {
    final int index = _tasks.indexWhere((task) => task.taskId == taskId);
    final lastStatus = _tasks[index].status;
    _tasks[index].status = status;
    notifyListeners();
    try {
      await http.patch("${dbTasksBase}/${taskId}.json?auth=$authToken",
          body: json.encode({"status": statusToString(status)}));
    } catch (err) {
      _tasks[index].status = lastStatus;
    }

    notifyListeners();
  }
}
