
import 'dart:async';

import 'Goal.dart';
import 'GoalsRepository.dart';

class GoalsBLoC {
  GoalsBLoC(this._repository);

  final GoalsRepository _repository;

  final _goalsStreamController = StreamController<GoalsState>();

  Stream<GoalsState> get stream => _goalsStreamController.stream;

  void loadGoalsData() {
    _goalsStreamController.sink.add(GoalsState._loadData(_repository.getGoals()));
  }

  void dispose() {
    _goalsStreamController.close();
  }
}

class GoalsState {
  GoalsState();

  factory GoalsState._loadData(List<Goal> goals) = GoalsDataState;
}

class GoalsDataState extends GoalsState {
  GoalsDataState(this.goals);
  final List<Goal> goals;
}

class InitGoalsState extends GoalsState {}