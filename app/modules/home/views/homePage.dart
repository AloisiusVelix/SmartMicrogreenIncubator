import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:microgreen_app/app/modules/home/controllers/timer_controller.dart';
import 'package:microgreen_app/app/modules/home/views/chartPart.dart';
import 'package:microgreen_app/app/modules/home/views/tablePart.dart';
import 'package:microgreen_app/app/widgets/frostedglass.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../controllers/home_controller.dart';
import 'monitoringPart.dart';

class homePage extends StatelessWidget {
  const homePage({
    Key? key,
    required HomeController homeController,
    required TimerController timerController,
  }) : _homeController = homeController, _timerController = timerController, super(key: key); 

  final HomeController _homeController;
  final TimerController _timerController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text('Hello ${_homeController.username.value}', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400))),
                  const Text('Welcome back!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GestureDetector(
                  onTap: () => Get.to(() => tablePage(homeController: _homeController)),
                  child: FrostedGlass(
                    width: 50,
                    height: 50,
                    borderRadius: 60,
                    color1: Colors.white.withOpacity(0.25),
                    color2: Colors.white.withOpacity(0.1),
                    child: const ImageIcon(AssetImage('assets/images/book.png'), size: 25, color: Colors.white)
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GestureDetector(
                  onTap: () => Get.to(() => chartPage(homeController: _homeController)),
                  child: FrostedGlass(
                    width: 50,
                    height: 50,
                    borderRadius: 60,
                    color1: Colors.white.withOpacity(0.25),
                    color2: Colors.white.withOpacity(0.1),
                    child: const ImageIcon(AssetImage('assets/images/chart.png'), size: 25, color: Colors.white)
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              if (_timerController.isPanen.value == 2) {
                siapTanam(context);
              }
              else {
                panenTanam(context);
              }
            },
            child: FrostedGlass(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 130,
              borderRadius: 20,
              color1: Colors.white.withOpacity(0.25),
              color2: Colors.white.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Smart Microgreen\nIncubator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                      const SizedBox(height: 20),
                      const Text('panen dalam :', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.white)),
                      Obx(() {
                        if (_timerController.remainingSeconds.value == 0 && _timerController.isPanen.value == 1) {
                          return const Text('Siap dipanen!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white));
                        }
                        else if (_timerController.remainingSeconds.value == 0 && _timerController.isPanen.value == 2) {
                          return const Text('Sedang dipanen!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white));
                        }
                        else {
                          return timerOn();
                        }
                      })
                    ],
                  ),
                  const Spacer(),
                  Obx(() => 
                    CircularPercentIndicator(
                      radius: 50,
                      lineWidth: 10,
                      percent: (_timerController.remainingSeconds.value/(_timerController.harvestDay.value * 3600 * 24)),
                      progressColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      backgroundWidth: 8,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: 
                        Text.rich(TextSpan(
                          children: [
                            TextSpan(
                              text: (_timerController.remainingSeconds.value ~/ (3600*24)).toString(), style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600)
                            ),
                            TextSpan(
                              text: '\n/${_timerController.harvestDay.value} hari', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400)
                            )
                          ]
                        ),
                        textAlign: TextAlign.center,
                      )
                    ),
                  ),
                  const SizedBox(width: 25)
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: monitoringPart(homeController: _homeController),
        ),
      ],
    );
  }

  Row timerOn() {
    return Row(
      children: [
        Obx(() => Text(_timerController.days.value.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white))),
        const Text(' hari ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white)),
        Obx(() => Text('${_timerController.hours.value.toString().padLeft(2, '0')}:${_timerController.minutes.value.toString().padLeft(2, '0')}:${_timerController.seconds.value.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white))),
      ],
    );
  }

  Future<dynamic> siapTanam(BuildContext context) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          backgroundColor: const Color(0xFFD9D9D9),
          title: const Center(child: Text('Sudah Siap Menanam?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          titlePadding: const EdgeInsets.all(15),
          contentPadding: const EdgeInsets.only(top: 0),
          content: Container(
            height: 140,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Jika sudah siap menanam, silahkan tentukan berapa hari lagi tanaman siap untuk dipanen', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap:() => _timerController.minusHariPanen(),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset('assets/images/minus.png', scale: 0.35,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Obx(() => Text(_timerController.harvestDay.value.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500))),
                      ),
                      GestureDetector(
                        onTap:() => _timerController.plusHariPanen(),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset('assets/images/plus.png', scale: 0.35,),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('hari', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300))
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red)
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('BATAL')
            ),
            const SizedBox(width: 40),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFF208D20))
              ),
              onPressed: () {
                _timerController.tanam();
                Navigator.pop(context);
              },
              child: const Text('TANAM')
            )
          ],
        );
      }
    );
  }

  Future<dynamic> panenTanam(BuildContext context) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          backgroundColor: const Color(0xFFD9D9D9),
          title: const Center(child: Text('Panen Sekarang?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          titlePadding: const EdgeInsets.all(15),
          contentPadding: const EdgeInsets.only(top: 0),
          content: Container(
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text('Apakah anda yakin ingin memanen tanaman anda sekarang?', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red)
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('BATAL')
            ),
            const SizedBox(width: 40),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFF208D20))
              ),
              onPressed: () {
                _timerController.panen();
                Navigator.pop(context);
              },
              child: const Text('PANEN')
            )
          ],
        );
      }
    );
  }
}