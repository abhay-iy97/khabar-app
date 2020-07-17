import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news/widgets/tab.dart';
import 'package:news/widgets/newslist.dart';
import 'package:news/widgets/contentpage.dart';
import 'package:news/entities/note.dart';
import 'package:english_words/english_words.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_tab_bar_no_ripple/flutter_tab_bar_no_ripple.dart';

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
