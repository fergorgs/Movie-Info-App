import 'package:flutter/material.dart';
import 'package:movie_app/Controller/Controller.dart';
import 'package:movie_app/Views/movieCard.dart';
import 'package:movie_app/Views/loadingScreen.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool loading = true;
  final Controller _con = Controller();
  List<Map> movieDatas = [];
  List<Widget> movieCards = [];

  void buildMovieCards(){

    movieDatas.forEach((movie) {

      MovieCard card = MovieCard(
        id: movie['id'],
        title: movie['title'],
        poster_url: movie['poster_url'],
        vote_average: movie['vote_avg'],
        production_year: movie['production_year'],
        genres: movie['genres'],
      );

      movieCards.add(card);
    });
  }

  @override
  void initState() {
    super.initState();
    _con.previews.then((value) {
      
      setState(() {
        movieDatas = value;
        buildMovieCards();
        loading = false;
        } 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if(loading)
      return LoadingScreen();
    else
    {
      return SingleChildScrollView(
        child: Container(
          color: Colors.grey[800],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.grey[900],
                padding: EdgeInsets.all(15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 30,
                  ),
                )
              ),
              SizedBox(height: 20),
              Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 30,
                    fontStyle: FontStyle.italic
                  ),
                  child: Text('Top movies from the last decades'),
                ),
              ),
              Container(
                color: Colors.grey[800],
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: movieCards,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}