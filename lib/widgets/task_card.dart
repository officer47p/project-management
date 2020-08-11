import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/task_manager.dart';

class TaskCard extends StatelessWidget {
  final String taskId;
  TaskCard(this.taskId);
  @override
  Widget build(BuildContext context) {
    final task = Provider.of<TaskManager>(context).getSingleTask(taskId);
    return Container(
      margin: EdgeInsets.all(10),
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
                avatar: Icon(Icons.timelapse),
                label: Text(
                  task.timeToFinish.toString(),
                ),
              )
            ],
          ),
          // Row(
          //   // textBaseline: TextBaseline.ideographic,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Text(
          //       "Discussions",
          //       style: TextStyle(
          //         color: Colors.black.withOpacity(0.6),
          //         fontFamily: "Ubuntu",
          //         fontSize: 15,
          //       ),
          //     ),
          //     IconButton(
          //       icon: Icon(Icons.expand_more),
          //       onPressed: () {},
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
