import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WaterSwitchWidget extends StatefulWidget {
  final String installIn;
  const WaterSwitchWidget({Key? key, required this.installIn}) : super(key: key);

  @override
  _WaterSwitchWidgetState createState() => _WaterSwitchWidgetState();
}

class _WaterSwitchWidgetState extends State<WaterSwitchWidget> {
  bool waterOn = false;
  late WaterSwitchHttpRequest switchHttp;

  void switchStateChanged(value) {
    setState(() {
      waterOn = value;
      if (waterOn) {
        switchHttp.on();
      } else {
        switchHttp.off();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    switchHttp = WaterSwitchHttpRequest(widget.installIn);
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: switchStateChanged,
      value: waterOn,
    );
  }
}

class WaterSwitchHttpRequest {
  dynamic url;
  WaterSwitchHttpRequest(String install) {
    url = Uri.https("smartfarm-7f8c0-default-rtdb.firebaseio.com", 'SensingValues/${install}.json');
  }
  on() {
    dynamic map = {"RelaySwitchReq": true};
    patch(url, body: json.encode(map)).then((value) => {print(value.body)});
  }

  off() {
    dynamic map = {"RelaySwitchReq": true};
    patch(url, body: json.encode(map)).then((value) => {print(value.body)});
  }
}
