import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './widgets/custom_appbar.dart';
import './widgets/task_card.dart';
import './widgets/category_column.dart';

import './providers/task_manager.dart';

import './enums.dart';

void main() {
  runApp(ProjectManagement());
}

class ProjectManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskManager(),
      child: MaterialApp(
        title: "Task Flow",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          textTheme: TextTheme(
            headline6: TextStyle(fontFamily: "RubikMonoOne"),
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  static const categories = [
    TaskStatus.Open,
    TaskStatus.InProgress,
    TaskStatus.Done
  ];
  @override
  Widget build(BuildContext context) {
    print(AppBar(
      title: Text("Task Flow"),
    ).preferredSize.height);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/app_background.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                CustomAppBar(padding: EdgeInsets.only(bottom: 10)),
                Expanded(child: LayoutBuilder(
                  builder: (context, constraints) {
                    print(constraints.maxHeight);
                    return Container(
                      width: double.infinity,
                      height: constraints.maxHeight,
                      child: Row(
                        children: categories
                            .map((e) => CategoryColumn(type: e))
                            .toList(),
                        // [
                        //   CategoryColumn(
                        //     text: "Open:",
                        //     color: Colors.green,
                        //   ),
                        //   CategoryColumn(
                        //     text: "In Progress:",
                        //     color: Colors.amber,
                        //   ),
                        //   CategoryColumn(
                        //     text: "Done:",
                        //     color: Colors.blue,
                        //   ),
                        // ],
                      ),
                    );
                  },
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
