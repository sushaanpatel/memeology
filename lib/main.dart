import 'package:flutter/material.dart';
import 'screens/meme_page.dart';
import 'screens/home.dart';
import 'screens/models/db_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Mongo.connect();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memeology',
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Handle '/'
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => Home());
        }

        // Handle '/details/:id'
        var uri = Uri.parse(settings.name as String);
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'details') {
          var id = uri.pathSegments[1].toString();
          return MaterialPageRoute(builder: (context) => MemeDetail(id: id));
        }

        return MaterialPageRoute(builder: (context) => Home());
      },
    );
  }
}
