// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'EventBuse.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref();
DatabaseReference starCountRef = FirebaseDatabase.instance.ref('SensingValues');

class FirebaseDataListener {
  FirebaseDataListener() {
    startListen();
  }

  Future<void> startListen() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      Map<String, dynamic> _sensorValue = Map<String, dynamic>.from(data as Map);
      print(_sensorValue);
      Data mega = Data("Megga", double.parse(_sensorValue["Megga"].toString()));
      Data d1wifi = Data("D1WiFi", double.parse(_sensorValue["D1WiFi"].toString()));
      eventBus.fire(<Data>[mega, d1wifi]);
    });
  }
}

class Data {
  String name;
  double value;
  Data(this.name, this.value);
}
