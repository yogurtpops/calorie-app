import 'package:calorie_mobile/movas/observables/entry_o.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EntriesChart extends StatefulWidget {
  final AllEntriesO allEntriesO;
  final bool showDay;
  final DateTime startDate;
  final DateTime endDate;
  final double dailyCalLimit;


  EntriesChart({
    Key? key,
    required this.allEntriesO,
    this.showDay=true,
    required this.startDate,
    required this.endDate,
    required this.dailyCalLimit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EntriesChartState();
  }
}

class EntriesChartState extends State<EntriesChart> {
  List<BarChartGroupData> showingBarGroups = [];
  final double barWidth = 7;
  final double barSpace = 4;
  final dayLabels = ["Mon", "Th", "Wed", "Tue", "Fr", "Sat", "Sun"];
  late double maxY;

  @override
  void didUpdateWidget(Widget oldWidget) {
    if ((oldWidget as EntriesChart).allEntriesO != widget.allEntriesO
        || (oldWidget as EntriesChart).showDay != widget.showDay
        || (oldWidget as EntriesChart).startDate != widget.startDate
        || (oldWidget as EntriesChart).endDate != widget.endDate
        || (oldWidget as EntriesChart).dailyCalLimit != widget.dailyCalLimit) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        showingGroups();
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      showingGroups();
    });

    maxY = widget.dailyCalLimit;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: Color(0xff2c4260),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 38,
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY: maxY ?? widget.dailyCalLimit,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.grey,
                          getTooltipItem: (_a, _b, _c, _d) => null,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitles,
                            reservedSize: 42,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            interval: 1,
                            getTitlesWidget: leftTitles,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(width: 1.0, color: Colors.white),
                          bottom: BorderSide(width: 1.0, color: Colors.white),
                        )
                      ),
                      barGroups: showingBarGroups,
                      gridData: FlGridData(show: false),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget leftTitles(double value, TitleMeta meta) {
    // return Container();
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text = "";
    if (maxY == double.nan || value == double.nan) {
      return Container();
    } else if (value == 0) {
      text = '0 cal';
    } else if (value == maxY) {
      text = '$value cal';
    } else {
      return Container();
    }

    return Container(
        width: 16,
        child: Text(text, style: style));
  }


  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );

    Widget text;

    if (widget.showDay) {
      text = Text(
        dayLabels[value.toInt()],
        style: style,
      );
    } else {
        var day = widget.startDate.add(Duration(days: value.toInt())).day;
        var month = widget.startDate.add(Duration(days: value.toInt())).month;
        text = Text("$day/$month", style: style,);
    }

    return Padding(padding: const EdgeInsets.only(top: 20), child: text);
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(barsSpace: barSpace, x: x, barRods: [
      BarChartRodData(
          toY: y1,
          color: y1>widget.dailyCalLimit ? Colors.red : Colors.green,
          width: barWidth
      )
    ]);
  }

  showingGroups() {
    var showingBarGroups = List.generate(
        widget.endDate.difference(widget.startDate).inDays+1, (index) => makeGroupData(index, 0));

    for (var i in widget.allEntriesO.allEntries) {
      int index = i.createdAt.difference(widget.startDate).inDays.abs();
      double agrCalories = i.calories + showingBarGroups[index].barRods[0].toY;
      showingBarGroups.removeAt(index);
      showingBarGroups.insert(index, makeGroupData(index, agrCalories));
    }

    var maxy = widget.dailyCalLimit;
    for (var i in showingBarGroups) {
      if (i.barRods[0].toY > maxy) {
        maxy = i.barRods[0].toY;
      }
    }

    setState(() {
      maxY = maxy;
      this.showingBarGroups = showingBarGroups;
    });
  }

}