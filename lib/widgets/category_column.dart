import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/task_manager.dart';

import '../widgets/task_card.dart';

import '../enums.dart';

class CategoryColumn extends StatelessWidget {
  final type;
  const CategoryColumn({this.type});

  String get typeText {
    if (type == TaskStatus.Open) {
      return "Open:";
    } else if (type == TaskStatus.InProgress) {
      return "In Progress:";
    } else if (type == TaskStatus.Done) {
      return "Done:";
    } else {
      return "Unknown";
    }
  }

  Color get typeColor {
    if (type == TaskStatus.Open) {
      return Colors.green;
    } else if (type == TaskStatus.InProgress) {
      return Colors.amber;
    } else if (type == TaskStatus.Done) {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }

  String get emptyListText {
    if (type == TaskStatus.Open) {
      return "No Open Task To Show";
    } else if (type == TaskStatus.InProgress) {
      return "No In Progress Task To Show";
    } else if (type == TaskStatus.Done) {
      return "No Done Task To Show";
    } else {
      return "";
    }
  }

  bool isTasksListEmpty(TaskManager tm) {
    if (type == TaskStatus.Open) {
      return tm.openTasks.isEmpty;
    } else if (type == TaskStatus.InProgress) {
      return tm.inProgressTasks.isEmpty;
    } else if (type == TaskStatus.Done) {
      return tm.doneTasks.isEmpty;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskManager = Provider.of<TaskManager>(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    typeText,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Ubuntu",
                      // color: Colors.black.withOpacity(0.5),
                      color: Colors.white,
                    ),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(Icons.add),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(),
                    );
                  },
                  color: Colors.white,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: typeColor,
                      blurRadius: 6.0,
                      spreadRadius: 3.0,
                    )
                  ],
                ),
                child: DragTarget<Task>(
                  builder: (context, candidateData, rejectedData) {
                    return isTasksListEmpty(taskManager)
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FittedBox(
                                child: Text(
                              "${emptyListText}\n🙂",
                              style: TextStyle(
                                fontFamily: "Ubuntu",
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            )),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: taskManager
                                  .getTasksByStatus(type)
                                  .map((task) => TaskCard(task.taskId))
                                  .toList(),
                            ),
                          );
                  },
                  onWillAccept: (task) => type != task.status,
                  onAccept: (task) =>
                      taskManager.changeTaskStatus(task.taskId, type),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
