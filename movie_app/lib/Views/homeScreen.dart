import 'package:flutter/material.dart';
import 'package:movie_app/Controller/Controller.dart';
import 'package:movie_app/Views/movieCard.dart';
import 'package:movie_app/Views/loadingScreen.dart';
import 'package:movie_app/Views/failedToLoadScreen.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool loading = true;
  bool failedToLoad = false;
  String errorMessage = '';
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

  void refreshPage(){
    try{
      _con.previews.then((res) {

        if(res.length <= 1 || res[res.length-1]['error'] != null)
        {
          setState(() {
            if(res[res.length-1]['error'] == 'socket')
              errorMessage = 'No internet connection!';
            else
              errorMessage = 'We are having some dificulties, please try again latter';
            loading = false;
            failedToLoad = true;
          });
        }
        else
        {
          res.removeLast();
          setState(() {
            movieDatas = res;
            buildMovieCards();
            loading = false;
            } 
          );
        }
      });
    } 
    catch(e) 
    {
      failedToLoad = true;
    }
  }

  Widget getPageBody(){
    if(loading)
    {
      refreshPage();
      return LoadingScreen();
    }
    else
    {
      if(failedToLoad)
        return FailedToLoadScreen(
          errorMessage, 
          () {
            setState(() {
              loading = true;
              failedToLoad = false;
            });
            // Future.delayed(const Duration(milliseconds: 500), () {});
            refreshPage();
          }
        );
      else
      {
        return SingleChildScrollView(
          child: Container(
            color: Colors.grey[800],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Center(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 20,
                      fontStyle: FontStyle.italic
                    ),
                    child: Text('Great movies from the last decades'),
                  ),
                ),
                Container(
                  color: Colors.grey[800],
                  child: Padding(
                    padding: const EdgeInsets.all(2),
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[900],
        toolbarHeight: 70,
        actions: [
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0,0,20,0),
          //   child: IconButton(
          //     onPressed: () {print('pressed');},
          //     iconSize: 35,
          //     icon: Icon(Icons.filter_alt_sharp)
          //   ),
          // )
        ],
        title: CircleAvatar(
          radius: 35,
          backgroundColor: Colors.grey[900],
          child: Image.asset('movieIcon.png'),
        )
      ),
      body: getPageBody(),
    );
  }
}