import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shame_app/dbhelper/constant.dart';

class MongoDatabase {

  static connect() async{
    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    print(status);
    var collection = db.collection(USER_COLLECTION);
    // await collection.insertOne({
    //   "Sensor" : "PZEM004T",
    //   "Energy" : "0.685",
    //   "Time" : "24-Nov-2022 14:40"
    // },
    //     {
    //     "username" : "np2",
    //     "name" : "Max Payne2",
    //     "email" : "maxpayne2@gmail.com"
    //     }
    //     );
    // print(await collection.find().toList());
    //
    // await collection.update(where.eq('username','np'), modify.set('name','Max Pax'));
    print(await collection.find().toList());

    //await collection.deleteOne({"username": "np"});
    //await collection.deleteMany({"username": "np2"});
  }
}