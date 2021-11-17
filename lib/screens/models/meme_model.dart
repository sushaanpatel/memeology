import 'package:mongo_dart/mongo_dart.dart';

class Meme {
  final ObjectId id;
  final String pri_id;
  final String title;
  final String image;
  final String explanation;
  final String origin;
  final int popularity;
  final List<dynamic> tags;
  Meme(
      {required this.id,
      required this.pri_id,
      required this.title,
      required this.image,
      required this.explanation,
      required this.origin,
      required this.popularity,
      required this.tags});

  Map<String, dynamic> toJson() => {
        'id': id,
        'string_id': pri_id,
        'title': title,
        'image': image,
        'explanation': explanation,
        'origin': origin,
        'popularity': popularity,
        'tags': tags
      };

  Meme.fromJson(var json)
      : id = json['_id'],
        pri_id = json['pri_id'],
        title = json['title'],
        image = json['image'],
        explanation = json['explanation'],
        origin = json['origin'],
        popularity = json['popularity'],
        tags = json['tags'];
}
