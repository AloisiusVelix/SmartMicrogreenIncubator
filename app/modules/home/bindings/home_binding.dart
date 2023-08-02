import 'package:get/get.dart';

import 'package:microgreen_app/app/modules/home/controllers/timer_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<TimerController>(
      () => TimerController(),
    );
  }
}
