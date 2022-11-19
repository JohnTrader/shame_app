import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shame_app/ui/views/login_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(

      splash: Lottie.asset('assets/shame_logo.json'),
      splashIconSize: 250,
      backgroundColor: Colors.white70,
        pageTransitionType: PageTransitionType.rightToLeftWithFade,

      nextScreen:const loginScreen()
    );
  }
}
