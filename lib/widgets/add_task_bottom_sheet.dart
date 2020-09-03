import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../enums.dart';

import '../providers/task_manager.dart';
import '../providers/auth.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final TaskStatus status;
  final Task preLoadedTask;
  AddTaskBottomSheet(this.status, {this.preLoadedTask});
  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  int _minute;
  int _hour;
  int _day;
  int _month;
  int _year;
  int _m;
  int _h;
  int _d;
  int _M;
  int _y;
  Map task = {};

  @override
  void initState() {
    if (widget.preLoadedTask != null) {
      _minute = widget.preLoadedTask.timeToFinish.minute;
      _hour = widget.preLoadedTask.timeToFinish.hour;
      _day = widget.preLoadedTask.timeToFinish.day;
      _month = widget.preLoadedTask.timeToFinish.month;
      _year = widget.preLoadedTask.timeToFinish.year;
    }
    super.initState();
  }

  void _submitForm() {
    final form = _formKey.currentState;
    // print("Dys: $_days Hors: $_hours Min: $_minutes");
    if (form.validate()) {
      // print("Validated");
      form.save();
      task["status"] = widget.status;
      task["owner"] =
          Provider.of<Auth>(context, listen: false).userEmail.split("@")[0];
      task["timeToFinish"] = DateTime.parse(
          '${_y}-${_M.toString().padLeft(2, '0')}-${_d.toString().padLeft(2, '0')}T${_h.toString().padLeft(2, '0')}:${_m.toString().padLeft(2, '0')}:00.000');
      // print(task);
      Navigator.pop(context, task);
    }
    // if (form.validate()) {
    //   print("Validated");
    //   form.save();
    //   task["status"] = widget.status;
    //   task["owner"] = "Parsa";
    //   print(task);
    //   Navigator.of(context).pop(task);
    // }
  }

  String timeLeftString(Task task, String outputType) {
    final DateTime _now = DateTime.now();
    int totalMins = task.timeToFinish.difference(_now).inMinutes;
    int totalHours = totalMins ~/ 60 >= 1 ? totalMins ~/ 60 : 0;
    totalMins -= totalHours * 60;
    // int totalHours = task.timeToFinish.inHours;
    final totalDays = (totalHours / 24) >= 1 ? totalHours ~/ 24 : 0;
    totalHours -= 24 * totalDays;
    if (task.timeToFinish.difference(_now).inMinutes <= 0) {
      return 0.toString();
    } else {
      if (outputType == "d") {
        return totalDays.toString();
      } else if (outputType == "h") {
        return totalHours.toString();
      } else if (outputType == "m") {
        return totalMins.toString();
      }
    }
    // "${totalDays > 0 ? 'd:${totalDays} ' : ''}${totalHours > 0 ? 'h:${totalHours} ' : ''}${totalMins > 0 ? 'm:${totalMins}' : ''}${task.timeToFinish.difference(_now).inMinutes <= 0 ? 'time\'s up!' : ''}";
  }

  int maxMonthDays(int monthNum) {
    if (monthNum == 1 ||
        monthNum == 3 ||
        monthNum == 5 ||
        monthNum == 7 ||
        monthNum == 8 ||
        monthNum == 10 ||
        monthNum == 12) {
      return 31;
    } else if (monthNum == 4 ||
        monthNum == 6 ||
        monthNum == 9 ||
        monthNum == 11) {
      return 30;
    } else if (monthNum == 2) {
      return 28;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.preLoadedTask != null ? "Edit Task" : "Add A New Task",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 45,
                  fontFamily: "Ubuntu",
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "This field should not be empty";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        // counter: Icon(Icons.ac_unit),
                        labelText: "Title",
                        labelStyle: TextStyle(fontFamily: "Ubuntu"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSaved: (val) => task["title"] = val,
                      initialValue: widget.preLoadedTask != null
                          ? widget.preLoadedTask.title
                          : "",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      maxLines: 4,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "This field should not be empty";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        // counter: Icon(Icons.ac_unit),
                        labelText: "Description",
                        labelStyle: TextStyle(fontFamily: "Ubuntu"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSaved: (val) => task["description"] = val,
                      initialValue: widget.preLoadedTask != null
                          ? widget.preLoadedTask.description
                          : "",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Ends In:",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: "Ubuntu",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              labelText: "Year",
                              labelStyle: TextStyle(fontFamily: "Ubuntu"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            initialValue: widget.preLoadedTask != null
                                ? _year.toString()
                                : "",
                            onSaved: (newValue) => _y = int.parse(newValue),
                            onChanged: (value) => _year = int.tryParse(value),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Can Not Be Empty.";
                              } else {
                                if (int.tryParse(value) == null)
                                  return "It Must Be A Number.";
                                else if (int.tryParse(value) <= 0)
                                  return "It Must Be A.D.";
                                else if (int.tryParse(value) >= 3000)
                                  return "Seriously? Will You Be Alive Then?";
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            ":",
                            style: TextStyle(
                              fontFamily: "Ubuntu",
                              fontSize: 40,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              // counter: Icon(Icons.ac_unit),
                              labelText: "Month",
                              labelStyle: TextStyle(fontFamily: "Ubuntu"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            initialValue: widget.preLoadedTask != null
                                ? _month.toString()
                                : "",
                            onSaved: (newValue) => _M = int.parse(newValue),
                            onChanged: (value) => _month = int.tryParse(value),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Can Not Be Empty.";
                              } else {
                                if (int.tryParse(value) == null)
                                  return "It Must Be A Number.";
                                else if (int.tryParse(value) <= 0)
                                  return "It Must Be Between 1 Or 12.";
                                else if (int.tryParse(value) >= 13)
                                  return "It Must Be Between 1 Or 12.";
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            ":",
                            style: TextStyle(
                              fontFamily: "Ubuntu",
                              fontSize: 40,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              // counter: Icon(Icons.ac_unit),
                              labelText: "Day",
                              labelStyle: TextStyle(fontFamily: "Ubuntu"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            initialValue: widget.preLoadedTask != null
                                ? _day.toString()
                                : "",
                            onSaved: (newValue) => _d = int.parse(newValue),
                            onChanged: (value) => _day = int.tryParse(value),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Can Not Be Empty.";
                              } else {
                                if (int.tryParse(value) == null) {
                                  return "It Must Be A Number.";
                                } else {
                                  if (_month != null) {
                                    if (int.tryParse(value) <= 0)
                                      return "It Must Be Between 1 Or ${maxMonthDays(_month)}.";
                                    else if (int.tryParse(value) >=
                                        maxMonthDays(_month))
                                      return "It Must Be Between 1 Or ${maxMonthDays(_month)}.";
                                  }
                                }
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            ":",
                            style: TextStyle(
                              fontFamily: "Ubuntu",
                              fontSize: 40,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              // counter: Icon(Icons.ac_unit),
                              labelText: "Hour",
                              labelStyle: TextStyle(fontFamily: "Ubuntu"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            initialValue: widget.preLoadedTask != null
                                ? _hour.toString()
                                : "",
                            onSaved: (newValue) => _h = int.parse(newValue),
                            onChanged: (value) => _hour = int.tryParse(value),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Can Not Be Empty.";
                              } else {
                                if (int.tryParse(value) == null)
                                  return "It Must Be A Number.";
                                else if (int.tryParse(value) < 0)
                                  return "It Must Be Between 0 Or 23.";
                                else if (int.tryParse(value) >= 24)
                                  return "It Must Be Between 0 Or 23.";
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            ":",
                            style: TextStyle(
                              fontFamily: "Ubuntu",
                              fontSize: 40,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Ubuntu",
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              // counter: Icon(Icons.ac_unit),
                              labelText: "Minute",
                              labelStyle: TextStyle(fontFamily: "Ubuntu"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            initialValue: widget.preLoadedTask != null
                                ? _minute.toString()
                                : "",
                            onSaved: (newValue) => _m = int.parse(newValue),
                            onChanged: (value) => _minute = int.tryParse(value),
                            onFieldSubmitted: (value) => _submitForm(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Can Not Be Empty.";
                              } else {
                                if (int.tryParse(value) == null)
                                  return "It Must Be A Number.";
                                else if (int.tryParse(value) < 0)
                                  return "It Must Be Between 0 Or 59.";
                                else if (int.tryParse(value) >= 60)
                                  return "It Must Be Between 0 Or 59.";
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Ubuntu",
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        onPressed: () {
                          _submitForm();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Days
// onSaved: (val) => task["days"] =
//                         int.tryParse(val) != null ? int.parse(val) : 0,
//                     onChanged: (value) => _days = int.tryParse(value),
//                     validator: (value) {
//                       if (value.isEmpty && (_hours == null || _hours <= 0)) {
//                         return "Please fill at least one of these inputs: Days Left or Hours Left";
//                       } else if (value.isNotEmpty &&
//                           (int.tryParse(value) == null ||
//                               int.tryParse(value) < 0)) {
//                         return "Please enter a valid value";
//                       } else if (int.tryParse(value) == 0 && _hours == 0) {
//                         return "Please fill at least one of these inputs with a valid value: Days Left or Hours Left";
//                       } else {
//                         return null;
//                       }
//                     },
// ################
// Hours
// onSaved: (val) => task["hours"] =
//                         int.tryParse(val) != null ? int.parse(val) : 0,
//                     onChanged: (value) => _hours = int.tryParse(value),
//                     validator: (value) {
//                       if (value.isEmpty && (_days == null || _days <= 0)) {
//                         return "Please fill at least one of these inputs: Days Left or Hours Left";
//                       } else if (value.isNotEmpty &&
//                           (int.tryParse(value) == null ||
//                               int.tryParse(value) < 0)) {
//                         return "Please enter a valid value";
//                       } else if (int.tryParse(value) == 0 && _days == 0) {
//                         return "Please fill at least one of these inputs with a valid value: Days Left or Hours Left";
//                       } else {
//                         return null;
//                       }
//                     },
// ################
