import 'package:flutter/material.dart';
import '../firebaseTest.dart';
import '../EventBuse.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  void initState() {
    super.initState();
    eventBus.on<Data>().listen((event) {
      print(event);
    });
    FirebaseDataListener listener = FirebaseDataListener();
    listener.startListen();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("??"),
    );
  }
}
