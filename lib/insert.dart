import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:shame_app/MongoDBModel.dart';
import 'package:shame_app/dbhelper/mongodb.dart';

class MongoDbInsert extends StatefulWidget {
  const MongoDbInsert({Key? key}) : super(key: key);

  @override
  _MongoDbInsertState createState() => _MongoDbInsertState();
}

class _MongoDbInsertState extends State<MongoDbInsert> {
  var fnameController = new TextEditingController();
  var lnameController = new TextEditingController();
  var addressController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                "Insert Data",
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: fnameController,
                decoration: InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: lnameController,
                decoration: InputDecoration(labelText: "Last Name"),
              ),
              TextField(
                controller: addressController,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(labelText: "Address"),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        _fakeData();
                      },
                      child: Text("Generate Data")),
                  ElevatedButton(
                      onPressed: () {
                        _insertData(fnameController.text, lnameController.text,
                            addressController.text);
                      },
                      child: Text("Insert Data"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _insertData(String _Sensor, String _KWH, String _Time) async {
    var _id = M.ObjectId();
    final data = MongoDbModel(
        id: _id, firstName: _Sensor, lastName: _KWH, address: _Time);
    //var result = await MongoDatabase.insert(data);
    await MongoDatabase.insert(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Inserted ID " + _id.$oid)));
    _clearAll();
  }

  void _clearAll() {
    fnameController.text = "";
    lnameController.text = "";
    addressController.text = "";
}

  void _fakeData() {
    setState(() {
      fnameController.text = faker.person.firstName();
      lnameController.text = faker.person.lastName();
      addressController.text =
          faker.address.streetAddress() + "\n" + faker.address.streetAddress();
    });
  }
}
