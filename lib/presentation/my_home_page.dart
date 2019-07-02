import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_study/data/goals_repository.dart';
import 'package:flutter_study/data/strings.dart';

import 'package:flutter_study/domain/goals_bloc.dart';
import 'package:flutter_study/presentation/representers.dart';
import 'add_goal_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoalsBLoC bloc;
  int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
  Timer timer;
  GoalsRepository repository = GoalsRepository.instance();

  @override
  void initState() {
    bloc = new GoalsBLoC(repository);
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
            Text(getTimeBeforeDeadline(goals[index]), style: TextStyle(fontStyle: FontStyle.italic))
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