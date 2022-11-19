
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shame_app/ui/utils/constant.dart';
//import 'package:shame_app/ui/views/home_view.dart';
//import 'package:shame_app/ui/views/home_page.dart';
import 'package:shame_app/ui/views/home_dashboard.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final controller = ScrollController();

  double offset = 0;
  bool _isSelected = false;
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController vhost = new TextEditingController();

  @override
  Widget build(BuildContext context) {
      ScreenUtil.init(
      context,
      designSize: Size(750, 1334),
      minTextAdapt: true,
    );

    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //SizedBox(height: ScreenUtil.getInstance().setHeight(100),),
            SizedBox(height: ScreenUtil().setHeight(100),),
            // MyHeader(
            //   image: "assets/icons/barbecue.svg",
            //   textTop: "Order and",
            //   textBottom: "Get to door steps",
            //   offset: offset,
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  loginCard(context),
                  //SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  SizedBox(height: ScreenUtil().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      InkWell(
                        child: Container(
                          //width: ScreenUtil.getInstance().setWidth(330),
                          width: ScreenUtil().setWidth(330),
                          //height: ScreenUtil.getInstance().setHeight(100),
                          height: ScreenUtil().setHeight(100),
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [
                                BoxShadow(
                                    color: kActiveShadowColor,
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                connectDevice();
                              },
                              child: Center(
                                child: Text("SIGN IN",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 18,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(40),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      //width: ScreenUtil.getInstance().setWidth(120),
      width: ScreenUtil().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  Widget radioButton(bool isSelected) => Container(
    width: 16.0,
    height: 16.0,
    padding: EdgeInsets.all(2.0),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2.0, color: Colors.black)),
    child: isSelected
        ? Container(
      width: double.infinity,
      height: double.infinity,
      decoration:
      BoxDecoration(shape: BoxShape.circle, color: Colors.black),
    )
        : Container(),
  );

  Widget loginCard(BuildContext context) {
    return new Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Login to SHA.ME",
                style: TextStyle(

                    fontSize: ScreenUtil().setSp(45),
                    fontFamily: "Poppins-Bold",
                    letterSpacing: .6)),
            SizedBox(

              height: ScreenUtil().setHeight(30),
            ),
            Text("Username",
                style: TextStyle(
                    fontFamily: "Poppins",

                    fontSize: ScreenUtil().setSp(26))),
            TextField(
              controller: user,
              decoration: InputDecoration(
                  hintText: "eg: chromicle",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              //height: ScreenUtil.getInstance().setHeight(30),
              height: ScreenUtil().setHeight(30),
            ),
            Text("Password",
                style: TextStyle(
                    fontFamily: "Poppins",
                    //fontSize: ScreenUtil.getInstance().setSp(26))),
                    fontSize: ScreenUtil().setSp(26))),
            TextFormField(
              controller: pass,
              decoration: InputDecoration(
                  hintText: "**********",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              //height: ScreenUtil.getInstance().setHeight(30),
              height: ScreenUtil().setHeight(30),
            ),

            Text("Virtualhost",
                style: TextStyle(
                    fontFamily: "Poppins",
                    //fontSize: ScreenUtil.getInstance().setSp(26))),
                    fontSize: ScreenUtil().setSp(26))),
            TextField(
              controller: vhost,
              decoration: InputDecoration(
                  hintText: "eg: /virtualhost",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            SizedBox(
              //height: ScreenUtil.getInstance().setHeight(35),
              height: ScreenUtil().setHeight(35),
            ),
          ],
        ),
      ),
    );
  }
  void connectDevice(){
    Navigator.push(
      context,
      //MaterialPageRoute(builder: (context) => HomeView(user: user.text,pass: pass.text,vhost: vhost.text,)),
      //MaterialPageRoute(builder: (context) => MyHomePage(),
        MaterialPageRoute(builder: (context) => HomePage(),)
      //MaterialPageRoute(builder: (context) => MyHomePage(user: user.text,pass: pass.text,vhost: vhost.text,)),
    );
  }
  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }
}