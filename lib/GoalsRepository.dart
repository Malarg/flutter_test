
import 'Goal.dart';

class GoalsRepository {
  static final GoalsRepository _goalsRepository = new GoalsRepository._internal();
  factory GoalsRepository() {
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