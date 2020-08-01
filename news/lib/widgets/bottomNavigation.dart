import 'package:flutter/material.dart';
import 'package:news/main.dart';
import 'package:news/widgets/app.dart';
import 'package:flutter/material.dart';
import 'tabItem.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({
    this.onSelectTab,
    this.tabs,
  });
  final ValueChanged<int> onSelectTab;
  final List<TabItem> tabs;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: tabs
          .map(
            (e) => _buildItem(
              index: e.getIndex(),
              icon: e.icon,
              // tabName: e.tabName,
            ),
          )
          .toList(),
      onTap: (index) => onSelectTab(
        index,
      ),
    );
  }

  BottomNavigationBarItem _buildItem({
    int index,
    IconData icon,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: 20.0,
        color: _tabColor(index: index),
      ),
      title: SizedBox.shrink(),
    );
  }

  Color _tabColor({int index}) {
    return AppState.currentTab == index ? Colors.cyan : Colors.grey;
  }
}
