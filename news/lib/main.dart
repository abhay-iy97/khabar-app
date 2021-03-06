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
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:news/plugins/platform/myplatform.dart';
import 'package:news/plugins/platform/platform.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_tab_bar_no_ripple/flutter_tab_bar_no_ripple.dart';

class Tabs {
  Tabs({this.name, this.url});
  final String name;
  final String url;
}

final List<Tabs> allTabs = <Tabs>[
  Tabs(
      name: 'Featured News',
      url:
          'https://raw.githubusercontent.com/abhay-iy97/kratos-data-source/master/json/topHeadlines/in.json'),
  Tabs(
      name: 'Local News',
      url:
          'https://raw.githubusercontent.com/abhay-iy97/kratos-data-source/master/json/topHeadlines/in.json'),
  Tabs(
      name: 'Business',
      url:
          'https://raw.githubusercontent.com/abhay-iy97/kratos-data-source/master/json/topHeadlines/us.json'),
  Tabs(
      name: 'Sports',
      url:
          'https://raw.githubusercontent.com/Shashi456/Deep-Learning/master/data.json'),
  //Tabs(name: '', url: ''),
];

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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Color c = const Color(0x417be8);
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: allTabs.length,
      child: new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                centerTitle: true,
                title: Text("Home",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontWeight: FontWeight.w700)),
                backgroundColor: Colors.white,
                floating: true,
                pinned: true,
                snap: true,
                //TODO: there is an added dependency for using TabBarNoRipple, which is flutter_tab_bar_no_ripple
                // write your own tab bar with no ripple effect.
                bottom: new TabBarNoRipple(
                  //isScrollable: true,
                  isScrollable: true,
                  indicatorColor: Colors.transparent,
                  labelStyle: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontWeight: FontWeight.w700,
                      //fontStyle: FontStyle.italic,
                      fontSize: 25),
                  unselectedLabelStyle: TextStyle(
                      fontFamily: 'CrimsonText',
                      fontWeight: FontWeight.w700,
                      fontSize: 25),
                  //controller: controller,
                  // indicatorSize: TabBarIndicatorSize.tab,
                  // indicator: new BubbleTabIndicator(
                  //   indicatorHeight: 25.0,
                  //   indicatorColor: Colors.lightBlue,
                  //   tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  // ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black.withOpacity(0.4),
                  tabs: allTabs
                      .map<Widget>((Tabs tab) => Tab(text: tab.name))
                      .toList(),

                  // tabs: <Tab>[
                  //   new Tab(text: "T"),
                  //   new Tab(text: "B"),
                  //], // <-- total of 2 tabs
                ),
              ),
            ];
          },
          body: new TabBarView(
            children: allTabs.map<Widget>((Tabs url) {
              return PaletteTabView(t: url);
            }).toList(),
          ),
          // body: new TabBarView(
          //   // children: <Widget>[
          //   //   Center(
          //   //       child: Text(
          //   //     'T Tab',
          //   //     style: TextStyle(fontSize: 30),
          //   //   )),
          //   //   Center(
          //   //       child: Text(
          //   //     'B Tab',
          //   //     style: TextStyle(fontSize: 30),
          //   //   )),
          //   // ],
          //   children: <Widget>[
          //     new RandomWords(),
          //     new RandomWords(),
          //   ],
          // ),
        ),
      ),
    );
  }
}

class PaletteTabView extends StatelessWidget {
  PaletteTabView({
    Key key,
    @required this.t,
  })  : assert(t != null),
        super(key: key);

  final Tabs t;

  @override
  Widget build(BuildContext context) {
    return RandomWords(t: t);
  }
}

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
