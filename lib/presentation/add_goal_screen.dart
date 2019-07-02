import 'package:flutter/material.dart';

import 'package:flutter_study/domain/add_goal_bloc.dart';
import 'package:flutter_study/data/goals_repository.dart';
import 'package:flutter_study/data/strings.dart';

class AddGoalScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _AddGoalScreenState();
  }
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  String title;
  DateTime selectedDate = DateTime.fromMicrosecondsSinceEpoch(0);
  static const String defaultDisplayedDate = Strings.selectDate;
  String displayedDate = defaultDisplayedDate;
  AddGoalBLoC bloc;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final GoalsRepository _repository = new GoalsRepository.instance();

  @override
  void initState() {
    bloc = AddGoalBLoC(_repository);
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        displayedDate = selectedDate.toLocal().toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(Strings.addGoal),
      ),
      body: SafeArea(
          child: StreamBuilder<AddGoalState>(
        builder: (context, snapshot) {
          if (snapshot.data is InitAddGoalState) {
            return _buildInitState();
          }
          if (snapshot.data is AddGoalError) {
            var message = (snapshot.data as AddGoalError).message;
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => _showMessage(message));
            return _buildInitState();
          }
          if (snapshot.data is CreatedGoalState) {
            Navigator.pop(context);
            return _buildInitState();
          }
        },
        initialData: InitAddGoalState(),
        stream: bloc.stream,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            {bloc.addGoal(title, selectedDate)},
        tooltip: Strings.addGoal,
        child: Icon(Icons.check),
      ),
    );
  }

  Widget _buildInitState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
              border: InputBorder.none, hintText: Strings.goalTitle, contentPadding: EdgeInsets.only(left: 16.0, top: 24.0)),
          onChanged: (String t) => title = t,
        ),
        GestureDetector(child: Padding(padding: EdgeInsets.only(left: 16.0, top: 16.0), child: Text(displayedDate)) , onTap: () => _selectDate(context)),
      ],
    );
  }

  void _showMessage(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}
