// ignore_for_file: avoid_print, unused_element

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

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
    ).then((value) => {firebaseIni()});
  }

  Future<void> firebaseIni() async {
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('SensingValues');
    dynamic dataFetch = await starCountRef.get();
    print(dataFetch.value);
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      Map<String, dynamic> _data = Map<String, dynamic>.from(data as Map);
      sensorDatas = _data;
      setState(() {
        valuesWidgets = <Widget>[];
        data.keys.forEach((key) => {
              valuesWidgets.add(HumidityDisplayWidget(
                installIn: key,
                data: sensorDatas[key],
              ))
            });

        print(valuesWidgets);
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

/// 監控數據 Ｗidget
class HumidityDisplayWidget extends StatefulWidget {
  final String? installIn;
  final dynamic data;
  const HumidityDisplayWidget({Key? key, this.installIn, this.data}) : super(key: key);
  @override
  _HumidityDisplayWidget createState() => _HumidityDisplayWidget();
}

class _HumidityDisplayWidget extends State<HumidityDisplayWidget> {
  dynamic get humidity_ori => widget.data["Humidity"];
  dynamic get installIn_ori => widget.installIn;

  dynamic get humidity => humidity_ori == null ? -1.0 : double.parse(humidity_ori.toString()).toStringAsFixed(2);
  String get installIn => installIn_ori == null ? "Unknown" : installIn_ori;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 16, 16, 16),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.location_on_sharp,
                    color: Color.fromARGB(255, 186, 82, 74),
                  ),
                  Text(installIn, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Color.fromARGB(255, 168, 167, 167))),
                ],
              )),
          const Divider(
            color: Color.fromARGB(135, 65, 65, 65),
            indent: 10,
            endIndent: 10,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.water_drop_outlined,
                  size: 26,
                  color: Color.fromARGB(205, 38, 179, 230),
                ),
                Text('$humidity%', style: const TextStyle(fontFamily: '微軟正黑體', color: Colors.white, fontSize: 40)),
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text('|', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                const Icon(
                  Icons.raw_on_rounded,
                  size: 32,
                  color: Color.fromARGB(205, 214, 214, 214),
                ),
                Text('${widget.data["Raw"]}', style: const TextStyle(color: Color.fromARGB(255, 123, 123, 123), fontSize: 20)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
