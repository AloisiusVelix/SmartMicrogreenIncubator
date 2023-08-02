import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();  

  late TextEditingController emailController, passController;
  var email = '';
  var password = '';

  @override
  void onInit() {
    super.onInit();
    loadSavedData();
    emailController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose(){
    super.dispose();
    // emailController.dispose();
    // passController.dispose();
  }

  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return 'Email tidak valid!';
    }
    else {
      return null;
    }
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password tidak boleh kosong!';
    }
    else if (value.length < 8) {
      return 'Dibutuhkan minimal 8 karakter!';
    }    
    else {
      return null;
    }
  }

  late SharedPreferences preferences;
  final RxBool rememberMe = false.obs;

  void loadSavedData() async {
    preferences = await SharedPreferences.getInstance();
    final storedRememberMe = preferences.getBool('storedRememberMe') ?? false;
    if (storedRememberMe == true) {
      emailController.text = preferences.getString('email') ?? '';
      passController.text = preferences.getString('pass') ?? '';
      rememberMe.value = true;
    }
    else {
      rememberMe.value = false;
    }
  }

  void saveData(bool value) async {
    rememberMe.value = value;
    preferences.setString('email', emailController.text);
    preferences.setString('pass', passController.text);
    preferences.setBool('storedRememberMe', value);
  }

  void checkLogin() {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    loginFormKey.currentState!.save();
  }

  void signIn(BuildContext context) {
    if (emailController.text.isNotEmpty && passController.text.isNotEmpty){
      FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: emailController.text,
          password: passController.text)
        .then((value) {
          successSignIn(context);
          toHome();
        })
        .onError((error, stackTrace) {
          errorSignIn(context);
        });
    }
  }

  void toHome() {
    Get.offAllNamed(Routes.HOME);
    // Get.toNamed(Routes.HOME);
    loginFormKey.currentState!.reset();
  }

  void successSignIn(BuildContext context) {
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
            children: const [
              Icon(Icons.check, color: Colors.white, size: 20.0),
              SizedBox(width: 10),
              Text('Login successfully!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          )
        ),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      )
    );
  }

  void errorSignIn(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical:5),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFCD0000)
          ),
          child: Row(
            children: const [
              Icon(Icons.close_rounded, color: Colors.white, size: 20.0),
              SizedBox(width: 10),
              Text('Email atau Password salah!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          )
        ),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      )
    );
  }

  
}