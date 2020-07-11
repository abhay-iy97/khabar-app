import 'dart:ui';
import 'package:flutter/material.dart';

// class Note {
//   String title;
//   String text;
//   Image X;
//   Note(this.title, this.text, this.X);

//   Note.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     text = json['description'];
//     X = Image.network(json['articles'][0]['urlToImage']);
//   }
// }
class Note {
  String title;
  String text;

  Note(this.title, this.text);

  Note.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['description'];
  }
}
