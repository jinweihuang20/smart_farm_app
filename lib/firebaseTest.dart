// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'EventBuse.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref();
DatabaseReference starCountRef = FirebaseDatabase.instance.ref('Megga');

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
      eventBus.fire(Data('mega', double.parse(data.toString())));
    });
  }
}

class Data {
  String name;
  double value;
  Data(this.name, this.value);
}
