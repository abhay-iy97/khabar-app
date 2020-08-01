import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news/widgets/tab.dart';
import 'package:news/widgets/newslist.dart';
import 'package:flutter_tab_bar_no_ripple/flutter_tab_bar_no_ripple.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Color c = const Color(0x417be8);
  int _currentIndex = 0;
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: allTabs.length,
      child: new Scaffold(
        // body: new NestedScrollView(
        // headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        // return <Widget>[
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            // centerTitle: true,
            // title: Text("Home",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //         fontFamily: 'Roboto',
            //         color: Colors.black,
            //         fontWeight: FontWeight.w700)),

            backgroundColor: Colors.white,
            // floating: true,
            // pinned: true,
            // snap: true,
            //TODO: there is an added dependency for using TabBarNoRipple, which is flutter_tab_bar_no_ripple
            // write your own tab bar with no ripple effect.

            bottom: new TabBarNoRipple(
              //isScrollable: true,
              isScrollable: true,
              // indicatorColor: Colors.transparent,
              // labelStyle: TextStyle(
              //     fontFamily: 'PlayfairDisplay',
              //     fontWeight: FontWeight.w700,
              //     fontStyle: FontStyle.italic,
              //     fontSize: 25),
              // unselectedLabelStyle: TextStyle(
              //     fontFamily: 'CrimsonText',
              //     fontWeight: FontWeight.w700,
              //     fontSize: 25),
              //controller: controller,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: new BubbleTabIndicator(
                indicatorHeight: 25.0,
                indicatorColor: Colors.grey,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              labelColor: Colors.black,
              // unselectedLabelColor: Colors.black.withOpacity(0.4),
              tabs: allTabs
                  .map<Widget>((Tabs tab) => Tab(text: tab.name))
                  .toList(),

              // tabs: <Tab>[
              //   new Tab(text: "T"),
              //   new Tab(text: "B"),
              //], // <-- total of 2 tabs
            ),
          ),
        ),
        // ];
        // },
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
        // ),
        // bottomNavigationBar: customBottomNavigationBar(context),
        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   elevation: 19,
        //   currentIndex: _currentIndex,
        //   backgroundColor: Colors.grey[50],
        //   selectedItemColor: Colors.grey[800].withOpacity(.9),
        //   // unselectedItemColor: Colors.white.withOpacity(.6),
        //   unselectedItemColor: Colors.grey[700].withOpacity(.5),
        //   selectedFontSize: 14,
        //   unselectedFontSize: 14,
        //   onTap: (value) {
        //     // Respond to item press.
        //     setState(() => _currentIndex = value);
        //   },
        //   items: [
        //     //bottomnavbar of material forces title
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.home), title: SizedBox.shrink()),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.play_circle_outline),
        //         title: SizedBox.shrink()),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.category), title: SizedBox.shrink()),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.person), title: SizedBox.shrink()),
        //   ],
        // ),
        // //   bottomNavigationBar: BottomAppBar(
        //     child: Container(
        //       height: 25,
        //       child: new Row(
        //         mainAxisSize: MainAxisSize.min,
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: <Widget>[
        //           SizedBox(width: 7),
        //           IconButton(
        //             icon: Icon(
        //               Icons.home,
        //               size: 24.0,
        //             ),
        //           ),
        //           IconButton(
        //             icon: Icon(
        //               Icons.favorite,
        //               size: 24.0,
        //             ),
        //           ),
        //           IconButton(
        //             icon: Icon(
        //               Icons.search,
        //               size: 24.0,
        //               color: Theme.of(context).primaryColor,
        //             ),
        //           ),
        //           IconButton(
        //             icon: Icon(
        //               Icons.person,
        //               size: 24.0,
        //             ),
        //           ),
        //           SizedBox(width: 7),
        //         ],
        //       ),
        //     ),
        //     elevation: 0,
        //     //color: Theme.of(context).primaryColor,
        //     color: Colors.white38,

        //     shape: CircularNotchedRectangle(),
        //   ),
        //
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

// Widget customBottomNavigationBar(BuildContext context) {
//   double myHeight = 50.0; //Your height HERE
//   return SizedBox(
//     height: myHeight,
//     width: MediaQuery.of(context).size.width,
//     child: TabBar(
//         tabs: [
//           Tab(text: null, icon: Icon(Icons.home, size: 20.0)),
//           Tab(text: null, icon: Icon(Icons.search, size: 20.0)),
//           Tab(text: null, icon: Icon(Icons.person, size: 20.0)),
//           Tab(text: null, icon: Icon(Icons.menu, size: 20.0)),
//         ],
//         labelStyle: TextStyle(fontSize: 12.0),
//         labelColor: Colors.black,
//         unselectedLabelColor: Colors.black,
//         // indicatorSize: TabBarIndicatorSize.label,
//         // indicatorColor: Colors.red,
//         indicatorColor: Colors.transparent),
//   );
// }
