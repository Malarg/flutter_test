class Goal {
  String title;
  DateTime deadline;

  Goal() {
    title = "";
    deadline = DateTime.fromMicrosecondsSinceEpoch(0);
  }

  Goal.named(String t, DateTime d) {
    title = t;
    deadline = d;
  }
}