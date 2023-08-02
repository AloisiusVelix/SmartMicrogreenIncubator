import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:microgreen_app/app/modules/home/controllers/home_controller.dart';
import 'package:microgreen_app/app/modules/home/controllers/timer_controller.dart';
import 'package:microgreen_app/app/modules/home/views/controlPage.dart';
import 'package:microgreen_app/app/modules/home/views/homePage.dart';
import 'package:microgreen_app/app/modules/home/views/setPointPage.dart';
import 'package:microgreen_app/app/widgets/background_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeView extends StatefulWidget {  
  HomeView({super.key});
  final HomeController homeController = Get.put(HomeController());
  static List<Widget> page = <Widget>[
    setPointPage(homeController: Get.put(HomeController())),
    homePage(homeController: Get.put(HomeController()), timerController: Get.put(TimerController())),
    controlPage(homeController: Get.put(HomeController()))  
  ];


  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final items = [
    const ImageIcon(AssetImage('assets/images/settings.png'), size: 30, color: Colors.white),
    const ImageIcon(AssetImage('assets/images/home.png'), size: 30, color: Colors.white),
    const ImageIcon(AssetImage('assets/images/remote.png'), size: 30, color: Colors.white),
  ];
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Stack(
        children: [
          const BackgroundImage(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: HomeView.page.elementAt(selectedIndex),
            bottomNavigationBar: CurvedNavigationBar(
              animationDuration: const Duration(milliseconds: 300),
              index: selectedIndex,
              items: items,
              height: 55,              
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: const Color(0xFF23CD23),
              color: const Color(0xFF208D20),
              onTap: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
