import 'package:flutter/material.dart';

import 'AddGoalBLoC.dart';
import 'GoalsRepository.dart';

class AddGoalScreen extends StatefulWidget {
  final GoalsRepository _repository = new GoalsRepository();

  @override
  State<StatefulWidget> createState() {
    return _AddGoalScreenState();
  }
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  String title;
  DateTime selectedDate = DateTime.now();
  AddGoalBLoC bloc;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    bloc = AddGoalBLoC(widget._repository);
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Добавить цель"),
      ),
      body: SafeArea(
          child: StreamBuilder<AddGoalState>(
        builder: (context, snapshot) {
          if (snapshot.data is InitAddGoalState) {
            return _buildInitState();
          }
          if (snapshot.data is AddGoalError) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _showMessage('Название не должно быть пустым'));
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
        onPressed: () => {bloc.addGoal(title, selectedDate.millisecondsSinceEpoch)},
        tooltip: 'Добавить цель',
        child: Icon(Icons.check),
      ),
    );
  }

  Widget _buildInitState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Название цели'),
            onChanged: (String t) => title = t,
          ),
          Text("${selectedDate.toLocal()}"),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select date'),
          ),
        ],
      ),
    );
  }
  void _showMessage(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}
