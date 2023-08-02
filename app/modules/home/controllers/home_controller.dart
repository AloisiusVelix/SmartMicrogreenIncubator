import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeController extends GetxController { 
  final GlobalKey<FormState> modeFormKey = GlobalKey<FormState>();
  late TextEditingController modeController;
  String modeName = '';
  bool isReadingSetPoint = true;
  
  @override
  void onInit() {
    super.onInit();
    readMode();
    readDataSensors();
    readActuatorsStatus();
    readAllSetPoint();
    modeController = TextEditingController();
    uploadToken();
    getUserUid();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  final DatabaseReference sensorRef = FirebaseDatabase.instance.ref().child('sensors2');
  RxDouble temperature = RxDouble(0.0);
  RxDouble humidity = RxDouble(0.0);
  RxDouble soilMoisture = RxDouble(0.0);
  RxDouble waterLevel = RxDouble(0.0);
  RxDouble waterPH = RxDouble(0.0);
  RxList allDataDate = RxList([]);
  RxList allDataHumidity = RxList([]);
  RxList allDataLux = RxList([]);
  RxList allDataSoil = RxList([]);
  RxList allDataTemp = RxList([]);
  RxList allDataLevel = RxList([]);
  RxList allDataPh = RxList([]);

  void readDataSensors() {
    sensorRef.onChildAdded.listen((event) {
      int milliseconds = int.parse(event.snapshot.key!) * 1000;
      DateTime sensorDate = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      String formattedTime = DateFormat('dd/MM/yyy\nHH:mm').format(sensorDate);
      allDataDate.add(formattedTime);
      // allDataDate.add(sensorDate.toString().split('.')[0]);
      if (event.snapshot.value != null) {
        var sensorData = event.snapshot.value as Map<dynamic,dynamic>;
        if (sensorData['temperature'] is int) {
          temperature.value = sensorData['temperature'].toDouble() ?? 0.0;
        } else {
          temperature.value = sensorData['temperature'] ?? 0.0;
        }
        allDataTemp.add(temperature.value.toPrecision(2));

        if (sensorData['humidity'] is int) {
          humidity.value = sensorData['humidity'].toDouble() ?? 0.0;
        } else {
          humidity.value = sensorData['humidity'] ?? 0.0;
        }
        allDataHumidity.add(humidity.value.toPrecision(2));

        if (sensorData['soilMoisture'] is int) {
          soilMoisture.value = sensorData['soilMoisture'].toDouble() ?? 0.0;
        } else {
          soilMoisture.value = sensorData['soilMoisture'] ?? 0.0;
        }
        allDataSoil.add(soilMoisture.value.toPrecision(2));

        if (sensorData['waterPH'] is int) {
          waterPH.value = sensorData['waterPH'].toDouble() ?? 0.0;
        } else {
          waterPH.value = sensorData['waterPH'] ?? 0.0;
        }
        allDataPh.add(waterPH.value);

        if (sensorData['waterLevel'] is int) {
          waterLevel.value = sensorData['waterLevel'].toDouble() ?? 0.0;
        } else {
          waterLevel.value = sensorData['waterLevel'] ?? 0.0;
        }
        allDataLevel.add(waterLevel.value);
      
        sensorRef.child(event.snapshot.key.toString()).onValue.listen((childEvent) {
          var sensorData = childEvent.snapshot.value as Map<dynamic,dynamic>;

          if (sensorData['temperature'] is int) {
            temperature.value = sensorData['temperature'].toDouble() ?? 0.0;
          } else {
            temperature.value = sensorData['temperature'] ?? 0.0;
          }
          allDataTemp.replaceRange(allDataTemp.length - 1, allDataTemp.length, [temperature.value]);

          if (sensorData['humidity'] is int) {
            humidity.value = sensorData['humidity'].toDouble() ?? 0.0;
          } else {
            humidity.value = sensorData['humidity'] ?? 0.0;
          }
          allDataHumidity.replaceRange(allDataHumidity.length - 1, allDataHumidity.length, [humidity.value]);

          if (sensorData['soilMoisture'] is int) {
            soilMoisture.value = sensorData['soilMoisture'].toDouble() ?? 0.0;
          } else {
            soilMoisture.value = sensorData['soilMoisture'] ?? 0.0;
          }
          allDataSoil.replaceRange(allDataSoil.length - 1, allDataSoil.length, [soilMoisture.value]);

          if (sensorData['waterPH'] is int) {
            waterPH.value = sensorData['waterPH'].toDouble() ?? 0.0;
          } else {
            waterPH.value = sensorData['waterPH'] ?? 0.0;
          }
          allDataPh.replaceRange(allDataPh.length - 1, allDataPh.length, [waterPH.value]);

          if (sensorData['waterLevel'] is int) {
            waterLevel.value = sensorData['waterLevel'].toDouble() ?? 0.0;
            waterLevel.value = (27 - waterLevel.value) * 22 * 2 * 14 / 1000;
          } else {
            waterLevel.value = sensorData['waterLevel'] ?? 0.0;
            waterLevel.value = (27 - waterLevel.value) * 22 * 2 * 14 / 1000;
          }
          allDataLevel.replaceRange(allDataLevel.length - 1, allDataLevel.length, [waterLevel.value]);
        });
      }
    });
  }

  String statusWaterPH() {
    if (waterPH >= 4.5 && waterPH <=5.0) {
      return 'Good';
    }
    else {
      return 'Bad';
    }
  }

  String statusWaterLevel() {
    if (waterLevel >= 0.75) {
      return 'Full';
    }
    else if (waterLevel >= 0.3 && waterLevel < 0.75) {
      return 'Half';
    }
    else {
      return 'Low';
    }
  }

  final DatabaseReference actuatorRef = FirebaseDatabase.instance.ref().child('actuators');
  RxInt airCooler = RxInt(0);
  RxInt mist = RxInt(0);
  RxInt uvLamp = RxInt(0);
  RxInt watering = RxInt(0);
  final RxBool manual = RxBool(false);
  RxString uvLampStatus = RxString('');
  void readActuatorsStatus () {
    actuatorRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        var actuatorStatus = event.snapshot.value as Map<dynamic,dynamic>;
        if (actuatorStatus.containsKey('statCooler')) {
          airCooler.value = actuatorStatus['statCooler'] ?? 0;
        }
        if (actuatorStatus.containsKey('statMist')) {
          mist.value = actuatorStatus['statMist'] ?? 0;
        }
        if (actuatorStatus.containsKey('statLamp')) {
          uvLamp.value = actuatorStatus['statLamp'] ?? 0;
        }
        if (actuatorStatus.containsKey('statWater')) {
          watering.value = actuatorStatus['statWater'] ?? 0;
        }
        if (actuatorStatus.containsKey('manual')) {
          // manual.value = actuatorStatus['manual'] ?? 0;
          if (actuatorStatus['manual'] == 2) {
            manual.value = true;
          }
          else {
            manual.value = false;
          }
        }
      }
    });
  }

  final DatabaseReference modeRef = FirebaseDatabase.instance.ref();
  RxString selectedSetPoints = RxString('');

  void readMode() {
    modeRef.onValue.listen((event) {
      var modeData = event.snapshot.value as Map<dynamic, dynamic>;
      selectedSetPoints.value = modeData['mode'];
      readSetPoint(selectedSetPoints.value);
    });
  }

  void changeMode(String mode) {
    modeRef.update({
      'mode' : mode
    });
    modeRef.child('set_mikro').set({
      'set_temp' : set_temp.value.toPrecision(1),
      'set_humi' : set_humi.value.toPrecision(1),
      'set_soil' : set_soil.value.toPrecision(1),
      'set_lamp' : set_lamp.value,
    });
  }

  void saveMode() {
    if (modeName.isNotEmpty) {
      setPointRef.child(modeName).set({
        'set_temp' : set_temp.value.toPrecision(1),
        'set_humi' : set_humi.value.toPrecision(1),
        'set_soil' : set_soil.value.toPrecision(1),
        'set_lamp' : set_lamp.value,
      });
      changeMode(modeName);
      modeController.clear();
    }
  }

  Future<void> removeMode(String childRef) async {
    try {
      await setPointRef.child(childRef).remove();
    } catch (e) {
      print('Terjadi kesalahan saat menghapus data: $e');
    }
  }

  void terapkan(String childRef) {
    setPointRef.child(childRef).set({
      'set_temp' : set_temp.value.toPrecision(1),
      'set_humi' : set_humi.value.toPrecision(1),
      'set_soil' : set_soil.value.toPrecision(1),
      'set_lamp' : set_lamp.value,
    });
    modeRef.child('set_mikro').set({
      'set_temp' : set_temp.value.toPrecision(1),
      'set_humi' : set_humi.value.toPrecision(1),
      'set_soil' : set_soil.value.toPrecision(1),
      'set_lamp' : set_lamp.value,
    });
  }

  void successSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical:5),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF23CD23)
          ),
          child: Row(
            children: [
              const Icon(Icons.check, color: Colors.white, size: 20.0),
              const SizedBox(width: 10),
              Text(message, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          )
        ),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      )
    );
  }

  final DatabaseReference setPointRef = FirebaseDatabase.instance.ref().child('set_points');
  RxDouble set_temp = RxDouble(0.0);
  RxDouble set_humi = RxDouble(0.0);
  RxDouble set_soil = RxDouble(0.0);
  RxInt set_lamp = RxInt(0);
  RxList allSetPoint = RxList([]);

  void readAllSetPoint() {
    setPointRef.onChildAdded.listen((event) {
      var setPointKey = event.snapshot.key;
      allSetPoint.add(setPointKey);
    });
    setPointRef.onChildRemoved.listen((event) {
      var setPointKey = event.snapshot.key;
      allSetPoint.remove(setPointKey);
    });
  }

  void readSetPoint(String childRef) {
    if (isReadingSetPoint) {
      setPointRef.child(childRef).onValue.listen((event) {
      if (event.snapshot.value != null) { 
        var setPointData = event.snapshot.value as Map<dynamic, dynamic>;
        if (setPointData['set_temp'] is int) {
          set_temp.value = setPointData['set_temp'].toDouble() ?? 0.0;
        } else {
          set_temp.value = setPointData['set_temp'] ?? 0.0;
        }

        if (setPointData['set_humi'] is int) {
          set_humi.value = setPointData['set_humi'].toDouble() ?? 0.0;
        } else {
          set_humi.value = setPointData['set_humi'] ?? 0.0;
        }
        
        if (setPointData['set_soil'] is int) {
          set_soil.value = setPointData['set_soil'].toDouble() ?? 0.0;
        } else {
          set_soil.value = setPointData['set_soil'] ?? 0.0;
        }

        if (setPointData['set_lamp'] is int) {
          set_lamp.value = setPointData['set_lamp'] ?? 0;
        } else {
          set_lamp.value = setPointData['set_lamp'] ?? 0;
        }
      }
    });
    }
  }

  void plusTemp () {
    isReadingSetPoint == false;
    set_temp.value = set_temp.value + 0.5;
    isReadingSetPoint == true;
  }
  void plusHumi () {
    isReadingSetPoint == false;
    set_humi.value = set_humi.value + 0.5;
    isReadingSetPoint == true;
  }
  void plusSoil () {
    isReadingSetPoint == false;
    set_soil.value = set_soil.value + 0.5;
    isReadingSetPoint == true;
  }
  void plusLamp () {
    isReadingSetPoint == false;
    if (set_lamp.value >= 24) {
      set_lamp.value = 24;
    }
    else {
      set_lamp.value = set_lamp.value + 1;
    }
    isReadingSetPoint == true;
  }

  void minusTemp () {
    isReadingSetPoint == false;
    set_temp.value = set_temp.value - 0.5;
    isReadingSetPoint == true;
  }
  void minusHumi () {
    isReadingSetPoint == false;
    set_humi.value = set_humi.value - 0.5;
    isReadingSetPoint == true;
  }
  void minusSoil () {
    isReadingSetPoint == false;
    set_soil.value = set_soil.value - 0.5;
    isReadingSetPoint == true;
  }
  void minusLamp () {
    isReadingSetPoint == false;
    if (set_lamp.value <= 0) {
      set_lamp.value = 0;
    }
    else {
      set_lamp.value = set_lamp.value - 1;
    }
    isReadingSetPoint == true;
  }

  void manualMode() async {
    if (manual.value) {
      actuatorRef.update({
        'manual' : 1
      });
    }
    else {
      actuatorRef.update({
        'manual' : 2,
      });
    }
  }

  void switchActuators(var act, String keyData) {
    if (manual.value) {
      if (act.value == 1) {
        act.value = 2; // Nyala manual
        actuatorRef.update({
          keyData : act.value
        });
      }
      else if (act.value == 2) {
        act.value = 1; // Mati manual
        actuatorRef.update({
          keyData : act.value
        });
      }
    }
  }

  RxString username = ('').obs;
  void getUserUid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      FirebaseFirestore.instance.collection('users').doc(uid).get().then((querySnapshot) {
        if (querySnapshot.exists) {
          Map<String, dynamic> data = querySnapshot.data() as Map<String, dynamic>;
          username.value = data['username'];
        } else {
          print('Tidak ada data pengguna dengan UID tersebut.');
        }
      }).catchError((error) {
        print('Terjadi kesalahan saat mengambil data: $error');
      });
    } else {
      print('Tidak ada pengguna yang login.');
    }
  }

  void getDataFromFirestore() {
  FirebaseFirestore.instance.collection('users').get().then((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      // Jika ada dokumen di dalam koleksi 'users'
      querySnapshot.docs.forEach((doc) {
        // Mendapatkan data nama dari dokumen
        String username = doc['username']; // Sesuaikan field 'username' dengan field di dokumen Anda
        print('Nama: $username');
      });
    } else {
      print('Tidak ada data pengguna di Firestore.');
    }
  }).catchError((error) {
    print('Terjadi kesalahan saat mengambil data: $error');
  });
}

  void switchAirCooler() {
    switchActuators(airCooler, 'statCooler');
  }

  void switchMist() {
    switchActuators(mist, 'statMist');
  }

  void switchWatering() {
    switchActuators(watering, 'statWater');
  }

  void switchLamp() {
    switchActuators(uvLamp, 'statLamp');
  }

  String? validateMode(String value) {
    if (value.isEmpty) {
      return 'Nama mode harus diisi!';
    }
    else if (value.contains(' ')) {
      return 'Spasi tidak diperbolehkan!';
    }
    else {
      return null;
    }
  }

  void checkMode() {
    final isValid = modeFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    modeFormKey.currentState!.save();
  }

  final DatabaseReference tokenRef = FirebaseDatabase.instance.ref().child('token');
  void uploadToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    tokenRef.once().then((event) {
      if (event.snapshot.value != null) {
        var tokenData = event.snapshot.value as Map<dynamic,dynamic>;
        if (!tokenData.values.contains(token)) {
          int numberToken = tokenData.length;
          tokenRef.child('device$numberToken').set(token);
          tokenRef.child('count').set(numberToken);
        }
        else {
          print('token already registered');
        }
      }
      else {
        tokenRef.set({
          'device1' : token,
          'count' : 1
        });
      }
    });
  }

  // Future<void> sendDelayedNotification() async {
  //   String serverKey = 'AAAAfMHw1VY:APA91bHrMWJoG28bzWq48X5gk-Ami5kpCX3nl_NqbRsUzfwWD-oJEspEWMECAiZdHBvIwvoaml3To6rceXMqT0BJlv-8X6digd1VJy9ECQGHe6EUqNC7IcLrcGbx192-F1SQbkDppwoN'; // Ganti dengan Server Key Firebase Anda
  //   String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

  //   String deviceToken = 'cUiMa2fOQeiEh-ynZmSTyi:APA91bGEiSoeYdqZyKSnNFom-7D64RAe0R4K_Fe-L1bpPNGqj150vCNXFR44LvQlT5XyW_39DfHBZrTOgfe7Ek_ry56eDtV7h2SW-Tre6b4Xoa8XfKSQX4uUPTFjrkjrSuy8If7c1Eoq'; // Ganti dengan token perangkat penerima notifikasi

  //   DateTime now = DateTime.now();
  //   DateTime delayedTime = now.add(Duration(seconds: 30));
  //   print(delayedTime.millisecondsSinceEpoch);

  //   // Payload notifikasi
  //   Map<String, dynamic> notificationPayload = {
  //     'to': deviceToken,
  //     'notification': {
  //       'title': 'Notifikasi Terjadwal',
  //       'body': 'Ini adalah notifikasi terjadwal setelah 8 jam.',
  //     },
  //     // 'android': {
  //     //   'ttl': delayedTime.millisecondsSinceEpoch, // TTL dalam detik
  //     // },
  //     'apns': {
  //       'headers': {
  //         'apns-priority': '5', // Prioritas notifikasi (0-5, dengan 5 tertinggi)
  //       },
  //     },
  //   };

  //   // Mengirim permintaan HTTP ke FCM API
  //   http.Response response = await http.post(
  //     Uri.parse(fcmEndpoint),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'key=$serverKey',
  //     },
  //     body: jsonEncode(notificationPayload),
  //   );

  //   if (response.statusCode == 200) {
  //     print('Notifikasi terjadwal berhasil dikirim');
  //   } else {
  //     print('Terjadi kesalahan dalam mengirim notifikasi terjadwal: ${response.body}');
  //   }
  // }
}