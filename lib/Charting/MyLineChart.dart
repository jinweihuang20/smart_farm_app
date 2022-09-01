// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:fbroadcast/fbroadcast.dart';

class MyLineChart extends StatefulWidget {
  final String name;
  final List<List<double>> dataRows;
  final List<String> xlables;
  final List<String> legends;

  const MyLineChart({Key? key, required this.name, required this.dataRows, required this.xlables, required this.legends}) : super(key: key);

  @override
  _MyLineChartState createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  late Widget _chartWidget;

  @override
  void initState() {
    super.initState();
    if (widget.xlables.isEmpty) {
      _chartWidget = chartToRun([
        [0]
      ], [
        "0"
      ], widget.legends);
    } else {
      _chartWidget = chartToRun(widget.dataRows, widget.xlables, widget.legends);
    }

    ///請求目前的數據組來顯示
    FBroadcast.instance().broadcast('chart-${widget.name}-req', value: "", callback: (value) {
      print('chart-${widget.name} callback!-update');
      setState(() {
        _chartWidget = chartToRun(value['dataRows'], value['xlabels'], value['legends']);
      });
    });

    FBroadcast.instance().register('chart-${widget.name}', (value, callback) {
      setState(() {
        print('chart-${widget.name} update');
        _chartWidget = chartToRun(value['dataRows'], value['xlabels'], value['legends']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
      height: 300,
      width: double.infinity,
      child: _chartWidget,
    ));
  }

  Widget chartToRun(List<List<double>> dataRows, List<String> xLabels, List<String> legends) {
    LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions();
    // Example shows an explicit use of the DefaultIterativeLabelLayoutStrategy.
    // The xContainerLabelLayoutStrategy, if set to null or not set at all,
    //   defaults to DefaultIterativeLabelLayoutStrategy
    // Clients can also create their own LayoutStrategy.
    xContainerLabelLayoutStrategy = DefaultIterativeLabelLayoutStrategy(
      options: chartOptions,
    );
    chartData = ChartData(
      dataRows: dataRows,
      xUserLabels: xLabels,
      dataRowsLegends: legends,
      chartOptions: chartOptions,
    );
    // chartData.dataRowsDefaultColors(); // if not set, called in constructor
    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var lineChart = LineChart(
      painter: LineChartPainter(
        lineChartContainer: lineChartContainer,
      ),
    );
    return lineChart;
  }
}
