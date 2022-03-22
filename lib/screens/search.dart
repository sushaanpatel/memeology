import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'models/db_model.dart';
import 'models/meme_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class ResultMeme extends StatelessWidget {
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

  ResultMeme({required this.meme});
  @override
  Widget build(BuildContext context) {
    var co = Provider.of<ThemeP>(context).themeMode == ThemeMode.dark
        ? 0xffA39BA8
        : 0xff222222;
    return GestureDetector(
        onTap: () => _onlocationtap(context, meme.pri_id),
        child: Card(
            elevation: 6,
            color: Color(co),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/icons/img_skeleton.gif',
                              image: meme.image,
                              width: MediaQuery.of(context).size.width * 0.3,
                            )))),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Column(children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(meme.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                          textAlign: TextAlign.center)),
                  _buildPopularity(meme.popularity)
                ]),
              ],
            )));
  }

  _onlocationtap(BuildContext context, String id) {
    Navigator.pushNamed(context, '/details/$id');
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const historyLenght = 5;
  List<String> _searchHistory = [];
  late List<String> filteredList;
  String selectedTerm = "Search";

  List<String> filterTerms({
    required String filter,
  }) {
    if (filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addTerm(String term) {
    if (_searchHistory.contains(term)) {
      putTermFirst(term);
      return;
    }
    _searchHistory.add(term);
    if (_searchHistory.length > historyLenght) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLenght);
    }

    filteredList = filterTerms(filter: "");
  }

  void deleteTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredList = filterTerms(filter: "");
  }

  void putTermFirst(String term) {
    deleteTerm(term);
    addTerm(term);
  }

  FloatingSearchBarController controller = FloatingSearchBarController();

  @override
  void initState() {
    super.initState();
    filteredList = filterTerms(filter: "");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FloatingSearchBar(
      body: FloatingSearchBarScrollNotifier(
          child: ResultsWidget(results: filter(selectedTerm), def: true)),
      transition: CircularFloatingSearchBarTransition(),
      physics: const BouncingScrollPhysics(),
      elevation: 2,
      accentColor: Colors.blueAccent,
      hintStyle:
          GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500),
      queryStyle:
          GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500),
      clearQueryOnClose: true,
      borderRadius: BorderRadius.circular(10),
      title: Text(
        selectedTerm,
        style:
            GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      controller: controller,
      hint: "Search",
      iconColor: const Color(0xffe6e600),
      actions: [
        FloatingSearchBarAction.searchToClear(),
      ],
      leadingActions: [
        FloatingSearchBarAction.icon(
            showIfClosed: false,
            showIfOpened: true,
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xffe6e600),
              size: 24,
            ),
            onTap: () {
              controller.close();
            }),
      ],
      onQueryChanged: (query) {
        setState(() {
          filteredList = filterTerms(filter: query);
        });
      },
      onSubmitted: (query) {
        setState(() {
          addTerm(query);
          selectedTerm = query;
        });
        controller.close();
      },
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            elevation: 8,
            child: Builder(builder: (context) {
              if (filteredList.isEmpty && controller.query.isEmpty) {
                return Container(
                    height: 56,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Start Searching',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ));
              } else if (filteredList.isEmpty) {
                return ListTile(
                  title: Text(controller.query),
                  leading: const Icon(Icons.search),
                  onTap: () {
                    setState(() {
                      addTerm(controller.query);
                      selectedTerm = controller.query;
                    });
                    controller.close();
                  },
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: filteredList
                      .map((e) => ListTile(
                            title: Text(e,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            leading: const Icon(Icons.history),
                            trailing: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  deleteTerm(e);
                                });
                              },
                            ),
                            onTap: () {
                              setState(() {
                                putTermFirst(e);
                                selectedTerm = e;
                              });
                              controller.close();
                            },
                          ))
                      .toList(),
                );
              }
            }),
          ),
        );
      },
    ));
  }

  Future<List<Map<String, dynamic>>> filter(String x) async {
    List<Map<String, dynamic>> temp = [];
    List<Map<String, dynamic>> out = [];
    List<Map<String, dynamic>> query =
        await Mongo.getall(rev: true, shuffle: false);
    var count = await Mongo.coll.count();
    if (x.isNotEmpty) {
      for (var i = 0; i < count; i++) {
        String g = query[i]["title"];
        String h = g.toLowerCase();
        String y = x.toLowerCase();
        if (h.contains(y)) {
          temp.add(query[i]);
        }
      }
    }
    out.addAll(temp);
    return out;
  }
}

class ResultsWidget extends StatelessWidget {
  bool def;
  Future<List<Map<String, dynamic>>> results;
  ResultsWidget({required this.results, required this.def});
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: results,
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
                if (snapshot.data!.isEmpty) {
                  if (def == true) {
                    return FutureBuilder(
                        future: Mongo.getall(rev: false, shuffle: false),
                        builder: (context,
                            AsyncSnapshot<List<Map<String, dynamic>>> sp) {
                          if (sp.connectionState == ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                              backgroundColor: Colors.yellow,
                              color: Colors.yellow[700],
                            ));
                          } else {
                            return ListView.builder(
                                padding: const EdgeInsets.only(top: 60),
                                itemCount: sp.data!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 4),
                                      child: ResultMeme(
                                        meme: Meme.fromJson(sp.data![index]),
                                      ));
                                });
                          }
                        });
                  } else {
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icons/sad_cat.png',
                                  height:
                                      MediaQuery.of(context).size.width * 0.9,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text('No Memes Found',
                                    style: GoogleFonts.poppins(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                              ]),
                        ));
                  }
                } else {
                  return ListView.builder(
                      padding: const EdgeInsets.only(top: 60),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
                            child: ResultMeme(
                              meme: Meme.fromJson(snapshot.data![index]),
                            ));
                      });
                }
              }
            }
            return Text('');
          }
        });
  }
}
