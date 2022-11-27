import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shame_app/MongoDBModel.dart';
import 'package:shame_app/dbhelper/constant.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

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
     String _Sensor = "Energy";
     String _KWH = payload;
     String _Time = formattedDate;
     var _id = M.ObjectId();
     final data = MongoDbModel(
         id: _id, firstName: _Sensor, lastName: _KWH, address: _Time);
     await MongoDatabase.insert(data);
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
