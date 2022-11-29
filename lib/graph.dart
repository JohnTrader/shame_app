import 'dart:async';

import 'package:shame_app/sensor_data.dart';
import 'package:shame_app/themes/colors.dart';
import 'package:flutter/material.dart';

class Graph extends StatelessWidget {
  final double height;
  final AnimationController graphAnimationController;
  final List<GraphData> values;

  Graph({required this.graphAnimationController, this.height = 120, required this.values});

  @override
  Widget build(BuildContext context) {
    GraphData _maxGraphData = values.reduce((current, next) => (next.compareTo(current) >= 1) ? next : current);
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var graphData in values)
            GraphBar(
              key: GlobalKey(debugLabel: _maxGraphData.value.toString()),
              height: height,
              percentage: graphData.value / _maxGraphData.value,
              graphBarAnimationController: graphAnimationController,
            ),
        ],
      ),
    );
  }
}

class GraphBar extends StatefulWidget {
  final double height, percentage;
  final AnimationController graphBarAnimationController;

  const GraphBar({required Key key, required this.height, required this.percentage, required this.graphBarAnimationController}) : super(key: key);

  @override
  _GraphBarState createState() => _GraphBarState();
}

class _GraphBarState extends State<GraphBar> {
  late Animation<double> _percentageAnimation;
  late StreamController<double> _percentageAnimationStreamController;
  late Stream<double> _percentageAnimationStream;
  late Sink<double> _percentageAnimationSink;

  @override
  void initState() {
    super.initState();
    _percentageAnimationStreamController = StreamController<double>();
    _percentageAnimationStream = _percentageAnimationStreamController.stream;
    _percentageAnimationSink = _percentageAnimationStreamController.sink;
    _percentageAnimation = Tween<double>(begin: 0, end: widget.percentage).animate(widget.graphBarAnimationController);
    _percentageAnimation.addListener(() {
      if (mounted) {
        _percentageAnimationSink.add(_percentageAnimation.value);
      }
    });
    if (mounted) {
      _percentageAnimationSink.add(widget.percentage);
    }
  }

  @override
  void dispose() {
    _percentageAnimationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _percentageAnimationStream,
      initialData: 0.0,
      builder: (context, AsyncSnapshot<double> snapshot) {
        return CustomPaint(
          painter: BarPainter(snapshot.requireData),
          child: Container(
            height: widget.height,
          ),
        );
      },
    );
  }
}

class BarPainter extends CustomPainter {
  final double percentage;

  BarPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint greyPaint = Paint()
      ..color = greyColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0;

    Offset topPoint = Offset(0, 0);
    Offset bottomPoint = Offset(0, (size.height + 20));
    Offset centerPoint = Offset(0, (size.height + 20) / 2);

    canvas.drawLine(topPoint, bottomPoint, greyPaint);

    Paint filledPaint = Paint()
      ..shader = LinearGradient(colors: [Colors.pink.shade500, Colors.blue.shade500], begin: Alignment.topCenter)
          .createShader(Rect.fromPoints(topPoint, bottomPoint))
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0;

    double filledHeight = percentage * size.height;
    double filledHalfHeight = filledHeight / 2;

    canvas.drawLine(centerPoint, Offset(0, centerPoint.dy - filledHalfHeight), filledPaint);
    canvas.drawLine(centerPoint, Offset(0, centerPoint.dy + filledHalfHeight), filledPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}