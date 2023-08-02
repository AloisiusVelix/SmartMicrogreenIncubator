import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.black,Colors.black12],
        begin: Alignment.bottomCenter,
        end: Alignment.center
      ).createShader(bounds), 
      blendMode: BlendMode.darken,
      child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_microgreen.jpg'), 
              fit: BoxFit.cover, 
              colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken))
          ),
      ),
    );
  }
}