import 'package:flutter/material.dart';
import 'package:shame_app/themes/colors.dart';
import 'package:shame_app/splashscreen.dart';
//import 'package:shame_app/ui/views/home_page.dart';
//import 'package:shame_app/ui/views/home_view.dart';
//import 'package:shame_app/ui/views/login_view.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shame App',
      theme: appTheme,

      //home: HomeView(user: 'TMDG2022',pass: 'TMDG2022',vhost: '/TMDG2022'),
      //home: const loginScreen(),
      //home: MyHomePage(),
      home: SplashScreen(),
    );
  }
}



