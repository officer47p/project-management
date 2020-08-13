import 'package:flutter/material.dart';
import '../enums.dart';

import 'package:provider/provider.dart';

import '../providers/task_manager.dart';

class TaskCard extends StatefulWidget {
  final String taskId;
  TaskCard(this.taskId);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  // bool _isBeingDragged = false;

  // void stopDrag([a, b]) {
  //   setState(() {
  //     _isBeingDragged = false;
  //   });
  // }

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
    return Container(
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
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {},
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
              Flexible(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        "Task Owner:",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontFamily: "Ubuntu",
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          task.taskOwner,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontFamily: "Ubuntu",
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Chip(
                avatar: Icon(
                  Icons.timelapse,
                  color: Colors.white,
                ),
                label: Text(
                  task.timeToFinish.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: statusColor(task.status),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = Provider.of<TaskManager>(context).getSingleTask(widget.taskId);
    return LayoutBuilder(
      builder: (context, constraints) {
        print(constraints.maxWidth);
        final padding = const EdgeInsets.all(10);
        return Padding(
          padding: padding,
          child: Draggable<String>(
            // onDragStarted: () => setState(() {
            //   _isBeingDragged = true;
            // }),
            // onDragCompleted: stopDrag,
            // onDragEnd: stopDrag,
            // onDraggableCanceled: stopDrag,
            data: task.taskId,
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
