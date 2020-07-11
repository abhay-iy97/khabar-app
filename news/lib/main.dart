import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(
    MyApp()); // Main used arrow notation for calling one-line function or methods

class MyApp extends StatelessWidget {
  // Extending the stateless widget makes the app itself a widget
  @override
  Widget build(BuildContext context) {
    // How to display widget in terms of other lower level widgets.
    final words = WordPair.random(); //using the english words example
    return MaterialApp(
      // The Body for this widge contains a Center widget which has another
      // text child widget
      // From what I gather, flutter widget as its fundamental component.
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
            //child: Text('Hello World'),
            //Each time you press 'r' i.e hot reload or save this app
            //you will see a different word because the build method is run each time
            //MaterialApp requires rendering.
            child: Text(words.asPascalCase)),
      ),
    ); // MaterialApp -> Rich Visual design language standard on web
  }
}
