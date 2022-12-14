import 'package:flutter/material.dart';
import 'package:shame_app/ui/views/home_page.dart';
import 'package:shame_app/ui/views/temperature.dart';
import '../../display.dart';
import '../../show_graph.dart';
import '../../smarthome_ui/src/smart_home_control_page.dart';
//import 'package:dart_amqp/dart_amqp.dart';
//import '../../radial_progress.dart';



class HomePage extends StatefulWidget {

  String user;
  String pass;
  String vhost;

  HomePage({required this.user, required this.pass, required this.vhost});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late String payload;
  bool rmq_status = false;
  bool check_status = false;

  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  const Text(
                    'Hi...',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.indigo,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  const RotatedBox(
                    quarterTurns: 135,
                    child: Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.indigo,
                      size: 28,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    //payload,
                    //"TMDG2022",
                    widget.user,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 32),
                    Center(
                      child: Image.asset(
                        'assets/images/banner.png',
                        scale: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Welcome to SHA.ME',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    const Text(
                      'SERVICES',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _cardMenu(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(user: widget.user,pass: widget.pass,vhost: widget.vhost,),
                                //builder: (context) => MyHomePage(payload:payload),
                              ),
                            );
                          },
                          icon: 'assets/images/energy.png',
                          title: 'ENERGY',
                          color: Colors.orangeAccent,
                          fontColor: Colors.black54,
                        ),
                        _cardMenu(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                //builder: (context) => const TemperaturePage(),
                                builder: (context) => const SmartHomeControlPage(),
                              ),
                            );
                          },
                          icon: 'assets/images/temperature.png',
                          title: 'CONTROL',
                          color: Colors.blueAccent,
                          fontColor: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _cardMenu(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MongoDbDisplay(),
                              ),
                            );
                          },
                          icon: 'assets/images/water.png',
                          title: 'DATA LOG',
                          color: Colors.purpleAccent,
                          fontColor: Colors.white,
                        ),
                        _cardMenu(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowGraph(),
                              ),
                            );
                          },
                          icon: 'assets/images/entertainment.png',
                          title: 'GRAPH',
                          color: Colors.lightGreen,
                          fontColor: Colors.black54,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardMenu({
    required String title,
    required String icon,
    VoidCallback? onTap,
    Color color = Colors.white,
    Color fontColor = Colors.grey,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 36,
        ),
        width: 156,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Image.asset(icon),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: fontColor),
            )
          ],
        ),
      ),
    );
  }
}
