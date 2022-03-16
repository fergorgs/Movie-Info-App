import 'package:flutter/material.dart';
import 'package:movie_app/Views/loadingScreen.dart';
import 'package:movie_app/Controller/Controller.dart';
import 'package:movie_app/Views/failedToLoadScreen.dart';
import 'package:flutter/scheduler.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  final Controller _con = Controller();

  bool loading = true;
  bool failedToLoad = false;
  String errorMessage = '';
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
      if(contentData[i][1] == '')
        continue;

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
    
  void refreshPage(){

    try
    {
      _con.getDetails(movieId).then((data) {

        print('Received data: ');
        print(data);
        if(data.length <= 1 || data[data.length-1][0] != null)
        {
          setState(() {
            if(data[data.length-1][0] == 'socket')
              errorMessage = 'No internet connection!';
            else
              errorMessage = 'We are having some dificulties, please try again latter';
            loading = false;
            failedToLoad = true;
          });
        }
        else
        {
          data.removeLast();
          setState(() {
            contentData = data;
            title = contentData[0][1];
            poster_url = contentData[1][1];
            print('Poster url:');
            print(poster_url);
            
            buildContentWidgets();

            loading = false;
          });
        }
      });
    } 
    catch(e) 
    {
      failedToLoad = true;
    }
  }

  Widget getPageBody(){

    if(loading){

      print('Trying to load for movie id: ' + movieId.toString());
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
            Future.delayed(const Duration(milliseconds: 500), () {});
            refreshPage();
          }
        );
      else
      {
        return Stack(
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
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
   
    movieId = data['id'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Details'),
        centerTitle: true,
      ),
      body: getPageBody(),
    );
  }
}