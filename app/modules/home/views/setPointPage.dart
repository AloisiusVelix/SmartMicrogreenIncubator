import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:microgreen_app/app/widgets/frostedglass.dart';

import '../controllers/home_controller.dart';

class setPointPage extends StatelessWidget {
  const setPointPage({
    super.key,
    required HomeController homeController,
  }) : _homeController = homeController;

  final HomeController _homeController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 50),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Setting Point', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white)),
              SizedBox(height: 20),
              Text('Anda dapat mengatur parameter suhu, kelembapan udara, kelembapan tanah dan lama penyinaran sesuai kebutuhan anda!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.white)),
            ],
          )
        ),
        const SizedBox(height: 30),
        Center(
          child: FrostedGlass(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 80, 
            borderRadius: 20, 
            color1: Colors.white.withOpacity(0.1),
            color2: Colors.white.withOpacity(0.25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Mode yang digunakan :', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400)),
                      Obx(() => Text(_homeController.selectedSetPoints.value, style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600)))
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => listSetPoint(context),
                    child: const Icon(Icons.menu_rounded, size: 35, color: Colors.white, weight: 3)
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: FrostedGlass(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 500,
            borderRadius: 20,
            color1: Colors.white.withOpacity(0.25),
            color2: Colors.white.withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('Temperature (C)', style: TextStyle(fontSize: 12, color: Colors.white)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    plusMinusButton('assets/images/minus.png', _homeController.minusTemp),
                    const SizedBox(width: 20),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 3)
                          )
                        ],
                      ),
                      child: Center(child: Obx(() => Text(_homeController.set_temp.value.toStringAsFixed(1), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)))),
                    ),
                    const SizedBox(width: 20),
                    plusMinusButton('assets/images/plus.png', _homeController.plusTemp)
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 8),
                  child: Text('Kelembapan Udara (%)', style: TextStyle(fontSize: 12, color: Colors.white)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    plusMinusButton('assets/images/minus.png', _homeController.minusHumi),
                    const SizedBox(width: 20),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 3)
                          )
                        ],
                      ),
                      child: Center(child: Obx(() => Text(_homeController.set_humi.value.toStringAsFixed(1), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)))),
                    ),
                    const SizedBox(width: 20),
                    plusMinusButton('assets/images/plus.png', _homeController.plusHumi),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 8),
                  child: Text('Kelembapan Tanah (%)', style: TextStyle(fontSize: 12, color: Colors.white)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    plusMinusButton('assets/images/minus.png', _homeController.minusSoil),
                    const SizedBox(width: 20),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 3)
                          )
                        ],
                      ),
                      child: Center(child: Obx(() => Text(_homeController.set_soil.value.toStringAsFixed(1), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)))),
                    ),
                    const SizedBox(width: 20),
                    plusMinusButton('assets/images/plus.png', _homeController.plusSoil),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 8),
                  child: Text('Nyala Lampu (jam)', style: TextStyle(fontSize: 12, color: Colors.white)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    plusMinusButton('assets/images/minus.png', _homeController.minusLamp),
                    const SizedBox(width: 20),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 3)
                          )
                        ],
                      ),
                      child: Center(child: Obx(() => Text(_homeController.set_lamp.value.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)))),
                    ),
                    const SizedBox(width: 20),
                    plusMinusButton('assets/images/plus.png', _homeController.plusLamp),
                  ],
                ),
                const SizedBox(height: 60),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap:() => _homeController.readMode(),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 3)
                            )
                          ],
                        ),
                        child: const Icon(Icons.refresh, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        _homeController.terapkan(_homeController.selectedSetPoints.value);
                        _homeController.successSnackBar(context, 'Berhasil menerapkan mode!');
                      },
                      child: Container(
                        height: 40,
                        width: 190,
                        decoration: BoxDecoration(
                          color: const Color(0xFF208D20),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 3)
                            )
                          ],
                        ),
                        child: const Center(child: Text('TERAPKAN', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => saveSetPoint(context),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 3)
                            )
                          ],
                        ),
                        child: const Icon(Icons.save, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> saveSetPoint(BuildContext context) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          backgroundColor: const Color(0xFFD9D9D9),
          title: const Center(child: Text('Simpan Set Point', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          titlePadding: const EdgeInsets.all(15),
          contentPadding: const EdgeInsets.only(bottom: 0),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 140,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Silahkan massukkan nama mode untuk menyimpan parameter yang telah diatur!', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: TextFormField(
                    key: _homeController.modeFormKey,
                    textAlign: TextAlign.center,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.name,
                    controller: _homeController.modeController,
                    onChanged: (value) {
                      _homeController.modeName = value;
                    },
                    validator : (value) => _homeController.validateMode(value!),
                    decoration: const InputDecoration(
                      errorStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                  ),
                )
              ],
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
                _homeController.saveMode();
                _homeController.successSnackBar(context, 'Berhasil menyimpan dan menerapkan mode!');
                Navigator.pop(context);
              },
              child: const Text('SIMPAN')
            )
          ],
        );
      },
    );
  }

  Future<dynamic> listSetPoint(BuildContext context) {
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10) 
          ),
          backgroundColor: const Color(0xFFD9D9D9),
          title: const Center(child: Text('Mode Set Point', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          titlePadding: const EdgeInsets.all(15),
          contentPadding: const EdgeInsets.only(bottom: 0),
          content: Container(
            height: 260,
            width: MediaQuery.of(context).size.width * 0.85,
            color: Colors.white,
            child: Obx(() =>
              ListView.builder(
                itemCount: _homeController.allSetPoint.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: GestureDetector(
                        onLongPress: () {
                          if (_homeController.selectedSetPoints.value != _homeController.allSetPoint[index]) {
                            _homeController.removeMode(_homeController.allSetPoint[index]);
                          }
                        },
                        onTap:() {
                          _homeController.changeMode(_homeController.allSetPoint[index]);
                          Navigator.pop(context);
                        },
                        child: Obx(() =>
                          Container(
                            width: MediaQuery.of(context).size.width * 0.55,
                            height: 35,
                            decoration: BoxDecoration(
                              color: _homeController.selectedSetPoints.value == _homeController.allSetPoint[index] ? const Color(0xFF208D20) : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 0.5,
                                blurRadius: 2,
                                offset: const Offset(0,1)
                              )]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(_homeController.allSetPoint[index], 
                                textAlign: TextAlign.center, 
                                style: TextStyle(fontSize: 14, color: _homeController.selectedSetPoints.value == _homeController.allSetPoint[index] ? Colors.white : Colors.black, fontWeight: FontWeight.w400)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
          ),
          actions: const [
            Text('* Tekan tahan untuk menghapus mode yang tidak dibutuhkan', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300))
          ],
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.symmetric(vertical: 15),
        );
      }
    );
  }

  Container plusMinusButton(String icon, var toDo) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3)
          )
        ],
      ),
      child: GestureDetector(
        onTap: () => toDo(),
        child: Image.asset(icon)
      )
    );
  }
}