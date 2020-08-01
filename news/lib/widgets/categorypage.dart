import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final Function openSettings;
  const CategoryPage({Key key, this.openSettings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("Category Page"),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewPage(),
            ),
          );
        },
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Screen',
        ),
      ),
      body: Container(
        child: FlatButton(
          child: Text("Push new Screen"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
