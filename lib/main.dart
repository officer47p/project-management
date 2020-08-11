import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './widgets/custom_appbar.dart';
import './widgets/task_card.dart';

void main() {
  runApp(ProjectManagement());
}

class ProjectManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Project Management",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          headline6: TextStyle(fontFamily: "RubikMonoOne"),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget columnBuilder(String text, Color color) {
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
                    text,
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
                  onPressed: () {},
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
                      color: color,
                      blurRadius: 6.0,
                      spreadRadius: 3.0,
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [TaskCard(), TaskCard(), TaskCard(), TaskCard()],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(AppBar(
      title: Text("Project Management"),
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
                        children: [
                          columnBuilder("Open:", Colors.green),
                          columnBuilder("In Progress:", Colors.amber),
                          columnBuilder("Done:", Colors.blue)
                        ],
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
