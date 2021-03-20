import 'package:flutter/material.dart';
import 'package:flutter_assignment/page/homepage.dart';
import 'package:flutter_assignment/page/resultpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TugasAkhir ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      routes: {
        ResultPage.routeName: (ctx) => ResultPage(),
      },
    );
  }
}
