import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:microgreen_app/app/routes/app_pages.dart';
import 'package:microgreen_app/app/widgets/background_image.dart';
import 'package:microgreen_app/app/widgets/checkbox.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _loginController = Get.put(LoginController());
  late bool _obscureText = true;
  
  void passVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const BackgroundImage(),
          Positioned(
            bottom: 31,
            child: Image.asset('assets/images/developed_by.png')
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.125, bottom: 30),
                      child: Image.asset('assets/images/logo_login.png'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                        child: Form(
                          key: _loginController.loginFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      'Email', 
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: _loginController.emailController,
                                  onSaved: (value) {
                                    _loginController.email = value!;
                                  },
                                  validator: (value) => _loginController.validateEmail(value!),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                                    hintText: 'Masukkan email anda',
                                    hintStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                                    fillColor: const Color(0xFFD9D9D9),
                                    filled: true,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12)
                                  ),
                                ),
                              const SizedBox(height: 20),
                              SizedBox(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      'Password', 
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  obscureText: _obscureText,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: _loginController.passController,
                                  onChanged: (value) {
                                    _loginController.password = value;
                                  },
                                  validator: (value) => _loginController.validatePassword(value!),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: passVisibility, icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.grey,)),
                                    errorStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                                    hintText: 'Masukkan password anda',
                                    hintStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                                    fillColor: const Color(0xFFD9D9D9),
                                    filled: true,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12)
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  CustomCheckbox(loginController: _loginController),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'Ingat saya?',
                                    style: TextStyle(fontSize: 10)
                                  ),
                                  const Spacer(),
                                  // InkWell(
                                  //   onTap: () {
                                      
                                  //   },
                                  //   child: const Text('Lupa Password?', style: TextStyle(fontSize: 10, color: Color(0xFF17B1A8), decoration: TextDecoration.underline))
                                  // )
                                ],
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<Color>(Color(0xFF23CD23)),
                                  minimumSize:MaterialStatePropertyAll<Size>(Size(120, 40)),
                                  textStyle:MaterialStatePropertyAll<TextStyle>(TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))
                                ),
                                onPressed: () {
                                  _loginController.checkLogin();
                                  _loginController.signIn(context);
                                },
                                  child: const Text('LOGIN')
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Belum punya akun?', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                                  const SizedBox(width: 2),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.REGISTER);
                                    },
                                    child: const Text('Daftar disini!', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Color(0xFF17B1A8), decoration: TextDecoration.underline))
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}
