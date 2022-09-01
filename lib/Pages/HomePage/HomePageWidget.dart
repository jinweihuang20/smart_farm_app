// ignore_for_file: avoid_print, unused_element, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'Components/HumidityDisplayWidget.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  dynamic homeData = {"Raw": -1, "Humidity": -1, "DateTime": ""};
  Map<String, dynamic> sensorDatas = {};
  var valuesWidgets = <Widget>[];

  @override
  void initState() {
    print('ini');
    super.initState();
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) => {startListenData()});
  }

  void createValueDisplayWidget(Map<String, dynamic> firebaseData) {
    valuesWidgets = <Widget>[];
    firebaseData.keys.forEach((key) => {valuesWidgets.add(HumidityDisplayWidget(installIn: key))});
    setState(() {});
    print(valuesWidgets);
  }

  Future<void> startListenData() async {
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('SensingValues');
    dynamic dataFetch = await starCountRef.get();
    Map<String, dynamic> _data = Map<String, dynamic>.from(dataFetch.value as Map);
    print(dataFetch.value);
    createValueDisplayWidget(_data);

    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      Map<String, dynamic> _data = Map<String, dynamic>.from(data as Map);
      // ignore: avoid_function_literals_in_foreach_calls
      _data.keys.forEach((_key) {
        FBroadcast.instance().broadcast(_key, value: _data[_key]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Text('${homeData["Raw"]}'),
    // );
    return Container(
        width: double.infinity,
        color: (Colors.black87),
        child: ListView(
          children: valuesWidgets,
        ));
  }
}
