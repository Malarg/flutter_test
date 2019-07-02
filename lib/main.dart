import 'dart:async';

import 'package:flutter/material.dart';
import 'AddGoalScreen.dart';
import 'GoalsBLoC.dart';
import 'GoalsRepository.dart';
import 'Strings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.flutterDemo,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: Strings.myGoals),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  final repository = GoalsRepository();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GoalsBLoC bloc;
  int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
  Timer timer;

  @override
  void initState() {
    bloc = new GoalsBLoC(widget.repository);
    bloc.loadGoalsData();
    timer = new Timer.periodic(new Duration(milliseconds: 50), (Timer timer) async {
      this.setState(() {
        currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _addGoal() {
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddGoalScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(child: StreamBuilder<GoalsState>(builder: (context, snapshot) {
        if (snapshot.data is GoalsDataState) {
          var goals = (snapshot.data as GoalsDataState).goals;
          return goals.isEmpty ? buildEmptyScreen() : buildGoalsList(snapshot.data);
        }
        return buildEmptyScreen();
      },
      initialData: InitGoalsState(),
          stream: bloc.stream,)),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGoal,
        tooltip: Strings.addGoal,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildGoalsList(GoalsState snapshot) {
    var goals = (snapshot as GoalsDataState).goals;
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      return Column(
          children:[
            Text(goals[index].title, style: TextStyle(fontWeight: FontWeight.bold),),
            Text(goals[index].getTimeBeforeDeadline(currentTimestamp), style: TextStyle(fontStyle: FontStyle.italic))
          ]
      );
    },
      itemCount: goals.length,
      padding: const EdgeInsets.all(8.0),);
  }

  Widget buildEmptyScreen() {
    return Center(child: (Text(Strings.youHaventGoalsInYourLife)));
  }
}
