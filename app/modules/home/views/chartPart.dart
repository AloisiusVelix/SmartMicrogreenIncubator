import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:microgreen_app/app/modules/home/controllers/home_controller.dart';

class chartPage extends StatefulWidget {
  const chartPage({
    super.key,
    required HomeController homeController,
  }) : _homeController = homeController;

  final HomeController _homeController;

  @override
  State<chartPage> createState() => _chartPageState();
}

class _chartPageState extends State<chartPage> {
  late int stateGrafik = 1;
  late int minGrafik = 12;
  late int devGrafik = 3;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Temperature', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 4)
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    child: Grafik(widget._homeController.allDataTemp, 5, minGrafik, devGrafik),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Humidity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 4)
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    child: Grafik(widget._homeController.allDataHumidity, 20, minGrafik, devGrafik),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Soil Moisture', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 4)
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    child: Grafik(widget._homeController.allDataSoil, 20, minGrafik, devGrafik),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    settingGrafik('1 Jam', 1, 12, 3),
                    const Spacer(),
                    settingGrafik('12 Jam', 2, 144, 5),
                    const Spacer(),
                    settingGrafik('1 Hari', 3, 288, 5),
                    const Spacer(),
                    settingGrafik('All', 4, widget._homeController.allDataDate.length, 5),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineChart Grafik(var listData, double? interval, int minX, int dev) {
    List<String> allDataDate = widget._homeController.allDataDate.map<String>((element) => element as String).toList();
    List<double> allDataTemp = listData.map<double>((element) => element as double).toList();
    double maxValue = allDataTemp.reduce(((value, element) => value > element ? value : element));

    return LineChart(
      LineChartData(
        clipData: FlClipData.all(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: (minX / dev),
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < allDataDate.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      allDataDate[index],
                      style: const TextStyle(
                        fontSize: 8
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            )
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: interval,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == 0 || value == maxValue + 2) {
                  return const Text('');
                }
                return Text(
                  value.toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            )
          )
        ),
        lineTouchData: LineTouchData(enabled: true),
        minX: allDataDate.length.toDouble() - minX,
        maxX: allDataDate.length.toDouble() - 1,
        minY: 0,
        maxY: allDataTemp.reduce((value, element) => value > element ? value : element) + 2,
        lineBarsData: [
          LineChartBarData(
            spots: allDataTemp.asMap().entries.map((e) {
              final index = e.key;
              final value = e.value;
              return FlSpot(index.toDouble(), value);
            }).toList(),
            isCurved: false,
            color: Colors.green,
            barWidth: 3,
            dotData: FlDotData(show: false),
          )
        ], 
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Colors.black),
            left: BorderSide(color: Colors.black)
          ),
        ),
        gridData: FlGridData(
          show: false
        )
      )
    );
  }

  GestureDetector settingGrafik(String title, int state, int grafik, int dev) {
    return GestureDetector(
      onTap: () {
        setState(() {
          stateGrafik = state;
          minGrafik = grafik;
          devGrafik = dev;
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: MediaQuery.of(context).size.width * 0.2,
        decoration: BoxDecoration(
          color: stateGrafik == state ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: const Offset(0, 4)
            )
          ]
        ),
        child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: stateGrafik == state ? Colors.white : Colors.black)),
      ),
    );
  }
}
