import 'package:news/entities/note.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:news/widgets/tab.dart';
import 'package:http/http.dart' as http;
import 'package:news/widgets/contentpage.dart';
import 'package:path/path.dart';
import 'package:flutter_tab_bar_no_ripple/flutter_tab_bar_no_ripple.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
// import 'dart:html';
import 'dart:io';
import 'dart:convert';

import 'dart:async';

// Creating stateful widget needs two things
// Stateful Widget which creates an instance of a state class.
// So in essence its not the stateful widget which is immutable but the state
// class which persists.
class RandomWords extends StatefulWidget {
  const RandomWords({
    Key key,
    @required this.t,
    this.prefix = '',
  })  : assert(t != null),
        assert(prefix != null),
        super(key: key);

  final String prefix;
  final Tabs t;
  @override
  _RandomWordsState createState() => _RandomWordsState(t: t);
}

class _RandomWordsState extends State<RandomWords> {
  _RandomWordsState({
    Key key,
    @required this.t,
  });
  final Tabs t;
  final _suggestions = <WordPair>[];
  final _biggerFont = TextStyle(fontSize: 40.0);
  List<Note> _notes = List<Note>();
  final bool isFav = false;
  Widget _buildSuggestions(Tabs t) {
    fetchNotes(t.url).then((value) {
      if (this.mounted) {
        setState(() {
          _notes.addAll(value);
        });
      }
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
            child: new InkWell(
              onTap: () {
                _navigateToPageDetails(context, _notes[i]);
              },
              // child: ListView(
              //   shrinkWrap: true,
              //   primary: false,
              //   children: <Widget>[
              //     Stack(
              //       children: <Widget>[
              //         Container(
              //           height: MediaQuery.of(context).size.height /
              //               4.0, // Original Value 3.6
              //           width: MediaQuery.of(context).size.width /
              //               1, // Original Value 2.2
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(8.0),
              //             child:
              //                 Image.network(_notes[i].image, fit: BoxFit.cover),
              //           ),
              //         ),
              //         Positioned(
              //           right: -10.0,
              //           bottom: 3.0,
              //           child: RawMaterialButton(
              //             onPressed: () {},
              //             fillColor: Colors.white,
              //             shape: CircleBorder(),
              //             elevation: 4.0,
              //             child: Padding(
              //               padding: EdgeInsets.all(5),
              //               child: Icon(
              //                 isFav ? Icons.bookmark : Icons.bookmark_border,
              //                 color: Colors.black,
              //                 size: 17,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //     Padding(
              //       padding: EdgeInsets.only(bottom: 2.0, top: 8.0, left: 4.0),
              //       child: Text(
              //         _notes[i].title,
              //         style: TextStyle(
              //           fontSize: 15.0,
              //           fontWeight: FontWeight.w900,
              //         ),
              //         maxLines: 2,
              //       ),
              //     ),
              //   ],
              // ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                // child: Container(
                //   width: MediaQuery.of(context).size.width - 5,
                //   margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
                //   padding: EdgeInsets.all(5.0),
                //   decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(10.0),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black.withOpacity(0.2),
                //           offset: Offset(0, 2.0),
                //           blurRadius: 20.0,
                //         )
                //       ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(_notes[i].image),
                    Text(
                      _notes[i].title,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal),
                    ),
                    Text(
                      _notes[i].text,
                      style: TextStyle(
                          fontFamily: 'Roboto', color: Colors.grey.shade700),
                    ),

                    // Image,
                  ],
                ),
              ),
            ),
            //),
          );
        });
  }

  _navigateToPageDetails(BuildContext context, Note item) async {
    //Holds the results returned from PageDetails.
    final resultFromPageDetails = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageDetails(
          item: item,
        ),
      ),
    );

    //TODO: Navigation implementations are discussed in upcoming Navigation section of this article

    //snackbars is used to display the result returned from another page.
    //Hide any previous snackbars and show the new resultFromPageDetails.
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$resultFromPageDetails")));
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();

  //   return directory.path;
  // }

  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/data.json');
  // }

  Future<List<Note>> fetchNotes(String url) async {
    // final file = await _localFile;

    // var notes = List<Note>();

    // String contents = await file.readAsString();
    // var newsList = jsonDecode(contents);
    // for (var news in newsList) {
    //   notes.add(Note.fromJson(news));
    // }
    // return notes;
    // var url =
    //     'https://raw.githubusercontent.com/abhay-iy97/kratos/master/news/lib/data.json?token=AEJYMTPMPYLM7KY5KIL6V2C7BG4C6';
    //
    //var url =
    //   'https://raw.githubusercontent.com/Shashi456/Deep-Learning/master/data.json';
    print(url);
    var response = await http.get(url);
    var notes = List<Note>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      //print(notesJson);
      for (var noteJson in notesJson['articles']) {
        notes.add(Note.fromJson(noteJson));
      }
    }
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    // final words = WordPair.random();
    // return Text(words.asPascalCase);
    // Now adding the infinite scroll list
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('News Baby'),
      // ),
      body: _buildSuggestions(t),
    );
  }
}
