import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

MongoDbModel mongoDbModelFromJson(String str) =>
    MongoDbModel.fromJson(json.decode(str));


String mongoDbModelToJason(MongoDbModel data) => json.encode(data.toJson());

class MongoDbModel {
  MongoDbModel ({
     required this.id,
     required this.firstName,
     required this.lastName,
     required this.address,
    //required this.id,
    //required this.Sensor,
    //required this.KWH,
    //required this.Time,
  });

   ObjectId id;
   String firstName;
   String lastName;
   String address;
    //ObjectId id;
    //String Sensor;
    //String KWH;
    //String Time;

  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
    id: json["_id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    address: json["address"],
     //firstName: json["Sensor"],
     //lastName: json["KWH"],
     //address: json["Time"],
  );

  Map<String,dynamic> toJson() => {
    "_id": id,
    "firstName": firstName,
    "lastName": lastName,
    "address": address,
    //"Sensor": firstName,
    //"KWH": lastName,
    //"Time": address,
  };
}