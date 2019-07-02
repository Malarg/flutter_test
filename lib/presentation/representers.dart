
import 'package:flutter_study/data/goal.dart';

String getTimeBeforeDeadline(Goal goal) {
  var duration = goal.deadline.difference(DateTime.now());
  bool isDeadlineAchieved = duration.isNegative;
  if (isDeadlineAchieved)
    return 'Цель достигнута';

  return "Осталось ${duration.inDays} дней + ${duration.inHours%24}:${duration.inMinutes%60}:${duration.inSeconds%60}:${duration.inMilliseconds%1000}";
}