import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class RadialProgress extends StatefulWidget {
  final double goalCompleted=0.75;

  final String payload;
  const RadialProgress({super.key, required this.payload});
 //const RadialProgress(this.payload,{super.key});

  @override
  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress> with SingleTickerProviderStateMixin{
  late AnimationController _radialProgressAnimationController;
  late Animation<double> _progressAnimation;


  double progressDegrees = 0;
  var count = 0;

  @override
  void initState() {
    super.initState();
    _radialProgressAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _progressAnimation = Tween(begin: 0.0, end: 360.0).animate(CurvedAnimation(
        parent: _radialProgressAnimationController, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {
          //widget.goalCompleted=widget.payload;
          progressDegrees = widget.goalCompleted * _progressAnimation.value;
        });
      });
    _radialProgressAnimationController.forward();
  }

  @override
  void dispose() {
    _radialProgressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        height: 200.0,
        width: 200.0,
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: AnimatedOpacity(
          opacity: progressDegrees > 30 ? 1.0 : 0.0,
          duration: Duration(seconds: 3),
          child: Column(
            children: <Widget>[
              Text(
                'ENERGY',
                style: TextStyle(fontSize: 24.0, letterSpacing: 1.5),
              ),
              SizedBox(
                height: 4.0,
              ),
              Container(
                height: 5.0,
                width: 94.0,
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                widget.payload,
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'KWH USED',
                style: TextStyle(
                    fontSize: 14.0, color: Colors.blue, letterSpacing: 1.5,fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      painter: RadialPainter(progressDegrees),
    );
  }
}
class RadialPainter extends CustomPainter{
  double progressInDegress ;
  RadialPainter(this.progressInDegress);

  @override
  void paint(Canvas canvas, Size size){
    Paint paint = Paint()
      ..color=Colors.black12
      ..strokeCap=StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth=8.0;

    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, paint);

    Paint progressPaint = Paint()
      //..color=Colors.blue
      ..shader = LinearGradient(
          colors:[Colors.red, Colors.purple, Colors.purpleAccent])
          .createShader(Rect.fromCircle(center: center, radius: size.width/2))
      ..strokeCap=StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth=8.0;
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90),
        math.radians(progressInDegress),
        false,
        progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    //throw UnimplementedError();
    return true;
  }
}