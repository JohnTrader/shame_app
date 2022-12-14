import 'package:shame_app/sensor_data.dart';
import 'package:shame_app/graph.dart';
import 'package:flutter/material.dart';
import '../../activities_widget.dart';

class ShowGraph extends StatefulWidget {
  @override
  _ShowGraphState createState() => _ShowGraphState();
}

class _ShowGraphState extends State<ShowGraph> with SingleTickerProviderStateMixin<ShowGraph> {

  late AnimationController _graphAnimationController;

  @override
  void initState() {
    super.initState();
    _graphAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    _graphAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {
              _graphAnimationController.forward();
            },
            child: Graph(
                //animationController: _graphAnimationController,
                graphAnimationController: _graphAnimationController,
                values: runningDayData
                //values: dayData
            ),
          ),
        ),
        //ActivitiesWidget(_iconAnimationController, MediaQuery.of(context).size.height),
      ),
    );
  }
}
