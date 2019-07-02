import 'package:flutter/material.dart';
import 'package:flutter_study/data/strings.dart';
import 'package:flutter_study/presentation/my_home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.flutterDemo,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: Strings.myGoals),
    );
  }
}
