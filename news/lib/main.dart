import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:path_provider/path_provider.dart';
import 'package:news/entities/note.dart';

void main() => runApp(
    MyApp()); // Main used arrow notation for calling one-line function or methods

class MyApp extends StatelessWidget {
  // Extending the stateless widget makes the app itself a widget
  @override
  Widget build(BuildContext context) {
    // How to display widget in terms of other lower level widgets.
    // final words = WordPair.random(); //using the english words example
    return MaterialApp(
      // The Body for this widge contains a Center widget which has another
      // text child widget
      // From what I gather, flutter widget as its fundamental component.
      title: 'News List',
      home: RandomWords(),
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: Text('Welcome to Flutter'),
      //   ),
      //   body: Center(
      //       //child: Text('Hello World'),
      //       //Each time you press 'r' i.e hot reload or save this app
      //       //you will see a different word because the build method is run each time
      //       //MaterialApp requires rendering.
      //       //child: Text(words.asPascalCase)),
      //       // Now using the stateful app
      //       //child: RandomWords()),
      //       //Infinite list, call the class
      // ),
    ); // MaterialApp -> Rich Visual design language standard on web
  }
}

// Creating stateful widget needs two things
// Stateful Widget which creates an instance of a state class.
// So in essence its not the stateful widget which is immutable but the state
// class which persists.
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = TextStyle(fontSize: 40.0);
  List<Note> _notes = List<Note>();
  Widget _buildSuggestions() {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
      });
    });
    return ListView.builder(
        itemCount: _notes.length,
        padding:
            EdgeInsets.only(top: 10.0, bottom: 10.0, left: 4.0, right: 4.0),
        itemBuilder: (context, i) {
          // if (i.isOdd) return Divider();

          // final index = i ~/ 2;
          // if (index >= _suggestions.length) {
          //   _suggestions.addAll(generateWordPairs().take(10));
          //   Column(
          //     children: <Widget>[
          //       Text('Note Title'),
          //       Text('Date'),
          //       // Image,
          //     ],
          //   );
          // }
          // return _buildRow(_suggestions[index]);
          return Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _notes[i].title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _notes[i].text,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  // Image,
                ],
              ),
            ),
          );
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }

  Future<List<Note>> fetchNotes() async {
    final file = await _localFile;

    var notes = List<Note>();

    String contents = await file.readAsString();
    var newsList = jsonDecode(contents);
    for (var news in newsList) {
      notes.add(Note.fromJson(news));
    }
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    // final words = WordPair.random();
    // return Text(words.asPascalCase);
    // Now adding the infinite scroll list
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }
}
