import 'package:flutter/material.dart';
import 'package:movie_app/Views/homeScreen.dart';
import 'package:movie_app/Views/detailsScreen.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute:  '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/details': (context) => DetailsScreen(),
      }
    )
  );
}