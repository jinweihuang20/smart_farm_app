import 'package:flutter/material.dart';
import 'package:fbroadcast/fbroadcast.dart';
import '../../../Charting/MyLineChart.dart';

class DetailInformation extends StatefulWidget {
  final dynamic data;
  const DetailInformation({Key? key, this.data}) : super(key: key);

  @override
  _DetailInformationState createState() => _DetailInformationState();
}

class _DetailInformationState extends State<DetailInformation> {
  String get title => widget.data["Name"];
  dynamic sensorData;
  dynamic get humidity => sensorData == null ? "?" : sensorData["Humidity"];
  dynamic get updateTime => sensorData == null ? "?" : DateTimeFormat(sensorData["Datetime"]);
  List<List<double>> dataRows = [[]];
  List<String> xlabels = [];
  List<String> legends = ["Humidity"];

  late Widget chartWidget;

  String DateTimeFormat(dynamic timeData) {
    var dateTime = DateTime.parse(timeData);
    dateTime = dateTime.add(const Duration(hours: 8));
    var min = dateTime.minute.toString();
    var minDisplay = min.length == 1 ? '0$min' : min;
    var sec = dateTime.second.toString();
    var secDisplay = sec.length == 1 ? '0$sec' : sec;
    return '${dateTime.hour}:$minDisplay:$secDisplay';
  }

  @override
  void initState() {
    chartWidget = ChartingWidget(title, dataRows, xlabels, legends);
    super.initState();
    FBroadcast.instance().register(title, (value, callback) {
      setState(() {
        sensorData = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(color: Colors.black87),
        child: ListView(children: [topWidget(humidity, updateTime), titleWidget("趨勢圖", Icons.trending_down_rounded), chartWidget]),
      ),
    );
  }

  Widget titleWidget(String text, IconData icon) {
    Color _color = Color.fromARGB(223, 255, 255, 255);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(icon, color: _color),
          ),
          Text(
            text,
            style: TextStyle(color: _color),
          )
        ],
      ),
    );
  }

  Widget topWidget(dynamic humidity, String updateTime) {
    Color foreColor = Colors.white;
    return Card(
      color: Color.fromARGB(255, 80, 121, 141),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.water_drop_rounded,
                  color: Color.fromARGB(255, 89, 166, 230),
                ),
                Text(
                  "$humidity",
                  style: TextStyle(color: foreColor),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "更新時間:",
                  style: TextStyle(color: foreColor),
                ),
                Text(
                  updateTime,
                  style: TextStyle(color: foreColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget ChartingWidget(String name, List<List<double>> dataRows, List<String> xlabels, List<String> legends) {
    return Card(
      color: const Color.fromARGB(255, 0, 0, 0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          height: 300,
          width: double.infinity,
          child: Center(
            child: MyLineChart(
              name: name,
              dataRows: dataRows,
              xlables: xlabels,
              legends: legends,
            ),
          ),
        ),
      ),
    );
  }
}
