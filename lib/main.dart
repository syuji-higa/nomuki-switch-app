import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'pages/home.dart';
import 'pages/history.dart';

void main() {
  runApp(
    MaterialApp(
      title: '飲む気スイッチ',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.black87,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('飲む気スイッチ'),
        ),
        child: TabBar(),
      ),
    )
  );
}

class TabBar extends StatefulWidget {
  const TabBar();

  @override
  _TabBarState createState() => _TabBarState();
}

class _TabBarState extends State<TabBar> {
  final items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'ホーム',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'ヒストリー',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: items,
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            switch (index) {
              case 0:
                return HomePage();
              case 1:
                return HistoryPage();
            }
            return HomePage();
          },
        );
      },
    );
  }
}
