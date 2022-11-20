import 'package:flutter/material.dart';
import 'package:shame_app/ui/views/home_page.dart';
import 'package:shame_app/ui/views/temperature.dart';
import 'package:dart_amqp/dart_amqp.dart';


class HomePage extends StatefulWidget {

  String user;
  String pass;
  String vhost;

  HomePage({required this.user, required this.pass, required this.vhost});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String payload = "";
  //late Client client;
  bool rmq_status = false;
  bool check_status = false;

  @override
  void initState() {
    //client = Client();
    super.initState();
    connect();
  }

  void connect() {
    try {

      ConnectionSettings settings = new ConnectionSettings(
        host: 'rmq2.pptik.id',
        authProvider: new PlainAuthenticator(widget.user, widget.pass),
        virtualHost: widget.vhost,
      );

      Client client = Client(settings: settings);

      client.errorListener((error) {print("dsa${error.toString()}"); });
      client.connect().catchError((Object error){
        print("dsa ${error.toString()}");
        setState(() {
          rmq_status = false;
        });
      });
      client.connect().then((value){
        setState(() {
          print("Connected to AMQP");
          rmq_status = true;
        });
      });

      client
          .channel()
          .then((Channel channel) => channel.queue("Sensor_PZEM004T", durable: true))
          .then((Queue queue) => queue.consume())
          .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
        print("[x] Received ${message.payloadAsString}");
        print("Received Data...");
        //setValuePompa(message.payloadAsString);
        setState(() {
          payload = message.payloadAsString;

        });
      }));
      print("Received Data...");
    } on Exception catch (e) {
      print("[x]Received False ${e.toString()}");
    }
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
                children: const [
                  Text(
                    'HI TMDG2022...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 135,
                    child: Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.indigo,
                      size: 28,
                    ),
                  )
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
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    const Text(
                      'SERVICES',
                      style: TextStyle(
                        fontSize: 18,
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
                                builder: (context) => MyHomePage(),
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
                                builder: (context) => const TemperaturePage(),
                              ),
                            );
                          },
                          icon: 'assets/images/temperature.png',
                          title: 'TEMPERATURE',
                          color: Colors.indigoAccent,
                          fontColor: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _cardMenu(
                          icon: 'assets/images/water.png',
                          title: 'WATER',
                          color: Colors.purpleAccent,
                          fontColor: Colors.white,
                        ),
                        _cardMenu(
                          icon: 'assets/images/entertainment.png',
                          title: 'ENTERTAINMENT',
                          color: Colors.greenAccent,
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
