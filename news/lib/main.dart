import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:path_provider/path_provider.dart';
import 'package:news/entities/note.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:news/plugins/platform/myplatform.dart';
import 'package:news/plugins/platform/platform.dart';
import 'package:flutter/cupertino.dart';

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
          return Card(
            child: new InkWell(
              onTap: () {
                _navigateToPageDetails(context, _notes[i]);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _notes[i].title,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _notes[i].text,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    Image.network(_notes[i].image)
                  ],
                ),
              ),
            ),
          );
        });
  }

  _navigateToPageDetails(BuildContext context, Note item) async {
    //Holds the results returned from PageDetails.
    final resultFromPageDetails = await Navigator.push(context, CupertinoPageRoute(builder: (context) => PageDetails(item: item,),),);

    //TODO: Navigation implementations are discussed in upcoming Navigation section of this article

    //snackbars is used to display the result returned from another page.
    //Hide any previous snackbars and show the new resultFromPageDetails.
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$resultFromPageDetails"))); // REMOVE.
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  Future<List<Note>> fetchNotes() async {
    var url =
        'https://raw.githubusercontent.com/Shashi456/Deep-Learning/master/data.json';
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
      appBar: AppBar(
        title: Text('News Baby'),
      ),
      body: _buildSuggestions(),
    );
  }
}

class navPageRoute extends CupertinoPageRoute {
  navPageRoute(): super(builder: (BuildContext context) => new PageDetails()) ;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new PageDetails());
  }
}

class PageDetails extends StatefulWidget {
  PageDetails({Key key, this.item}) : super(key: key);
  final Note item;
  @override
  _PageDetails createState() => new _PageDetails();
}

class _PageDetails extends State<PageDetails> {
  String description =
      "The Griffith Observatory is the most iconic building in Los Angeles, perched high in the Hollywood Hills, 1,134 feet above sea level.";
  bool isPlaying = false;
  FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    initializeTts();
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }

  initializeTts() {
    _flutterTts = FlutterTts();

    if (PlatformUtil.myPlatform() == MyPlatform.ANDROID) {
      _flutterTts.ttsInitHandler(() {
        setTtsLanguage();
      });
    } else if (PlatformUtil.myPlatform() == MyPlatform.IOS) {
      setTtsLanguage();
    } else if (PlatformUtil.myPlatform() == MyPlatform.WEB) {
      //not-supported by plugin
    }

    _flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    _flutterTts.setErrorHandler((err) {
      setState(() {
        print("error occurred: " + err);
        isPlaying = false;
      });
    });
  }

  void setTtsLanguage() async {
    await _flutterTts.setLanguage("en-US");
  }

  void speechSettings1() {
    _flutterTts.setVoice("en-us-x-sfg#male_1-local");
    _flutterTts.setPitch(1.5);
    _flutterTts.setSpeechRate(.9);
  }

  void speechSettings2() {
    _flutterTts.setVoice("en-us-x-sfg#male_2-local");
    _flutterTts.setPitch(1);
    _flutterTts.setSpeechRate(0.5);
  }

  Future _speak(String text) async {
    if (text != null && text.isNotEmpty) {
      var result = await _flutterTts.speak(text);
      if (result == 1)
        setState(() {
          isPlaying = true;
        });
    }
  }

  Future _stop() async {
    var result = await _flutterTts.stop();
    if (result == 1)
      setState(() {
        isPlaying = false;
      });
  }

  Widget playButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 30.0, right: 30.0, bottom: 20.0),
            child: FlatButton(
              onPressed: () {
                //fetch another image
                setState(() {
                  //speechSettings1();
                  //isPlaying ? _stop() : _speak("descriptions yes no");
                  _speak(widget.item.text);
                });
              },
              child: isPlaying
                  ? Icon(
                      Icons.stop,
                      size: 60,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.play_arrow,
                      size: 60,
                      color: Colors.green,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
      ),
      body: Column(
        children: [
          Text(
            widget.item.text,
            style: TextStyle(color: Colors.black),
          ),
          Image.network(widget.item.image),
          Text(
            "yolo",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          playButton(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.favorite_border),
        onPressed: () {
          //Current item's name along with message is sent back to last screen
          Navigator.pop(context, '${widget.item.title} is marked as favorite.');
        },
      ),
    );
  }
}

class TTSPluginRecipe extends StatefulWidget {
  @override
  _TTSPluginRecipeState createState() => _TTSPluginRecipeState();
}

class _TTSPluginRecipeState extends State<TTSPluginRecipe> {
  String description =
      "The Griffith Observatory is the most iconic building in Los Angeles, perched high in the Hollywood Hills, 1,134 feet above sea level.";
  bool isPlaying = false;
  FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    initializeTts();
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }

  initializeTts() {
    _flutterTts = FlutterTts();

    if (PlatformUtil.myPlatform() == MyPlatform.ANDROID) {
      _flutterTts.ttsInitHandler(() {
        setTtsLanguage();
      });
    } else if (PlatformUtil.myPlatform() == MyPlatform.IOS) {
      setTtsLanguage();
    } else if (PlatformUtil.myPlatform() == MyPlatform.WEB) {
      //not-supported by plugin
    }

    _flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    _flutterTts.setErrorHandler((err) {
      setState(() {
        print("error occurred: " + err);
        isPlaying = false;
      });
    });
  }

  void setTtsLanguage() async {
    await _flutterTts.setLanguage("en-US");
  }

  void speechSettings1() {
    _flutterTts.setVoice("en-us-x-sfg#male_1-local");
    _flutterTts.setPitch(1.5);
    _flutterTts.setSpeechRate(.9);
  }

  void speechSettings2() {
    _flutterTts.setVoice("en-us-x-sfg#male_2-local");
    _flutterTts.setPitch(1);
    _flutterTts.setSpeechRate(0.5);
  }

  Future _speak(String text) async {
    if (text != null && text.isNotEmpty) {
      var result = await _flutterTts.speak(text);
      if (result == 1)
        setState(() {
          isPlaying = true;
        });
    }
  }

  Future _stop() async {
    var result = await _flutterTts.stop();
    if (result == 1)
      setState(() {
        isPlaying = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Griffith Observatory",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 1.25,
                            width: MediaQuery.of(context).size.width / 1.25,
                            child: Image.asset(
                                "assets/images/griffith_observatory.jpg"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(description),
                ),
                playButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget playButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 30.0, right: 30.0, bottom: 20.0),
            child: FlatButton(
              onPressed: () {
                //fetch another image
                setState(() {
                  //speechSettings1();
                  isPlaying ? _stop() : _speak(description);
                });
              },
              child: isPlaying
                  ? Icon(
                      Icons.stop,
                      size: 60,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.play_arrow,
                      size: 60,
                      color: Colors.green,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
