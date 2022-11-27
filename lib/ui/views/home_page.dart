import 'package:shame_app/insert.dart';
import 'package:shame_app/radial_progress.dart';
import 'package:shame_app/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:shame_app/date_utils.dart';
import 'package:shame_app/blocs/home_page_bloc.dart';
import 'package:dart_amqp/dart_amqp.dart';
import '../../dbhelper/mongodb.dart';
import '../../dbhelper/mongodb2.dart';
//import 'home_dashboard.dart';


class MyHomePage extends StatefulWidget {
  String user;
  String pass;
  String vhost;

  MyHomePage({required this.user, required this.pass, required this.vhost});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late HomePageBloc _homePageBloc;
  late AnimationController _iconAnimationController;

  String payload="";
  bool rmq_status = false;
  bool check_status = false;

  @override
  void initState() {
    _homePageBloc = HomePageBloc();
    _iconAnimationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
    connect();

  }
  // ignore: non_constant_identifier_names
  void_dispose() {
    _homePageBloc.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  Future<void> connect() async {
    try {

      ConnectionSettings settings = ConnectionSettings(
        host: 'rmq2.pptik.id',
        authProvider: PlainAuthenticator(widget.user, widget.pass),
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
          print("Connected to RabbitMQ-AMQP");
          rmq_status = true;
        });
      });

      client
          .channel()
          .then((Channel channel) => channel.queue("Sensor_PZEM004T", durable: true))
          .then((Queue queue) => queue.consume())
          .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
        print("[x] Diterima RabbitMQ ${message.payloadAsString}");

        setState(() {
          payload = message.payloadAsString;
          //MongoDatabase.insertData(payload);
          MongoDatabase2.connect(payload);
          //MongoDbInsert();
        });
      }));
    } on Exception catch (e) {
      print("[x]Received False ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  TopBar(),
                  Positioned(
                    top: 60.0,
                    left: 0.0,
                    right: 0.0,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 35,
                          ),
                          onPressed: () {
                            _homePageBloc.subtractDate();
                          },
                        ),
                        StreamBuilder(
                          stream: _homePageBloc.dateStream,
                          initialData: _homePageBloc.selectedDate,
                          builder: (context, snapshot) {
                            return Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    formatterDayOfWeek.format(
                                        snapshot.requireData),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0,
                                        color: Colors.white,
                                        letterSpacing: 1.2),
                                  ),
                                  Text(
                                    formatterDate.format(snapshot.requireData),
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Transform.rotate(
                          angle: 135.0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 35.0,
                            ),
                            onPressed: () {
                              _homePageBloc.addDate();
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              //MongoDatabase.connect(),
              RadialProgress(payload:payload),
              MonthlyStatusListing()
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.redAccent, width: 4.0)),
              child: IconButton(
                  icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      color: Colors.redAccent,
                      progress: _iconAnimationController.view),
                  onPressed: () {
                    onIconPressed();
                    //MaterialPageRoute(builder: (context) => HomePage(user: widget.user,pass: widget.pass,vhost: widget.vhost,));
                  }),
            ),
          )
        ],
      ),
    );
  }
  void onIconPressed() {
    animationStatus
        ? _iconAnimationController.reverse()
        : _iconAnimationController.forward();

  }

  bool get animationStatus {
    final AnimationStatus status = _iconAnimationController.status;
    return status == AnimationStatus.completed;
  }
}
class MonthlyStatusListing extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Flexible(
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: const <Widget>[
              MonthlyStatusRow('  November 2022', '  On going'),
              MonthlyStatusRow('  October 2022', '  120 KWH'),
              MonthlyStatusRow('  September 2022', '  150 KWH'),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: const <Widget>[
              MonthlyTargetRow('Monthly Cost   ', 'On Going'),
              MonthlyTargetRow('Monthly Cost   ', 'Rp 173.364'),
              MonthlyTargetRow('Monthly Cost   ', 'Rp 216.705'),
            ],
          ),
        ],
      ),
    );
  }
}

class MonthlyStatusRow extends StatelessWidget {
  final String monthYear, status;

  const MonthlyStatusRow(this.monthYear, this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            monthYear,
            style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          Text(
            status,
            style: const TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

class MonthlyTargetRow extends StatelessWidget {
  final String target, targetAchieved;

  const MonthlyTargetRow(this.target, this.targetAchieved, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            target,
            style: const TextStyle(color: Colors.black, fontSize: 18.0),
          ),
          Text(
            targetAchieved,
            style: const TextStyle(color: Colors.grey, fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
