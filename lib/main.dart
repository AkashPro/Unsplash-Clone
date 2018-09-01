import 'package:flutter/material.dart';
import 'ui/home.dart';

void main(){
  runApp(new MaterialApp(
    title: "Unsplah Clone",
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
  ));
}