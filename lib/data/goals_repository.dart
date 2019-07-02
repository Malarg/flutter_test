
import 'package:flutter_study/data/goal.dart';

class GoalsRepository {
  static final GoalsRepository _goalsRepository = new GoalsRepository._internal();
  factory GoalsRepository.instance() {
    return _goalsRepository;
  }
  GoalsRepository._internal();

  List<Goal> _goals = [];

  void addGoal(Goal goal) {
    _goals.add(goal);
  }

  List<Goal> getGoals() {
    return _goals;
  }
}