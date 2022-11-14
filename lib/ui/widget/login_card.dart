import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shame_app/ui/model/value_model.dart';

class ContentCardView extends StatelessWidget{
  ValueModel device;
  ContentCardView({required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 220,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(7),
            child: Stack(children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                cryptoIcon(),
                                SizedBox(
                                  height: 10,
                                ),
                                cryptoNameSymbol(),
                                Spacer(),
                                cryptoChange(),
                                SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 20,
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                cryptoAmount()
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
  Widget cryptoIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: device.nama=="POMPA"?
          Icon(
            Icons.settings,
            color: Colors.grey,
            size: 40,
          ): Icon(
            Icons.waves,
            color: Colors.lightBlue,
            size: 40,
          )
      ),
    );
  }
  Widget cryptoNameSymbol() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: '${device.nama}',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: ' ${device.serial}',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  Widget cryptoChange() {
    return Align(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          text: '${device.status}',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
        ),
      ),
    );
  }

  // Widget changeIcon(data) {
  //   return Align(
  //       alignment: Alignment.topRight,
  //       child: data[‘change’].contains(‘-’)
  //       ? Icon(
  //     Typicons.arrow_sorted_down,
  //     color: data[‘changeColor’],
  //     size: 30,
  //   )
  //       : Icon(
  //     Typicons.arrow_sorted_up,
  //     color: data[‘changeColor’],
  //     size: 30,
  //   ));
  // }
  Widget cryptoAmount() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text:'${device.value}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 35,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'value',
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}