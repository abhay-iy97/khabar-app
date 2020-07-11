import 'dart:ui';
import 'package:flutter/material.dart';

class Note {
  String title;
  String text;
  Image X;
  String image;
  Note(this.title, this.text, this.X);

  Note.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['description'];
    X = Image.network(json['urlToImage']);
    image = json['urlToImage'];
  }
}
// class Note {
//   String title;
//   String text;

//   Note(this.title, this.text);

//   Note.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     text = json['description'];
//   }
// }
