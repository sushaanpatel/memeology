import 'package:mongo_dart/mongo_dart.dart';

class Mongo {
  static var db, coll;

  static connect() async {
    db = await Db.create(
        'mongodb+srv://root:_password@temp.2xsyj.mongodb.net/temp?retryWrites=true&w=majority');
    await db.open();
    print("Connection Done.");
    coll = db.collection("users");
  }

  static Future<List<Map<String, dynamic>>> getall() async {
    try {
      var out = await coll.find().toList();
      print(out);
      return out;
    } catch (e) {
      print(e);
      return Future.value();
    }
  }

  static insert() async {
    Map<String, dynamic> x = {'name': 'Aahan Patel', 'degree': 'Comp Eng'};
    await coll.insertOne(x);
  }

  static delete(x) async {
    Map<String, dynamic> y = {'_id': x};
    await coll.deleteOne(y);
  }
}
