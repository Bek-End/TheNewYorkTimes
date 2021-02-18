import 'package:NYTimesApp/constants/constants.dart';
import 'package:NYTimesApp/screens/main_screen.dart';
import 'package:NYTimesApp/screens/start_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'NY Times App',
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: Colors.grey),
                actionsIconTheme: IconThemeData(color: Colors.grey),
                shadowColor: Colors.grey,
                centerTitle: true,
                color: Colors.white,
                textTheme: TextTheme(
                    headline6: TextStyle(color: kColorBlack, fontSize: 20)))),
        home: StartScreen());
  }
}
