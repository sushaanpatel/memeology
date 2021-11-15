import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'models/db_model.dart';
import 'models/meme_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageDiv extends StatelessWidget {
  final Meme meme;
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

  ImageDiv({required this.meme});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _onlocationtap(context, meme.id.toString()),
        child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    meme.image,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(meme.title,
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.w500)),
                _buildPopularity(meme.popularity),
                const SizedBox(
                  height: 8,
                )
              ],
            )));
  }

  _onlocationtap(BuildContext context, String id) {
    Navigator.pushNamed(context, '/details/$id');
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            child: Column(children: [
      Image.asset(
        'assets/icons/logo_crop.png',
        width: 260,
      ),
      FutureBuilder(
        future: Mongo.getall(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: snapshot.data!
                        .map((meme) => Padding(
                            padding: EdgeInsets.fromLTRB(2, 0, 2, 8),
                            child: ImageDiv(meme: Meme.fromJson(meme))))
                        .toList());
              }
            }
          }
          return Text('');
        },
      )
    ])));
  }
}
