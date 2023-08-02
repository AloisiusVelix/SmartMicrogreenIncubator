import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  late TextEditingController usernameController, emailController, passController, repassController;
  var username = '';
  var email = '';
  var password = '';
  var repassword = '';

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passController = TextEditingController();
    repassController = TextEditingController();
  } 

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose(){
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passController.dispose();
    repassController.dispose();
  }

  String? validateUsermane(String value) {
    if (value.isEmpty) {
      return 'Username tidak boleh kosong!';
    }
    else if (value.length < 6) {
      return 'Dibutuhkan minimal 6 karakter!';
    }
    else if (value.contains(' ')) {
      return 'Spasi tidak diperolehkan!';
    }
    else {
      return null;
    }
  }

  // Perlu ditambahkan pengecekan penggunaan email, apakah sudah digunakan atau belum

  
  // Future<String?> checkEmailAvailability(String value) async {
  //   try {
  //     final userList = await FirebaseAuth.instance.fetchSignInMethodsForEmail(value);
  //     if (userList.isEmpty) {
  //       return 'Email tersedia';
  //     }
  //     else {
  //       return null;
  //     }
  //   }
  //   catch (error) {
  //     return 'Tidak dapat memeriksa email';
  //   }
  // }

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

  String? validateRepassword(String value) {
    if (value.isEmpty) {
      return 'Re-password tidak boleh kosong!';
    }
    else if (password.isEmpty) {
      return 'Password wajib diisi dahulu!';
    }
    else if (value != password) {
      return 'Password tidak sama!';
    }
    else {
      return null;
    }
  }

  void checkRegister() {
    final isValid = registerFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    registerFormKey.currentState!.save();
  }

  void signUp(BuildContext context) {
    if (username.isNotEmpty && password.isNotEmpty && email.isNotEmpty && repassword.isNotEmpty){
      //create user
      FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text)
        .then((value) {
          String uid = value.user!.uid;
          FirebaseFirestore.instance.collection('users').doc(uid).set({
            'username' : usernameController.text,
            'email' : emailController.text
          });
        })
        .then((_){
          successCreateUser(context);
          backToLogin();
        })
        .onError((error, stackTrace) {
          errorCreateUser(context);
        });
    }
  }

  void backToLogin() {
    Get.offAllNamed(Routes.LOGIN);
    registerFormKey.currentState!.reset();
  }

  void successCreateUser(BuildContext context) {
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
              Text('Register successfully!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          )
        ),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      )
    );
  }

  void errorCreateUser(BuildContext context) {
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
              Text('Register error!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
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
