import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './widgets/custom_appbar.dart';
import './widgets/task_card.dart';
import './widgets/category_column.dart';

import './screens/login.dart';

import './providers/task_manager.dart';
import './providers/auth.dart';

import './enums.dart';

void main() {
  runApp(ProjectManagement());
}

class ProjectManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        // create: (context) => TaskManager(),
        providers: [
          ChangeNotifierProvider<Auth>(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, TaskManager>(
            update: (context, auth, previous) => TaskManager(
              previous == null ? <Task>[] : previous.tasks,
              authToken: auth.authToken,
              userId: auth.userId,
              setAutoLogOut: auth.setAutoLogOut,
            ),
          )
        ],
        child: Consumer<Auth>(
          builder: (context, value, child) => MaterialApp(
            title: "Task Flow",
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              textTheme: TextTheme(
                headline6: TextStyle(fontFamily: "RubikMonoOne"),
              ),
            ),
            home: value.authToken != null ? HomePage() : LogInScreen(),
          ),
        ));
  }
}

class HomePage extends StatefulWidget {
  static const categories = [
    TaskStatus.Open,
    TaskStatus.InProgress,
    TaskStatus.Done
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  bool _isInited = false;

  @override
  void didChangeDependencies() {
    if (!_isInited) {
      fetch();
      _isInited = true;
    }
    super.didChangeDependencies();
  }

  // @override
  // void dispose() {
  //   Provider.of<TaskManager>(context, listen: false).timer.cancel();
  //   super.dispose();
  // }

  Future<void> fetch() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<TaskManager>(context).fetchData();
    } catch (err) {
      print("$err, from main screen");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    // print(constraints.maxHeight);
                    return Opacity(
                      opacity: _isLoading ? 0.3 : 1,
                      child: Container(
                        width: double.infinity,
                        height: constraints.maxHeight,
                        child: Row(
                          children: HomePage.categories
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
                      ),
                    );
                  },
                )),
              ],
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
