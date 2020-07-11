import 'dart:ui';
import 'package:flutter/material.dart';

class Note {
  String title;
  String text;
  Image X;
  Note(this.title, this.text, this.X);

  Note.fromJson(Map<String, dynamic> json) {
    title = json['articles'][0]['title'];
    text = json['articles'][0]['description'];
    X = Image.network(json['articles'][0]['urlToImage']);
  }
}
