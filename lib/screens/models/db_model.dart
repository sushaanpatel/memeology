import 'package:mongo_dart/mongo_dart.dart';

class Mongo {
  static var db, coll;

  static connect() async {
    db = await Db.create(
        'mongodb+srv://root:_password@memes.2xsyj.mongodb.net/memes?retryWrites=true&w=majority');
    await db.open();
    coll = db.collection("templates");
  }

  static Future<List<Map<String, dynamic>>> getall() async {
    try {
      var out = await coll.find().toList();
      return out;
    } catch (e) {
      return Future.value();
    }
  }

  static Future<Map<String, dynamic>> get(ObjectId id) async {
    try {
      var out = await coll.find({'_id': id}).toList();
      return out;
    } catch (e) {
      return Future.value();
    }
  }
}
