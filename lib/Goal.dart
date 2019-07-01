class Goal {
  String title;
  int deadlineTimestamp;

  Goal() {
    title = "";
    deadlineTimestamp = 0;
  }

  Goal.named(String t, int dt) {
    title = t;
    deadlineTimestamp = dt;
  }

  String getTimeBeforeDeadline(int currentTimestamp) {
    bool isDeadlineAchieved = currentTimestamp > deadlineTimestamp;
    if (isDeadlineAchieved)
      return 'Цель достигнута';

    var millisToDeadline = deadlineTimestamp - currentTimestamp;
    var daysToDeadline = millisToDeadline ~/ 1000 ~/ 60 ~/ 60 ~/ 24;
    var hoursToDeadline = millisToDeadline ~/ 1000 ~/ 60 ~/ 60 % 24;
    var minutesToDeadline = millisToDeadline ~/ 1000 ~/ 60 % 60;
    var secondsToDeadline = millisToDeadline ~/ 1000 % 60;

    return "Осталось $daysToDeadline дней, $hoursToDeadline:$minutesToDeadline:$secondsToDeadline:${millisToDeadline % 1000}";
  }
}