import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:microgreen_app/app/modules/login/controllers/login_controller.dart';

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    super.key,
    required LoginController loginController,
  }) : _loginController = loginController;

  final LoginController _loginController;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool isChecked;
  @override
  void initState() {
    super.initState();
    isChecked = widget._loginController.rememberMe.value;
    
    ever(widget._loginController.rememberMe, (bool value) {
      setState(() {
        isChecked = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isChecked = !isChecked;
          widget._loginController.saveData(isChecked);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isChecked ? const Color(0xFF23CD23) : Colors.transparent,
          borderRadius: BorderRadius.circular(3),
          border: isChecked ? null : Border.all(color: const Color(0xFFABABAB), width: 1.5)
        ),
        width: 12,
        height: 12,
        child: isChecked ? const Icon(Icons.check, size: 12, color: Colors.white,) : null,
      ),
    );
  }
}