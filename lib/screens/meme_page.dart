import 'package:flutter/material.dart';
import 'package:pp_project/screens/models/db_model.dart';
import 'models/meme_model.dart';
import 'widgets.dart';
import 'models/db_model.dart';
import 'package:google_fonts/google_fonts.dart';

class MemeDetail extends StatelessWidget {
  final String id;
  MemeDetail({required this.id});

  Widget _buildPopularity(int popularity) {
    List<Widget> stars = [];
    for (int i = 0; i < popularity; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow));
    }
    Widget out = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[]..addAll(stars));
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Mongo.get(id),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.yellow,
              color: Colors.yellow[700],
            ));
          } else {
            if (snapshot.hasData) {
              if (snapshot.hasError) {
                print(snapshot.error);
              } else {
                Meme meme = Meme.fromJson(snapshot.data);
                return Scaffold(
                    appBar: AppBar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      iconTheme: const IconThemeData(
                          color: Color(0xffe6e600), size: 30),
                      title: Text(
                        meme.title,
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).textTheme.bodyText1!.color),
                      ),
                      shadowColor: Colors.transparent,
                      centerTitle: true,
                    ),
                    body: SafeArea(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  meme.image,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextSection("Origin", meme.origin),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextSection("Explanation", meme.explanation),
                                const SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Row(children: [
                                      Text('Popularity : ',
                                          style: GoogleFonts.poppins(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                      _buildPopularity(meme.popularity)
                                    ])),
                                const SizedBox(
                                  height: 30,
                                ),
                                ExamplesDiv(meme.examples)
                              ],
                            ))));
              }
            }
            return Text("");
          }
        });
  }
}
