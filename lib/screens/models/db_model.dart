import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Mongo {
  static var db, coll;

  static connect() async {
    var pass = dotenv.env['PASS'];
    db = await Db.create(
<<<<<<< HEAD
        'mongodb+srv://root:$pass@memes.2xsyj.mongodb.net/memes?retryWrites=true&w=majority');
=======
        'mongodb+srv://root:<password>@memes.2xsyj.mongodb.net/memes?retryWrites=true&w=majority');
>>>>>>> 56ac719321b12cdf6df552eabe98633e161964bc
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
