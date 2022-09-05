// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/services.dart';
import 'DetailInformation.dart';

/// 監控數據 Ｗidget
class HumidityDisplayWidget extends StatefulWidget {
  final String? installIn;
  final dynamic data;
  const HumidityDisplayWidget({Key? key, this.installIn, this.data}) : super(key: key);
  @override
  _HumidityDisplayWidget createState() => _HumidityDisplayWidget();
}

class _HumidityDisplayWidget extends State<HumidityDisplayWidget> {
  dynamic sensorData;
  dynamic get installIn_ori => widget.installIn;
  dynamic get updateTime => sensorData == null ? "?" : DateTimeFormat(sensorData["Datetime"]);
  dynamic get humidity => sensorData == null ? -1.0 : double.parse(sensorData["Humidity"].toString()).toStringAsFixed(2);
  dynamic get raw => sensorData == null ? -1.0 : double.parse(sensorData["Raw"].toString()).toStringAsFixed(2);
  String installIn = 'Unknown';
  String _newNameInput = '';
  late TextEditingController _textEditingController;
  List<List<double>> dataRows = [[], []];
  List<String> xlabels = [];
  List<String> legends = ["Humidity", "Raw"];

  late Widget detailInformationWidget;
  @override
  void initState() {
    print('HumidityDisplayWidget initState');

    super.initState();
    installIn = widget.installIn == null ? installIn : widget.installIn.toString();

    FBroadcast.instance().register(installIn, (value, callback) {
      setState(() {
        sensorData = value;

        var date = DateTimeFormat(sensorData["Datetime"]);

        if (xlabels.isNotEmpty) {
          if (xlabels.last == date) {
            return;
          }
        }

        dataRows[0].add(sensorData["Humidity"]);
        dataRows[1].add(double.parse(sensorData["Raw"].toString()));
        xlabels.add(date);

        if (xlabels.length > 10) {
          xlabels.removeAt(0);
          dataRows[0].removeAt(0);
          dataRows[1].removeAt(0);
        }
        broadcastChartData();
      });
    });
  }

  void broadcastChartData() {
    FBroadcast.instance().broadcast('chart-$installIn', value: {
      "dataRows": dataRows,
      "xlabels": xlabels,
      "legends": legends,
    });
  }

  String DateTimeFormat(dynamic timeData) {
    var dateTime = DateTime.parse(timeData);
    dateTime = dateTime.add(const Duration(hours: 8));

    var min = dateTime.minute.toString();
    var minDisplay = min.length == 1 ? '0$min' : min;

    var sec = dateTime.second.toString();
    var secDisplay = sec.length == 1 ? '0$sec' : sec;

    return '${dateTime.hour}:$minDisplay:$secDisplay';
  }

  void changeName() {
    if (_newNameInput == '') return;
    setState(() {
      installIn = _newNameInput;
    });
  }

  void renameHandler() {
    print('$installIn wanna rename');
    _textEditingController = TextEditingController(text: installIn);
    AlertDialog dialog = AlertDialog(
      title: Text('重新命名[$installIn]'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Center(
          child: TextFormField(
            autofocus: true,
            controller: _textEditingController,
            onChanged: (newValue) {
              _newNameInput = newValue;
              print(_newNameInput);
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: '輸入一個你喜歡的名稱',
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            changeName();
            Navigator.of(context).pop();
          },
          child: const Text(
            "OK",
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
          ),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            child: dialog,
          );
        });
  }

  void showDetailPage() {
    dynamic data = {"Name": installIn, "Humidity": humidity};
    detailInformationWidget = DetailInformation(data: data);
    FBroadcast.instance().register('chart-$installIn-req', (value, callback) {
      callback!({
        "dataRows": dataRows,
        "xlabels": xlabels,
        "legends": legends,
      });
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => detailInformationWidget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 16, 16, 16),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Padding(
              //title row
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.location_on_sharp,
                              size: 16,
                              color: Color.fromARGB(255, 186, 82, 74),
                            )),
                        TextButton(
                          onPressed: showDetailPage,
                          child: Text(
                            installIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: renameHandler,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blueGrey,
                    ),
                  ),
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
                Text('$raw', style: const TextStyle(color: Color.fromARGB(255, 123, 123, 123), fontSize: 20)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
