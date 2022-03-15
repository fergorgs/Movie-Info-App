import 'package:flutter/material.dart';
import 'package:movie_app/Controller/Controller.dart';
import 'package:movie_app/Views/homeScreen.dart';
import 'package:movie_app/Views/detailsScreen.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

void main() {
  // runApp(
  //   MaterialApp(
  //     home: Debug(),
  //   )
  // );
  runApp(
    MaterialApp(
      initialRoute:  '/home',
      routes: {
        '/': (context) => Text('Root'),// LoadingScreen(),
        '/home': (context) => HomeScreen(),
        '/details': (context) => DetailsScreen(),
      }
    )
  );
}

class Debug extends StatelessWidget {
  
  // MovieCatalog cat = new MovieCatalog();
  Controller con = new Controller();

  void debugOp() async{

    var res = await con.previews;
    print(res);
    // await cat.getPreviews().then((val) {res = val;});
    // await cat.getPreviews().then((val) {res = val;});
    // await cat.getDetails(19404).then((val) {res = val;});
    // await cat.getDetails(19404).then((val) {res = val;});
    // print(res);
  }

  @override
  Widget build(BuildContext context) {

    debugOp();
    return Container(
      child: Text('Debug app'),
    );
  }
}