import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shame_app/MongoDBModel.dart';
import 'package:shame_app/dbhelper/constant.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'mongodb.dart';


class MongoDatabase2 {

  static connect(String payload) async {

    var db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    //var status = db.serverStatus();
    //print(status);
    var collection = db.collection(USER_COLLECTION);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d-MMM-yyyy HH:mm:ss').format(now);

    String _Sensor = "Energy";
    String _KWH = payload;
    String _Time = formattedDate;
    var _id = M.ObjectId();
    final data = MongoDbModel(
        id: _id, firstName: _Sensor, lastName: _KWH, address: _Time);
    //var result = await MongoDatabase.insert(data);
    await MongoDatabase.insert(data);
      //print(await collection.find().toList());
      print("[x] Sukses Kirim Data ke MongoDB ");
      // await collection.update(where.eq('username','np'), modify.set('name','Max Pax'));
      //print(await collection.find().toList());
      //await collection.deleteOne({"username": "np"});
      //await collection.deleteMany({"Sensor": "Energy"});
    }
  }

