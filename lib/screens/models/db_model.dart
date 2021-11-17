import 'package:mongo_dart/mongo_dart.dart';

void main(List<String> args) async {
  await Mongo.connect();
  print(await Mongo.get("1"));
}

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
      List<Map<String, dynamic>> out = await coll.find().toList();
      return out.reversed.toList();
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
