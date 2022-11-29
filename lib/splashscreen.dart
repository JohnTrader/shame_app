import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shame_app/display.dart';
import 'package:shame_app/insert.dart';
import 'package:shame_app/smarthome_ui/src/smart_home_control_page.dart';
import 'package:shame_app/ui/views/login_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(

      splash: Lottie.asset('assets/images/shame_logo.json'),
      splashIconSize: 250,
      backgroundColor: Colors.indigo.shade100,
        pageTransitionType: PageTransitionType.rightToLeftWithFade,

      nextScreen:const loginScreen()
        //nextScreen:const MongoDbInsert()
        //nextScreen:const MongoDbDisplay()
      //nextScreen:const SmartHomeControlPage()
    );
  }
}
