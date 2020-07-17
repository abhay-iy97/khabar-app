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
          child: InkWell(
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

                    // Image,
                  ],
                ),
              ),
            ),
          );
        });}

    _navigateToPageDetails(BuildContext context, Note item) async {
    
    final resultFromPageDetails = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageDetails(
          item: item,
        ),
      ),
    );

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$resultFromPageDetails")));
  }