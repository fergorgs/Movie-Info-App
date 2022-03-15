import 'package:flutter/material.dart';
import 'package:movie_app/Views/loadingScreen.dart';
import 'package:movie_app/Controller/Controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  final Controller _con = Controller();

  bool loading = true;
  int movieId = -1;
  String title = '';
  String poster_url = '';
  String placeholder_url = 'https://d32qys9a6wm9no.cloudfront.net/images/movies/poster/500x735.png';
  var posterImg;
  var decorImg;
  

  List<List> contentData = [];
  List<Widget> contentWidgets = [];


  void buildContentWidgets(){

    for(int i = 2; i < contentData.length; i++)
    {
      contentWidgets.add(Text(
        contentData[i][0], 
        style: TextStyle(
          color: Colors.red[600], 
          fontSize: 25, 
          fontWeight: FontWeight.bold
        )
      ));
      contentWidgets.add(SizedBox(height: 8));
      contentWidgets.add(Text(
        contentData[i][1].toString(),
        style: TextStyle(
          color: Colors.grey[100], 
          fontSize: 15,
        )
      ));
      contentWidgets.add(Divider(height: 40, color: Colors.yellow[800], thickness: 2,));
    }
  }

  @override
  Widget build(BuildContext context) {

    Map data = ModalRoute.of(context)!.settings.arguments as Map;
   
    movieId = data['id'];

    if(loading){

      _con.getDetails(movieId).then((data) {
        setState(() {
          contentData = data;
          title = contentData[0][1];
          poster_url = contentData[1][1];
          
          buildContentWidgets();

          loading = false;
        });
      });

      return LoadingScreen();
    }
    else
    {
      return Container(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[900],
            title: Text('Details'),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    poster_url,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, exception, stackTrace) {
                        return Image(image: NetworkImage(placeholder_url), fit: BoxFit.fitWidth,);
                    },
                  ),
                ]
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.grey.shade800
                          ]
                        )
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 350),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[50]
                                )
                              ),
                            ),
                          ),
                        ]
                      ),
                    ),
                    Container(
                      color: Colors.grey[800],
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: contentWidgets,
                        ),
                      ),
                    )
                  ]
                )
              ),
            ],
          )          
        ),
      );
    }
  }
}