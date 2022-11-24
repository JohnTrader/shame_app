import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shame_app/dbhelper/constant.dart';

class MongoDatabase {

  static connect(String payload) async{
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    //var status = db.serverStatus();
    //print(status);
    var collection = db.collection(USER_COLLECTION);
    //var payload;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d-MMM-yyyy HH:mm:ss').format(now);
    await collection.insertOne({
       "Sensor" : "Energy",
       "KWH" : payload,
       "Time" : formattedDate
     },
    //     {
    //     "username" : "np2",
    //     "name" : "Max Payne2",
    //     "email" : "maxpayne2@gmail.com"
    //     }
         );
     //print(await collection.find().toList());
     print("[x] Sukses Kirim Data ke MongoDB ");
    // await collection.update(where.eq('username','np'), modify.set('name','Max Pax'));
    //print(await collection.find().toList());

    //await collection.deleteOne({"username": "np"});
    //await collection.deleteMany({"username": "np2"});
  }
}

