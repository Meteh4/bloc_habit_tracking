import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAuthBackground extends StatelessWidget {
  const LottieAuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Lottie.asset('images/Loginani.json',
      fit: BoxFit.cover,
      width: screenWidth,
      height: screenHeight,
    );
  }
}
