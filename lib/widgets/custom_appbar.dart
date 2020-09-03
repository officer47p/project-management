import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/task_manager.dart';

class CustomAppBar extends StatelessWidget {
  final EdgeInsets padding;
  const CustomAppBar({this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding != null ? padding : EdgeInsets.all(0),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
            // color: Color(0xfff5634a),
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5.0,
                spreadRadius: 2.0,
              ),
            ]),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Consumer<TaskManager>(
                  builder: (context, value, child) {
                    final _now = DateTime.now();
                    TextStyle _tStyle = TextStyle(
                      fontSize: 18,
                      fontFamily: "Ubuntu",
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    );
                    return RichText(
                      text: TextSpan(
                        style: _tStyle.copyWith(color: Colors.blue),
                        text: "Date: ",
                        children: [
                          TextSpan(
                            text: "${_now.year}/${_now.month}/${_now.day}   ",
                            style: _tStyle.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Time: ",
                            style: _tStyle.copyWith(color: Colors.blue),
                          ),
                          TextSpan(
                            text:
                                "${_now.hour.toString().padLeft(2, '0')} : ${_now.minute.toString().padLeft(2, '0')} : ${_now.second.toString().padLeft(2, '0')}",
                            style: _tStyle.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(text: "", children: [
                  TextSpan(
                    text: "Task",
                    style: TextStyle(
                        fontFamily: "RubikMonoOne",
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 25,
                        shadows: [
                          Shadow(
                            color: Colors.pink,
                            blurRadius: 6,
                          ),
                        ]),
                  ),
                  TextSpan(
                    text: " ~ ",
                    style: TextStyle(
                      fontFamily: "RubikMonoOne",
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 25,
                    ),
                  ),
                  TextSpan(
                    text: "Flow",
                    style: TextStyle(
                      fontFamily: "RubikMonoOne",
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 25,
                      shadows: [
                        Shadow(
                          color: Colors.purple,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      Provider.of<Auth>(context, listen: false).userEmail ?? "",
                      style: TextStyle(
                          fontFamily: "Ubuntu",
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  Flexible(
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                            fontFamily: "Ubuntu",
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(0, 0),
                                blurRadius: 5,
                              )
                            ]),
                      ),
                      onPressed: () async {
                        final taskManager =
                            Provider.of<TaskManager>(context, listen: false);
                        await Provider.of<Auth>(context, listen: false)
                            .logOut(taskManager.timer);
                        // taskManager.timer
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
