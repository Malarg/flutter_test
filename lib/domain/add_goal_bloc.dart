import 'dart:async';

import 'package:flutter_study/data/goal.dart';
import 'package:flutter_study/data/goals_repository.dart';
import 'package:flutter_study/data/strings.dart';

class AddGoalBLoC {
  AddGoalBLoC(this._repository);

  final GoalsRepository _repository;

  final _addGoalStreamController = StreamController<AddGoalState>();

  Stream<AddGoalState> get stream => _addGoalStreamController.stream;

  void addGoal(String title, DateTime date) {
    if (title != null && title.isNotEmpty && date.millisecondsSinceEpoch > 0) {
      var goal = Goal.named(title, date);
      _addGoalStreamController.sink.add(AddGoalState._createGoal(goal));
      _repository.addGoal(goal);
    } else {
      if (title == null || title.isEmpty)
        _addGoalStreamController.sink.add(AddGoalState._error(Strings.titleShouldntBeEmpty));

      if (date.millisecondsSinceEpoch == 0)
        _addGoalStreamController.sink.add(AddGoalState._error(Strings.dateSbouldBeFilled));
    }
  }

  void dispose() {
    _addGoalStreamController.close();
  }
}

class AddGoalState {
  AddGoalState();

  factory AddGoalState._createGoal(Goal goal) = CreatedGoalState;
  factory AddGoalState._error(String message) = AddGoalError;
}

class CreatedGoalState extends AddGoalState {
  CreatedGoalState(this.goal);
  final Goal goal;
}

class AddGoalError extends AddGoalState {
  AddGoalError(this.message);
  final String message;
}

class InitAddGoalState extends AddGoalState {}