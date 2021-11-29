import 'package:mongo_dart/mongo_dart.dart';

class Mongo {
  static var db, coll;

  static connect() async {
    db = await Db.create('connect_string');
    await db.open();
    coll = db.collection("templates");
  }

  static Future<List<Map<String, dynamic>>> getall(
      {required bool rev, required bool shuffle}) async {
    try {
      List<Map<String, dynamic>> out = await coll.find().toList();
      if (shuffle == true) {
        out.shuffle();
      }
      if (rev == true) {
        return out.reversed.toList();
      } else {
        return out;
      }
    } catch (e) {
      return Future.value();
    }
  }

  static Future<Map<String, dynamic>> get(String id) async {
    try {
      var out = await coll.find({'pri_id': id}).toList();
      return out[0];
    } catch (e) {
      return Future.value();
    }
  }
}
