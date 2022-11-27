import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shame_app/MongoDBModel.dart';
import 'package:shame_app/dbhelper/constant.dart';

/*
class MongoDatabase {

  //static connect(String payload) async {
  static connect(String payload) async {
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    //var status = db.serverStatus();
    //print(status);
    var collection = db.collection(USER_COLLECTION);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d-MMM-yyyy HH:mm:ss').format(now);
    await collection.insertOne({
        "Sensor" : "Energy",
        "KWH" : payload,
        "Time" : formattedDate
         },
     );

      //print(await collection.find().toList());
      print("[x] Sukses Kirim Data ke MongoDB ");
      // await collection.update(where.eq('username','np'), modify.set('name','Max Pax'));
      //print(await collection.find().toList());
      //await collection.deleteOne({"username": "np"});
      //await collection.deleteMany({"Sensor": "Energy"});
    }
  }
*/



class MongoDatabase{
   static var db, userCollection;

   static connect() async{
     db = await Db.create(MONGO_CONN_URL);
     await db.open();
     userCollection = db.collection(USER_COLLECTION);

   }

   static insertData(String payload) async{

     DateTime now = DateTime.now();
     String formattedDate = DateFormat('d-MMM-yyyy HH:mm:ss').format(now);
     await userCollection.insertOne({
       "Sensor" : "Energy",
       "KWH" : payload,
       "Time" : formattedDate
       },
     );
     print("[x] Sukses Kirim Data ke MongoDB ");
   }

   static Future<List<Map<String, dynamic>>> getData() async{
     final arrData = await userCollection.find().toList();
     return arrData;
   }

   static Future <String> insert(MongoDbModel data) async{
     try {
       var result = await userCollection.insertOne(data.toJson());
       //print(await userCollection.find().toList());
       if(result.isSuccess) {
         return "Data Inserted";

       } else {
         return "Something Wrong While Inserting Data...";
       }
     } catch (e) {
       print(e.toString());
       return e.toString();
     }
   }
}
