import 'package:flutter/material.dart';
import 'package:pp_project/screens/models/db_model.dart';
import 'models/meme_model.dart';
import 'widgets.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:google_fonts/google_fonts.dart';

class MemeDetail extends StatelessWidget {
  final String id;
  MemeDetail({required this.id});

  @override
  Widget build(BuildContext context) {
    // var meme = Meme.fromJson(_x);
    return Text('$id');
  }
}
