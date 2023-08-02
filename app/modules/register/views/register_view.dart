import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:microgreen_app/app/modules/register/controllers/register_controller.dart';
import 'package:microgreen_app/app/routes/app_pages.dart';
import 'package:microgreen_app/app/widgets/background_image.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterController _registerController = Get.put(RegisterController());
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1, bottom: 30),
                      child: Image.asset('assets/images/logo_microgreen.png'),
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
                          key: _registerController.registerFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    'Username', 
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: _registerController.usernameController,
                                onSaved: (value) {
                                  _registerController.username = value!;
                                },
                                validator: (value) => _registerController.validateUsermane(value!),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                                  hintText: 'Masukkan username anda',
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
                                    'Email', 
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: _registerController.emailController,
                                onSaved: (value) {
                                  _registerController.email = value!;
                                },
                                validator: (value) => _registerController.validateEmail(value!),
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
                                controller: _registerController.passController,
                                onChanged: (value) {
                                  _registerController.password = value;
                                },
                                validator: (value) => _registerController.validatePassword(value!),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed:passVisibility, icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.grey,)),
                                  errorStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                                  hintText: 'Masukkan password anda',
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
                                    'Konfirmasi Password', 
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              TextFormField(
                                obscureText: _obscureText,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                onSaved: (value) {
                                  _registerController.repassword = value!;
                                },
                                validator: (value) => _registerController.validateRepassword(value!),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed:passVisibility, icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.grey,)),
                                  errorStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                                  hintText: 'Masukkan kembali password anda',
                                  hintStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                                  fillColor: const Color(0xFFD9D9D9),
                                  filled: true,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12)
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll<Color>(Color(0xFF23CD23)),
                                minimumSize:MaterialStatePropertyAll<Size>(Size(120, 40)),
                                textStyle:MaterialStatePropertyAll<TextStyle>(TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
                                onPressed: () {
                                  _registerController.checkRegister();
                                  _registerController.signUp(context);
                                },
                                child: const Text('REGISTER')
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Sudah punya akun?', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
                                  const SizedBox(width: 2),
                                  InkWell(
                                    onTap: () {
                                      _registerController.backToLogin();
                                    },
                                    child: const Text('Login disini!', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Color(0xFF17B1A8), decoration: TextDecoration.underline))
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}