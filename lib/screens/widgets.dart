import 'package:flutter/material.dart';
import 'models/api.dart';
import 'package:provider/provider.dart';
import 'models/db_model.dart';
import 'models/meme_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_project/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageDiv extends StatelessWidget {
  final Meme meme;
  Widget _buildPopularity(int popularity) {
    List<Widget> stars = [];
    for (int i = 0; i < popularity; i++) {
      stars.add(const Icon(Icons.star, color: Colors.yellow));
    }
    Widget out = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[...stars]);
    return out;
  }

  ImageDiv({required this.meme});
  @override
  Widget build(BuildContext context) {
    var co = Provider.of<ThemeP>(context).themeMode == ThemeMode.dark
        ? 0xffF5EFED
        : 0xff222222;
    return GestureDetector(
        onTap: () => _onlocationtap(context, meme.pri_id),
        child: Card(
            color: Color(co), //BFACAA
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        image: meme.image,
                        placeholder: 'assets/icons/img_skeleton.gif',
                        width: MediaQuery.of(context).size.width,
                      ),
                    )),
                Text(meme.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
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
                HomeElement(index: 1, list: data)
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
    final text = Provider.of<ThemeP>(context).themeMode == ThemeMode.dark
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
    return SingleChildScrollView(
        child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              child: Image.asset(
                modestr(text),
                width: 260,
              ),
              padding: const EdgeInsets.only(left: 10)),
          Padding(
              child: MemeButton(), padding: const EdgeInsets.only(right: 13))
        ],
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
              children: [
                ...example.map((e) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(e,
                                width:
                                    MediaQuery.of(context).size.width * 0.95)),
                        const SizedBox(
                          height: 12,
                        )
                      ],
                    ))
              ],
            )),
      ],
    );
  }
}

class MemeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showMeme(context),
      child: Image.asset(
        'assets/icons/doge_ic.png',
        width: MediaQuery.of(context).size.width * 0.1,
      ),
    );
  }

  void showMeme(var contex) {
    showDialog(
        context: contex,
        builder: (context) {
          return FutureBuilder(
              future: Api.getMeme(),
              builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 10,
                      title: Text(
                        'Getting meme....',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      content: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/icons/img_skeleton.gif'),
                      ));
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    } else {
                      var r =
                          ApiR.fromJson(snapshot.data as Map<String, dynamic>);
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                        title: Text(
                          r.title,
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/icons/img_skeleton.gif',
                              image: r.url,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          GestureDetector(
                              onTap: () => launch(
                                    r.postLink,
                                    forceWebView: true,
                                  ),
                              child: Text(
                                r.postLink,
                                style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              )),
                        ]),
                        actions: [
                          Center(
                              child: IconButton(
                                  icon: const Icon(Icons.arrow_forward),
                                  onPressed: () => {
                                        Navigator.of(context).pop(),
                                        showMeme(context)
                                      }))
                        ],
                      );
                    }
                  }
                }
                return const Text('');
              });
        });
  }
}
