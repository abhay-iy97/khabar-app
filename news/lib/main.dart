import 'package:flutter/material.dart';
import 'package:news/widgets/homepage.dart';

import 'package:flutter/material.dart';
import 'package:news/widgets/tabitem.dart';
import 'package:news/widgets/bottomNavigation.dart';
import 'package:news/widgets/app.dart';

void main() => runApp(
    MyApp()); // Main used arrow notation for calling one-line function or methods

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News List',
      theme: ThemeData(
          fontFamily: 'Spectral',
          //fontFamily: 'Roboto',
          textTheme: TextTheme(body1: TextStyle(fontStyle: FontStyle.normal))),

      //home: ScrollTab(),
      home: App(),
    );
  }
}
