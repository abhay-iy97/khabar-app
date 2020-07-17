import 'dart:async';
// import 'dart:html';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:news/entities/note.dart';
import 'package:news/widget/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_tab_bar_no_ripple/flutter_tab_bar_no_ripple.dart';

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
      home: MyHomePage(),
    );
  }
}

