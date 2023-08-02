import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:microgreen_app/app/widgets/frostedglass.dart';

import '../controllers/home_controller.dart';

class controlPage extends StatefulWidget {
  const controlPage({
    super.key,
    required HomeController homeController,
  }) : _homeController = homeController;

  final HomeController _homeController;

  @override
  State<controlPage> createState() => _controlPageState();
}

class _controlPageState extends State<controlPage> {
  late bool isChecked;
  Worker? manualWorker;

  @override
  void initState() {
    super.initState();
    isChecked = widget._homeController.manual.value;

    manualWorker = ever(widget._homeController.manual, (bool value) {
      if (mounted) {
        setState(() {
          isChecked = value;
        });
      }
    });
  }

  @override
  void dispose() {
    manualWorker?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 50, bottom: 10, left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Kontrol Manual', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white)),
              SizedBox(height: 20),
              Text('Anda dapat mengatur kondisi aktuator secara manual dengan menekan tombol-tombol yang tersedia dibawah ini!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white)),
            ],
          )
        ),
        // const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 20, left: MediaQuery.of(context).size.width * 0.1, right: MediaQuery.of(context).size.width * 0.1),
          child: Row(
            children: [
              const Spacer(),
              const Text('Mode Manual', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white)),
              const SizedBox(width: 10),
              GFToggle(
                onChanged: (value) {
                  if (mounted) {
                    widget._homeController.manualMode();
                    setState(() {
                      isChecked = !isChecked;
                    });
                  }
                }, 
                value: isChecked,
                type: GFToggleType.ios,
                enabledTrackColor: const Color(0xFF23CD23),
                duration: const Duration(milliseconds: 50),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Row(
            children: [
              GestureDetector(
                // onTap: () {
                //   widget._homeController.switchAirCooler();
                //   setTimer(context, 'assets/images/air_cooler1.png');
                // },
                onTap:() => widget._homeController.switchAirCooler(),
                child: controlButton('assets/images/air_cooler1.png', Colors.green, widget._homeController.airCooler, 'air cooler'),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => widget._homeController.switchMist(),
                child: controlButton('assets/images/mist1.png', Colors.cyan, widget._homeController.mist, 'misting')
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => widget._homeController.switchLamp(),
                child: controlButton('assets/images/lamp1.png', const Color(0xFFC303C7), widget._homeController.uvLamp, 'uv lamp')
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => widget._homeController.switchWatering(),
                child: controlButton('assets/images/watering1.png', Colors.blue, widget._homeController.watering, 'watering')
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ]
    );
  }

  controlButton(String icon, Color onColor, var value, String label) {
    return FrostedGlass(
      width: MediaQuery.of(context).size.width * 0.36,
      height: 250,
      borderRadius: 20,
      color1: Colors.white.withOpacity(0.35),
      color2: Colors.white.withOpacity(0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        children: [
          Obx(() => Image.asset(icon, scale: 1.5, color: value == 2 || value == 4 ? onColor : Colors.grey)),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white))
        ],
      ),
    );
  }

  void setTimer(context, String icon) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 200,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                backgroundColor: const Color(0xFF208D20),
                contentPadding: const EdgeInsets.only(top: 50),
                content: Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    color: Colors.white
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('Durasi yang dibutuhkan :'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2), FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(':', style: TextStyle(fontSize: 46, fontWeight: FontWeight.w700))
                          ),
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2), FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(':', style: TextStyle(fontSize: 46, fontWeight: FontWeight.w700))
                          ),
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2), FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Colors.blueGrey)
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }, 
                            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600))
                          ),
                          const SizedBox(width: 50),
                          ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Color(0xFF23CD23))
                            ),
                            onPressed: () {
                    
                            }, 
                            child: const Text('Set', style: TextStyle(fontWeight: FontWeight.w600))
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 195,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Image.asset(icon, scale: 1.7),
              ),
            ),
          ],
        );
      }
    );
  }
}