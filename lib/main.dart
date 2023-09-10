import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/meme_page.dart';
import 'screens/home.dart';
import 'screens/models/db_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  await Mongo.connect();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeP(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeP>(context);
        return MaterialApp(
          title: 'Memeology',
          home: Home(),
          debugShowCheckedModeBanner: false,
          theme: Theme.light,
          themeMode: themeProvider.themeMode,
          darkTheme: Theme.dark,
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
              return MaterialPageRoute(
                  builder: (context) => MemeDetail(id: id));
            }

            return MaterialPageRoute(builder: (context) => Home());
          },
        );
      });
}

class Theme {
  static final light = ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xffe6e600),
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xffF5EFED),
      colorScheme: const ColorScheme.light());

  static final dark = ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xffe6e600),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xff222222),
      colorScheme: const ColorScheme.dark());
}

class ThemeP extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool get isDarkMode => themeMode == ThemeMode.dark;
  void toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
