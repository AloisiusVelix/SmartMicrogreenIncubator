import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:microgreen_app/app/modules/home/controllers/home_controller.dart';

class tablePage extends StatefulWidget {
  const tablePage({
    super.key,
    required HomeController homeController,
  }) : _homeController = homeController;

  final HomeController _homeController;

  @override
  State<tablePage> createState() => _tablePageState();
}

class _tablePageState extends State<tablePage> {
  late int stateGrafik = 1;
  late int minGrafik = 12;
  late int devGrafik = 3;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Table(),
          ),
        ),
      ),
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

  DataTable Table() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Temp')),
        DataColumn(label: Text('Humi')),
        DataColumn(label: Text('Soil'))
      ], 
      rows: List<DataRow>.generate(
        DataLenght(), // 1 jam terakhir
        (index) { 
          final reversedIndex = widget._homeController.allDataDate.length - index - 1;
          final isEvenRow = index % 2 == 0;
          final rowColor = isEvenRow? Colors.white : const Color(0xFFD9D9D9);
          return DataRow(
            color: MaterialStateColor.resolveWith((states) => rowColor),
            cells: [
              DataCell(Text(widget._homeController.allDataDate[reversedIndex].toString())),
              DataCell(Text(widget._homeController.allDataTemp[reversedIndex].toString())),
              DataCell(Text(widget._homeController.allDataHumidity[reversedIndex].toString())),
              DataCell(Text(widget._homeController.allDataSoil[reversedIndex].toString())),
            ]
          );
        }
      ),
    );
  }

  int DataLenght() {
    if (widget._homeController.allDataDate.length < 360) {
      return widget._homeController.allDataDate.length;
    }
    else {
      return 360;
    }
  }
}
