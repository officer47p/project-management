import 'package:flutter/material.dart';
import '../enums.dart';

import 'package:provider/provider.dart';

import '../providers/task_manager.dart';
import '../providers/auth.dart';

import '../widgets/add_task_bottom_sheet.dart';

class TaskCard extends StatefulWidget {
  final String taskId;
  TaskCard(this.taskId);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isLoading = false;

  Color statusColor(TaskStatus status) {
    if (status == TaskStatus.Open) {
      return Colors.green;
    } else if (status == TaskStatus.InProgress) {
      return Colors.amber;
    } else if (status == TaskStatus.Done) {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }

  Widget _cardBuilder(Task task) {
    return Stack(
      children: [
        Opacity(
          opacity: _isLoading ? 0.5 : 1,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6.0,
                  spreadRadius: 3.0,
                )
              ],
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Ubuntu",
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: _isLoading
                                  ? () {}
                                  : () async {
                                      final result = await showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) =>
                                            AddTaskBottomSheet(
                                          task.status,
                                          preLoadedTask: task,
                                        ),
                                      );
                                      if (result != null) {
                                        try {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          await Provider.of<TaskManager>(
                                                  context,
                                                  listen: false)
                                              .editTask(
                                            title: result["title"],
                                            description: result["description"],
                                            status: result["status"],
                                            taskId: task.taskId,
                                            taskOwner: result["owner"],
                                            timeToFinish:
                                                result["timeToFinish"],
                                          );
                                        } catch (err) {
                                          print(err);
                                        }
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    },
                            ),
                          ),
                          Flexible(
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: _isLoading
                                  ? () {}
                                  : () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      await Provider.of<TaskManager>(context,
                                              listen: false)
                                          .deleteTask(task.taskId);
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  task.description,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontFamily: "Ubuntu",
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "End Date:",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        task.timeToFinish
                            .toString()
                            .replaceAll("-", "/")
                            .split(".")[0],
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Ubuntu",
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Time Left:",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Chip(
                          avatar: Icon(
                            Icons.timelapse,
                            color: Colors.white,
                          ),
                          label: Text(
                            timeLeftString(task),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Ubuntu",
                            ),
                          ),
                          backgroundColor: statusColor(task.status),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        // if (_isLoading)
        //   Center(
        //     child: CircularProgressIndicator(),
        //   ),
      ],
    );
  }

  String timeLeftString(Task task) {
    final DateTime _now = DateTime.now();
    int totalMins = task.timeToFinish.difference(_now).inMinutes;
    int totalHours = totalMins ~/ 60 >= 1 ? totalMins ~/ 60 : 0;
    totalMins -= totalHours * 60;
    // int totalHours = task.timeToFinish.inHours;
    final totalDays = (totalHours / 24) >= 1 ? totalHours ~/ 24 : 0;
    totalHours -= 24 * totalDays;
    return "${totalDays > 0 ? 'd:${totalDays} ' : ''}${totalHours > 0 ? 'h:${totalHours} ' : ''}${totalMins > 0 ? 'm:${totalMins}' : ''}${task.timeToFinish.difference(_now).inMinutes <= 0 ? 'time\'s up!' : ''}";
    // if (totalDays > 0 && totalHours > 0) {
    //   return "D: ${totalDays}, H: ${totalHours}";
    // } else {
    //   return "H: ${totalHours}";
    // }
    // if(task.timeToFinish.inHours > 23) {
    //   if(task.timeToFinish.inHours - (24 * task.timeToFinish.inDays) > 0) {
    //     return "Days: ${}, Hours: ${task.timeToFinish.inHours}";
    //   }
    // } else {
    //   return "Hours: ${task.timeToFinish.inHours}";
    // }
  }

  @override
  Widget build(BuildContext context) {
    final task = Provider.of<TaskManager>(context).getSingleTask(widget.taskId);
    return LayoutBuilder(
      builder: (context, constraints) {
        // print(constraints.maxWidth);
        final padding = const EdgeInsets.all(10);
        return Padding(
          padding: padding,
          child: Draggable<Task>(
            // onDragStarted: () => setState(() {
            //   _isBeingDragged = true;
            // }),
            // onDragCompleted: stopDrag,
            // onDragEnd: stopDrag,
            // onDraggableCanceled: stopDrag,
            data: task,
            child: _cardBuilder(task),
            childWhenDragging: Container(),
            feedback: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6.0,
                    spreadRadius: 3.0,
                  )
                ],
              ),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth - padding.horizontal,
                  ),
                  child: _cardBuilder(task),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Row(
//   children: [
//     Flexible(
//       child: Text(
//         "Task Owner:",
//         style: TextStyle(
//           color: Colors.black.withOpacity(0.6),
//           fontFamily: "Ubuntu",
//           fontSize: 15,
//         ),
//       ),
//     ),
//     SizedBox(
//       width: 10,
//     ),
//     Flexible(
//       child: Container(
//           padding: EdgeInsets.all(4),
//           decoration: BoxDecoration(
//               color: Colors.orange.withOpacity(0.5),
//               borderRadius: BorderRadius.circular(10)),
//           child: Consumer<Auth>(
//             builder: (context, value, child) => Text(
//               value != null
//                   ? value.userEmail != null
//                       ? value.userEmail.split("@")[0]
//                       : ""
//                   : "",
//               style: TextStyle(
//                 color: Colors.black.withOpacity(0.6),
//                 fontFamily: "Ubuntu",
//                 fontSize: 15,
//               ),
//             ),
//           )),
//     )
//   ],
// ),
