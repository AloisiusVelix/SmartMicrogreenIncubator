import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    readPanen();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  final DatabaseReference panenRef = FirebaseDatabase.instance.ref().child('panen');
  RxInt isPanen = 1.obs;
  RxInt harvestDay = 0.obs; 

  void readPanen() {
    panenRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        var panenData = event.snapshot.value as Map<dynamic,dynamic>;
        if (panenData.containsKey('isPanen')) {
          isPanen.value = panenData['isPanen'] as int;
          if (isPanen.value == 1) {
            startTimer();
          }
          else if (isPanen.value == 2) {
            timer?.cancel();
            remainingSeconds.value = 0;
            seconds.value = 0;
            minutes.value = 0;
            hours.value = 0;
            days.value = 0;
          }
        }
        if (panenData.containsKey('lamaPanen')) {
          harvestDay.value = panenData['lamaPanen'] as int;
          
        }
        if (panenData.containsKey('tPanen')) {
          int milliseconds = (panenData['tPanen'] as int) * 1000;
          harvestDate = DateTime.fromMillisecondsSinceEpoch(milliseconds);
        }
      }
    });
  }

  void plusHariPanen() {
    if (harvestDay.value >= 21) {
      harvestDay.value = 21;
    }
    else {
      harvestDay.value = harvestDay.value + 1;
    }
  }

  void minusHariPanen() {
    if (harvestDay.value <= 1) {
      harvestDay.value = 1;
    }
    else {
      harvestDay.value = harvestDay.value - 1;
    }
  }
  
  late SharedPreferences preferences;
  DateTime? harvestDate;
  Timer? timer;
  RxInt remainingSeconds = 0.obs;

  void tanam() {
    DateTime now = DateTime.now();
    harvestDate = now.add(Duration(days: harvestDay.value));
    // JANGAN LUPA GANTI percent: (_timerController.remainingSeconds.value/(_timerController.harvestDay.value * 3600 * 24)),
    startTimer();
    panenRef.update({
      'isPanen' : 1,
      'lamaPanen' : harvestDay.value,
      'tPanen' : (harvestDate?.millisecondsSinceEpoch ?? 0) ~/ 1000
    });
  }

  Future<void> loadHarvestDate() async {
    if (isPanen.value == 1) {
      startTimer();
    }
    else {
      timer?.cancel();
      remainingSeconds.value = 0;
      seconds.value = 0;
      minutes.value = 0;
      hours.value = 0;
      days.value = 0;
    }

    // preferences = await SharedPreferences.getInstance();
    // final String? storedHarvestDate = preferences.getString('harvestDate');

    // if (storedHarvestDate != null) {
    //   harvestDate = DateTime.parse(storedHarvestDate);
    //   startTimer();
    // }
  }

  // Future<void> saveHarvestDate() async {
  //   preferences.setString('harvestDate', harvestDate!.toIso8601String());
  // }

  void panen() {
    timer?.cancel();
    remainingSeconds.value = 0;
    seconds.value = 0;
    minutes.value = 0;
    hours.value = 0;
    days.value = 0;
    panenRef.update({
      'isPanen' : 2,
      'tPanen' : DateTime.now().millisecondsSinceEpoch ~/ 1000,
    });
  }

  RxInt days = 0.obs;
  RxInt hours = 0.obs;
  RxInt minutes = 0.obs;
  RxInt seconds = 0.obs;
  Timer? timerLamp;
  startTimer(){
    timerLamp?.cancel();
    timerLamp = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final DateTime now = DateTime.now();
      if (harvestDate != null) {
        final int difference = harvestDate!.difference(now).inSeconds;
        if (difference >= 0) {
          remainingSeconds.value = difference;
          seconds.value = difference % 60;
          minutes.value = (difference ~/ 60) % 60;
          hours.value = (difference ~/ 3600) % 24;
          days.value = (difference ~/ (3600*24));
        }
        else {
          timer.cancel();
          remainingSeconds.value = 0;
          // showNotification('Saatnya Panen!', 'Waktu panen telah tiba!');
        }
      }
    });
  }

  // RxInt daysLamp = 0.obs;
  // RxInt hoursLamp = 0.obs;
  // RxInt minutesLamp = 0.obs;
  // RxInt secondsLamp = 0.obs;
  // startTimerLamp(){
  //   timer?.cancel();
  //   timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
  //     final DateTime now = DateTime.now();
  //     if (harvestDate != null) {
  //       final int difference = harvestDate!.difference(now).inSeconds;
  //       if (difference >= 0) {
  //         remainingSeconds.value = difference;
  //         secondsLamp.value = difference % 60;
  //         minutesLamp.value = (difference ~/ 60) % 60;
  //         hoursLamp.value = (difference ~/ 3600) % 24;
  //         daysLamp.value = (difference ~/ (3600*24));
  //       }
  //       else {
  //         timer.cancel();
  //         remainingSeconds.value = 0;
  //         // showNotification('Saatnya Panen!', 'Waktu panen telah tiba!');
  //       }
  //     }
  //   });
  // }

  // Future<void> showNotification(String title, String body) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics = 
  //     AndroidNotificationDetails(
  //       'channel_id', 
  //       'channel_name',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       ticker: 'ticker'
  //     );
    
  //   const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //   await flutterLocalNotificationsPlugin.show(
  //     0, 
  //     title, 
  //     body, 
  //     platformChannelSpecifics,
  //     payload: 'payload'
  //   );
  // }

  // Future<void> backgrounfMessageHandler(RemoteMessage message) async {
  //   if (message.notification != null) {
  //     String title = message.notification!.title ?? '';
  //     String body = message.notification!.body ?? '';
  //     await showNotification(title, body);
  //   }
  // }
}