import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_project/main.dart';
import 'package:provider/provider.dart';

bool mode = false;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeP>(context);
    return Center(
        child: SafeArea(
            child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
              trailing: Switch.adaptive(
                  activeColor: const Color(0xffe6e600),
                  autofocus: true,
                  inactiveThumbColor: const Color(0xffe6e600),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    final provider =
                        Provider.of<ThemeP>(context, listen: false);
                    provider.toggleTheme(value);
                  }),
              title: Text("Dark Mode",
                  style: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.bold))),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                        title: Text("About Memeology",
                            style: GoogleFonts.poppins(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        content: Text(
                            "Memeology is a meme information tool for the less meme informed where they can look up the explanation, origin, popularity, and much more information about meme templates",
                            style: GoogleFonts.poppins(
                                fontSize: 19, fontWeight: FontWeight.w500)));
                  });
            },
            child: ListTile(
              title: Text("About Us",
                  style: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    )));
  }
}
