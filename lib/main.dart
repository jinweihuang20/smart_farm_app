// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'Pages/HomePage/HomePageWidget.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, appBarTheme: const AppBarTheme(color: Colors.black)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // home: DefaultTabController(
      //     length: 3,
      //     child: Scaffold(
      //       appBar: AppBar(
      //           title: const Text("Demo"),
      //           bottom: const TabBar(tabs: [
      //             Tab(text: "臥草", icon: Icon(Icons.grass)),
      //             Tab(text: "History", icon: Icon(Icons.query_stats_rounded)),
      //             Tab(text: "設定", icon: Icon(Icons.settings_applications_outlined))
      //           ])),
      //       body: const TabBarView(children: [Icon(Icons.abc), Icon(Icons.baby_changing_station_rounded), Icon(Icons.cabin)]),
      //     )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectIndex = 0;
  String _title = "Home";
  final _titles = ["Home", "History"];
  final _titleIcons = [const Icon(Icons.grass), const Icon(Icons.query_stats_rounded)];
  final _pages = <Widget>[const HomePageWidget(), const Text('Not yet')];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          children: <Widget>[_titleIcons[_selectIndex], Text(_title)],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.grass_rounded)),
          BottomNavigationBarItem(label: "History", icon: Icon(Icons.query_stats_sharp))
        ],
        currentIndex: _selectIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectIndex = value;
      _title = _titles[_selectIndex];
    });
  }
}
