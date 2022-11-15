import 'package:shame_app/radial_progress.dart';
import 'package:shame_app/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:shame_app/date_utils.dart';
import 'package:shame_app/blocs/home_page_bloc.dart';
import 'package:dart_amqp/dart_amqp.dart';

class MyHomePage extends StatefulWidget {
  //const MyHomePage({super.key});
  String user;
  String pass;
  String vhost;

  MyHomePage({required this.user, required this.pass, required this.vhost});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late HomePageBloc _homePageBloc;
  late AnimationController _iconAnimationController;
  String payload = "";
  late Client client;
  bool rmq_status = true;
  bool check_status = false;

  @override
  void initState() {
    _homePageBloc = HomePageBloc();
    _iconAnimationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
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

      Client client = new Client(settings: settings);

      client.errorListener((error) {print("dsa${error.toString()}"); });
      client.connect().catchError((Object error){
        print("dsa ${error.toString()}");
        setState(() {
          rmq_status = false;
        });
      });
      client.connect().then((value){
        setState(() {
          rmq_status = true;
        });
      });

      client
          .channel()
          .then((Channel channel) => channel.queue("Sensor_PZEM004T", durable: true))
          .then((Queue queue) => queue.consume())
          .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
        print("test ${message.payloadAsString}");
        //setValuePompa(message.payloadAsString);
        setState(() {
          payload = message.payloadAsString;
        });
      }));

    } on Exception catch (e) {
      print("[x]Received False ${e.toString()}");
    }
  }

  // ignore: non_constant_identifier_names
  void_dispose() {
    _homePageBloc.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              RadialProgress(),
              MonthlyStatusListing()
            ],
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 4.0)),
              child: IconButton(
                  icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      color: Colors.red,
                      progress: _iconAnimationController.view),
                  onPressed: () {
                    onIconPressed();
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
