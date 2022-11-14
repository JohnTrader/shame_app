import 'dart:async';
import 'package:shame_app/ui/views/home_page.dart';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:shame_app/services/rmq_service.dart';
import 'package:shame_app/ui/model/value_model.dart';
import 'package:shame_app/ui/widget/card_view.dart';

class HomeView extends StatefulWidget {
  String user;
  String pass;
  String vhost;

  HomeView({required this.user, required this.pass, required this.vhost});
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  RMQService rmqService = RMQService();
  String payload = "";
  late Client client;
  String soil_serial = "";
  String soil_value = "";
  String soil_status = "";
  bool check_status = false;
  //String pompa_serial = "";
  //String pompa_value = "";

  List<ValueModel> device = [];
  void connect() {
    try {
      ConnectionSettings settings = ConnectionSettings(
        host: 'rmq2.pptik.id',
        authProvider: PlainAuthenticator(widget.user, widget.pass),
        virtualHost: widget.vhost,
      );
      client = Client(settings: settings);

      client.connect().then((value) {
        setState(() {
          check_status = true;
          //MyHomePage();
          //data();
          //data_pompa();
        });
      });
    } catch (e) {
      print("kesalahan 344or $e");
    }
  }
/*
  void data() {
    client
        .channel()
        .then((Channel channel) => channel.queue("Sensor_PZEM004T", durable: true))
        .then((Queue queue) => queue.consume())
        .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
      print("test ${message.payloadAsString}");
      //setValueSoil(message.payloadAsString);
      setState(() {
        payload = message.payloadAsString;
      });
    }));
  } */
/*
  void data_pompa() {
    client
        .channel()
        .then((Channel channel) => channel.queue("Aktuator", durable: true))
        .then((Queue queue) => queue.consume())
        .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
      print("test ${message.payloadAsString}");
      setValuePompa(message.payloadAsString);
    }));
  }

  void setValuePompa(String message) {
    List<String> list = message.split("#");
    int cek_value = int.parse(list[1]);
    setState(() {
      pompa_serial = list[0];
      if (cek_value == 1) {
        pompa_value = 'ON';
      } else if (cek_value == 0) {
        pompa_value = 'OFF';
      }
      device.add(
          ValueModel(pompa_serial, "POMPA", cek_value.toString(), pompa_value));
    });
  }

  void setValueSoil(String message) {
    List<String> a = message.split("#");
    int cek = int.parse(a[1]);
    setState(() {
      soil_value = a[1];
      soil_serial = a[0];
      if (cek < 350) {
        soil_status = 'lembab';
      } else if (cek > 700) {
        soil_status = 'Kering';
      } else if (cek >= 350 && cek <= 700) {
        soil_status = 'Normal';
      }
      device.add(ValueModel(soil_serial, "SOIL", soil_value, soil_status));
    });
  }
*/
  @override
  void initState() {
    // TODO: implement initState
    // data();
    // data_pompa();
    connect();
    //MyHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: check_status?ListView.builder(
                  reverse: true,
                  itemCount: device.length,
                  itemBuilder: (context,idx){

                    return ContentCardView(device: device[idx],);
                  },
                ):Container(
                  child: Center(
                    child: Text("RMQ Not Connected \nPlease check your credential"),
                  ),
                )
            )
        )
    );

    // TODO: implement build
    throw UnimplementedError();
  }
}
