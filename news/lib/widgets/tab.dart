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
