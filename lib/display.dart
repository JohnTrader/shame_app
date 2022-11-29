import 'package:flutter/material.dart';
import 'package:shame_app/MongoDBModel.dart';
import 'package:shame_app/dbhelper/mongodb.dart';

class MongoDbDisplay extends StatefulWidget {
  const MongoDbDisplay({Key? key}) : super(key: key);

  @override
  _MongoDbDisplayState createState() => _MongoDbDisplayState();
}

class _MongoDbDisplayState extends State<MongoDbDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(

          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
              future: MongoDatabase.getData(),
              builder: (context, AsyncSnapshot snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }else{
                if(snapshot.hasData){
                  var totalData = snapshot.data.length;
                  print("Total Data : " + totalData.toString());
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder:(context, index){
                        return displayCard(
                           MongoDbModel.fromJson(snapshot.data[index]));
                        //return Text("Data Found");
                  });
                }else {
                  return Center(
                    child: Text("No Data Available."),
                  );
                }
              }
            }
          ),
        )
      ),
    );
  }
  Widget displayCard (MongoDbModel data){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${data.id.$oid}"),
            //Text("${data.id}"),
            SizedBox(height: 5,),
            Text("${data.firstName}"),
            SizedBox(height: 5,),
            Text("${data.lastName}"),
            SizedBox(height: 5,),
            Text("${data.address}"),
          ],
        ),
      ),
    );
  }
}
