import 'package:flutter/material.dart';
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
        onTap: () => _onlocationtap(context, meme.pri_id),
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
                  child: FadeInImage.assetNetwork(
                    image: meme.image,
                    placeholder: 'assets/icons/img_skeleton.gif',
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(meme.title,
                    textAlign: TextAlign.center,
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

PageController pg = PageController(initialPage: 0);

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
      future: Mongo.getall(rev: true, shuffle: true),
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
              List<Map<String, dynamic>> temp = [];
              List<List<Map<String, dynamic>>> data = [];
              int i = 0;
              while (i < snapshot.data!.length) {
                temp.add(snapshot.data![i]);
                i++;
                if (i != 0 && i % 10 == 0) {
                  data.add(temp);
                  temp = [];
                }
              }
              return PageView(children: [
                HomeElement(index: 0, list: data),
                HomeElement(index: 1, list: data),
                HomeElement(index: 2, list: data),
                HomeElement(index: 3, list: data),
                HomeElement(list: data, index: 4)
              ]);
            }
          }
        }
        return const Text('');
      },
    ));
  }
}

class HomeElement extends StatefulWidget {
  List<List<Map<String, dynamic>>> list;
  int index;
  HomeElement({required this.list, required this.index});
  @override
  _HomeElementState createState() => _HomeElementState();
}

class _HomeElementState extends State<HomeElement> {
  @override
  Widget build(BuildContext context) {
    final text = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? 'dark'
        : 'light';
    String modestr(x) {
      if (x == 'dark') {
        return 'assets/icons/logo_crop_dark.png';
      } else {
        return 'assets/icons/logo_crop_light.png';
      }
    }

    List<List<Map<String, dynamic>>> list = widget.list;
    int index = widget.index;
    List<Map<String, dynamic>> data;
    return SingleChildScrollView(
        child: Column(children: [
      Image.asset(
        modestr(text),
        width: 260,
      ),
      const SizedBox(
        height: 8,
      ),
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: list[index]
              .map((meme) => Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 2, 8),
                  child: ImageDiv(meme: Meme.fromJson(meme))))
              .toList()),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const Icon(Icons.arrow_back),
          Text("Swipe to back | Swipe to next",
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w500)),
          const Icon(Icons.arrow_forward)
        ]),
      )
    ]));
  }
}

class TextSection extends StatelessWidget {
  final String title;
  final String text;
  TextSection(this.title, this.text);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 2, 10),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 30, fontWeight: FontWeight.bold),
            )),
        Padding(
            padding: const EdgeInsets.only(left: 15, right: 2),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  fontSize: 17, fontWeight: FontWeight.w500),
            )),
      ],
    );
  }
}

class ExamplesDiv extends StatelessWidget {
  final List<dynamic> example;
  ExamplesDiv(this.example);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 2, 10),
            child: Text(
              'Examples',
              style: GoogleFonts.poppins(
                  fontSize: 30, fontWeight: FontWeight.bold),
            )),
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 2, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: []..addAll(example.map((e) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(e,
                              width: MediaQuery.of(context).size.width * 0.95)),
                      const SizedBox(
                        height: 12,
                      )
                    ],
                  ))),
            )),
      ],
    );
  }
}
