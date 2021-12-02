import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

var rand = Random();

class ApiR {
  final String title;
  final String url;
  final String postLink;
  ApiR({required this.title, required this.url, required this.postLink});

  ApiR.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        url = json['url'],
        postLink = json['postLink'];
}

class Api {
  static Future<Map<String, dynamic>> getMeme() async {
    List<String> x = ['dankmemes', 'memes', 'wholesomememes'];
    int randInt = rand.nextInt(x.length);
    String subreddit = x[randInt];
    var url = Uri.parse('https://meme-api.herokuapp.com/gimme/$subreddit');
    var r = await http.get(url);
    var json = jsonDecode(r.body);
    if (json['nsfw'] == true) {
      getMeme();
    } else {
      return {
        'title': json['title'],
        'url': json['url'],
        'postLink': json['postLink']
      };
    }
    return {'title': 'Meme Not Found', 'url': '', 'postLink': ''};
  }
}
