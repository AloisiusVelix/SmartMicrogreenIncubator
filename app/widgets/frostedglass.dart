import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedGlass extends StatelessWidget {
  const FrostedGlass({
    Key? key, 
    required this.width, 
    required this.height, 
    this.child, 
    required this.borderRadius, 
    required this.color1, 
    required this.color2,
  }) : super(key:key);

  final double width;
  final double height;
  final child;
  final double borderRadius;
  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10
              ),
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: LinearGradient(
                  colors: [
                    color1,
                    color2,
                  ]
                )
              ),
            ),
            Center(
              child: child,
            )
          ],
        ),
      ),
    );
  }
}