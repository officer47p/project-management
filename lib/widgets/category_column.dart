import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/task_manager.dart';

import '../widgets/task_card.dart';
import '../widgets/add_task_bottom_sheet.dart';

import '../enums.dart';

class CategoryColumn extends StatefulWidget {
  final type;
  const CategoryColumn({this.type});

  @override
  _CategoryColumnState createState() => _CategoryColumnState();
}

class _CategoryColumnState extends State<CategoryColumn> {
  bool _isLoading = false;

  String get typeText {
    if (widget.type == TaskStatus.Open) {
      return "Open:";
    } else if (widget.type == TaskStatus.InProgress) {
      return "In Progress:";
    } else if (widget.type == TaskStatus.Done) {
      return "Done:";
    } else {
      return "Unknown";
    }
  }

  Color get typeColor {
    if (widget.type == TaskStatus.Open) {
      return Colors.green;
    } else if (widget.type == TaskStatus.InProgress) {
      return Colors.amber;
    } else if (widget.type == TaskStatus.Done) {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }

  String get emptyListText {
    if (widget.type == TaskStatus.Open) {
      return "No Open Task To Show";
    } else if (widget.type == TaskStatus.InProgress) {
      return "No In Progress Task To Show";
    } else if (widget.type == TaskStatus.Done) {
      return "No Done Task To Show";
    } else {
      return "";
    }
  }

  bool isTasksListEmpty(TaskManager tm) {
    if (widget.type == TaskStatus.Open) {
      // print("###################################$tm.openTasks.isEmpty");
      return tm.openTasks.isEmpty;
    } else if (widget.type == TaskStatus.InProgress) {
      return tm.inProgressTasks.isEmpty;
    } else if (widget.type == TaskStatus.Done) {
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
                  child: _isLoading
                      ? Container(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(),
                        )
                      : Icon(Icons.add),
                  onPressed: _isLoading
                      ? () {}
                      : () async {
                          final result = await showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) =>
                                AddTaskBottomSheet(widget.type),
                          );
                          if (result != null) {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await taskManager.addTask(
                                title: result["title"],
                                description: result["description"],
                                status: result["status"],
                                taskOwner: result["owner"],
                                timeToFinish: result["timeToFinish"],
                              );
                            } catch (err) {
                              print("$err from Category Column.");
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          }
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
                    final tasks = taskManager.getTasksByStatus(widget.type);
                    tasks.sort((a, b) => a.timeToFinish.millisecondsSinceEpoch
                        .compareTo(b.timeToFinish.millisecondsSinceEpoch));
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
                              children: tasks
                                  .map((task) => TaskCard(task.taskId))
                                  .toList(),
                            ),
                          );
                  },
                  onWillAccept: (task) => widget.type != task.status,
                  onAccept: (task) =>
                      taskManager.changeTaskStatus(task.taskId, widget.type),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
