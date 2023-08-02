import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class monitoringPart extends StatelessWidget {
  const monitoringPart({
    super.key,
    required HomeController homeController,
  }) : _homeController = homeController;

  final HomeController _homeController;

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
      const SizedBox(height: 40),
      //Temperature
      monitoringBar2(
        homeController: _homeController,
        label: 'Temperature',
        icon: 'assets/images/temp_icon.png',
        value: _homeController.temperature,
        unit: 'Celcius',
        target: _homeController.set_temp,
        act1: 'assets/images/air_cooler1.png', 
        valueAct1: _homeController.airCooler,
        labelAct1: 'air cooler', 
        colorAct1: Colors.green, 
        act2: 'assets/images/mist1.png',
        valueAct2: _homeController.mist, 
        labelAct2: 'mist maker', 
        colorAct2: Colors.cyan
      ),
      const SizedBox(height: 20),
      //Humidity
      monitoringBar2(
        homeController: _homeController, 
        label: 'Kelembapan Udara', 
        icon: 'assets/images/humidity_icon.png', 
        value: _homeController.humidity, 
        unit: 'Percent', 
        target: _homeController.set_humi, 
        act1: 'assets/images/air_cooler1.png', 
        valueAct1: _homeController.airCooler,
        labelAct1: 'air cooler', 
        colorAct1: Colors.green, 
        act2: 'assets/images/mist1.png',
        valueAct2: _homeController.mist, 
        labelAct2: 'mist maker', 
        colorAct2: Colors.cyan
      ),
      const SizedBox(height: 20),
      monitoringBar2(
        homeController: _homeController, 
        label: 'Kelembapan Tanah', 
        icon: 'assets/images/soil_moisture.png', 
        value: _homeController.soilMoisture, 
        unit: 'Percent', 
        target: _homeController.set_soil, 
        act1: 'assets/images/watering1.png',
        valueAct1: _homeController.watering, 
        labelAct1: 'watering', 
        colorAct1: Colors.blue,
        act2: 'assets/images/lamp1.png',
        valueAct2: _homeController.uvLamp, 
        labelAct2: 'uv lamp', 
        colorAct2: Colors.purple,
      ),
      const SizedBox(height: 30),
      monitoringBar1(
        label: 'Kapasitas Air', 
        icon: 'assets/images/water_level.png',
        value: _homeController.waterLevel, 
        unit: 'Liters', 
        homeController: _homeController,
      ),
      const SizedBox(height: 40)
    ],
  );
  }
}

class monitoringBar3 extends StatelessWidget {
  monitoringBar3({
    super.key,
    required HomeController homeController, 
    required this.act, 
    required this.valueAct,
    required this.colorAct,
    required this.label,
    required this.value, 
    required this.unit,
  }) : _homeController = homeController;

  final HomeController _homeController;
  final String act;
  RxInt valueAct;
  final Color colorAct;
  final String label;
  RxDouble value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 100,
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
      child: Column(
        children: [
          Container(
            height: 30,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Image.asset(act, color: valueAct.value == 2 ? colorAct : Colors.black, scale: 3.5)),
                const SizedBox(width: 10),
                Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400))
              ],
            ),
          ),
          const Spacer(),
          Obx(() => Text(value.value.toStringAsFixed(2), style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w600))),
          const SizedBox(height: 5),
          Text(unit, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
          const Spacer(),
        ],
      ),
    );
  }
}

class monitoringBar2 extends StatelessWidget {

  monitoringBar2({
    super.key,
    required HomeController homeController, 
    required this.label,
    required this.icon, 
    required this.value, 
    required this.unit, 
    required this.target, 
    required this.act1, 
    required this.valueAct1, 
    required this.labelAct1, 
    required this.colorAct1, 
    required this.act2, 
    required this.valueAct2, 
    required this.labelAct2, 
    required this.colorAct2
  }) : _homeController = homeController;

  final HomeController _homeController;
  final String label;
  final String icon;
  RxDouble value;
  final String unit;
  RxDouble target;
  final String act1;
  RxInt valueAct1;
  final String labelAct1;
  final Color colorAct1;
  final String act2;
  RxInt valueAct2;
  final String labelAct2;
  final Color colorAct2;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 100,
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
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF1F1F1F), fontWeight: FontWeight.w400)),
                const Spacer(),
                ImageIcon(AssetImage(icon), size: 20, color: const Color(0xFF1F1F1F))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(() => Text(value.value.toStringAsFixed(2), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600))),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(unit, style: const TextStyle(fontSize: 8, color: Color(0xFF1F1F1F), fontWeight: FontWeight.w400)),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text('target : ', style: TextStyle(fontSize: 8, color: Color(0xFF1F1F1F), fontWeight: FontWeight.w400)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Obx(() => Text(target.value.toStringAsFixed(1), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400))),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: 30,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Image.asset(act1, color: valueAct1.value == 2 ? colorAct1 : Colors.black, scale: 3.2,)),
                const SizedBox(width: 5),
                Text(labelAct1, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                const SizedBox(width: 40),
                Obx(() => Image.asset(act2, color: valueAct2.value == 2 ? colorAct2 : Colors.black, scale: 3.2)),
                const SizedBox(width: 5),
                Text(labelAct2, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
              ]
            ),
          )
        ],
      ),
    );
  }
}

class monitoringBar1 extends StatelessWidget {

  monitoringBar1({
    super.key,
    required HomeController homeController, 
    required this.label,
    required this.icon, 
    required this.value, 
    required this.unit, 

  }) : _homeController = homeController;

  final HomeController _homeController;
  final String label;
  final String icon;
  RxDouble value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 100,
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
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF1F1F1F), fontWeight: FontWeight.w400)),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3, right: 3),
                  child: ImageIcon(AssetImage(icon), size: 14, color: const Color(0xFF1F1F1F)),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(() => Text(value.value.toStringAsFixed(2), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600))),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(unit, style: const TextStyle(fontSize: 8, color: Color(0xFF1F1F1F), fontWeight: FontWeight.w400)),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text('target : ', style: TextStyle(fontSize: 8, color: Color(0xFF1F1F1F), fontWeight: FontWeight.w400)),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text('16.6', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: 30,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          )
        ],
      ),
    );
  }
}