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
  int _minutes;
  int _hours;
  int _days;
  Map task = {};

  @override
  void initState() {
    if (widget.preLoadedTask != null) {
      _minutes = int.parse(timeLeftString(widget.preLoadedTask, "m"));
      _hours = int.parse(timeLeftString(widget.preLoadedTask, "h"));
      _days = int.parse(timeLeftString(widget.preLoadedTask, "d"));
    }
    super.initState();
  }

  void _submitForm() {
    final form = _formKey.currentState;
    print("Dys: $_days Hors: $_hours Min: $_minutes");
    if (form.validate()) {
      print("Validated");
      form.save();
      task["status"] = widget.status;
      task["owner"] =
          Provider.of<Auth>(context, listen: false).userEmail.split("@")[0];
      print(task);
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
                    TextFormField(
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
                        labelText: "Days Left",
                        labelStyle: TextStyle(fontFamily: "Ubuntu"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      initialValue: widget.preLoadedTask != null
                          ? timeLeftString(widget.preLoadedTask, "d")
                          : "",
                      onChanged: (value) => _days = int.tryParse(value),
                      onSaved: (newValue) =>
                          task["days"] = int.tryParse(newValue) ?? 0,
                      validator: (value) {
                        if (value.isNotEmpty) {
                          if ((_hours == null || _hours <= 0) &&
                              (_minutes == null || _minutes <= 0)) {
                            final inputDays = int.tryParse(value);
                            if (inputDays == null)
                              return "Please input a valid value";
                            if (inputDays <= 0)
                              return "Please input a number greater that 0";
                            return null;
                          } else
                            return null;
                        }
                        if ((_hours == null || _hours <= 0) &&
                            (_minutes == null || _minutes <= 0))
                          return "Please fill at least one of these fields: Hours or Days to finish";
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        // counter: Icon(Icons.ac_unit),
                        labelText: "Hours Left",
                        labelStyle: TextStyle(fontFamily: "Ubuntu"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      initialValue: widget.preLoadedTask != null
                          ? timeLeftString(widget.preLoadedTask, "h")
                          : "",
                      onChanged: (value) => _hours = int.tryParse(value),
                      onSaved: (newValue) =>
                          task["hours"] = int.tryParse(newValue) ?? 0,
                      validator: (value) {
                        if (value.isNotEmpty) {
                          if ((_days == null || _days <= 0) &&
                              (_minutes == null || _minutes <= 0)) {
                            final inputHours = int.tryParse(value);
                            if (inputHours == null)
                              return "Please input a valid value";
                            if (inputHours <= 0)
                              return "Please input a number greater that 0";
                            return null;
                          } else
                            return null;
                        }
                        if ((_days == null || _days <= 0) &&
                            (_minutes == null || _minutes <= 0))
                          return "Please fill at least one of these fields: Hours or Days to finish";
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        // counter: Icon(Icons.ac_unit),
                        labelText: "Minutes Left",
                        labelStyle: TextStyle(fontFamily: "Ubuntu"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      initialValue: widget.preLoadedTask != null
                          ? timeLeftString(widget.preLoadedTask, "m")
                          : "",
                      onChanged: (value) => _minutes = int.tryParse(value),
                      onSaved: (newValue) =>
                          task["minutes"] = int.tryParse(newValue) ?? 0,
                      validator: (value) {
                        if (value.isNotEmpty) {
                          if ((_days == null || _days <= 0) &&
                              (_hours == null || _hours <= 0)) {
                            final inputMinutes = int.tryParse(value);
                            if (inputMinutes == null)
                              return "Please input a valid value";
                            if (inputMinutes <= 0)
                              return "Please input a number greater that 0";
                            return null;
                          } else
                            return null;
                        }
                        if ((_days == null || _days <= 0) &&
                            (_hours == null || _hours <= 0))
                          return "Please fill at least one of these fields: Hours or Days or Minutes to finish";
                        return null;
                      },
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
