import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_app/Views/loadingScreen.dart';
import 'package:movie_app/Controller/Controller.dart';
import 'package:movie_app/Views/failedToLoadScreen.dart';
import 'package:flutter/scheduler.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

// TELA DE DETALHES----------------------------------------------------------------
// EXibe todos as informações detalhadas de um filme específico
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

  // buildContentWidgets
  // dada uma lista de informções sobre o filme
  // constroi uma lista de widgets para exibir essas informações
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
    
  void refreshPage() async{

    // esse await tem um propósito apenas estético. Ele força que a tela de carregamento
    // seja exibida por pelo menos meio segundo. Remover isso pode fazer com que o usuário
    // tenha a impressão que o botão de recarregar a página ('retry') não está funcionando
    await Future.delayed(const Duration(milliseconds: 500), () {});

    // solicita ao controlador que forneça os dados do filme
    // se bem sucedido, atualiza a tela e exibe os dados
    _con.getDetails(movieId).then((data) {

        setState(() {
          contentData = data;
          title = contentData[0][1];
          poster_url = contentData[1][1];
          buildContentWidgets();
          loading = false;
        });

    // se ocorre um erro, exibe a tela de erro junta à mensagem apropriada de acordo
    // com o tipo de erro
    }).catchError((error) {
    
      if(error.runtimeType == SocketException)
      {
        setState(() {
          errorMessage = 'No internet connection!';
          loading = false;
          failedToLoad = true;
        });
      }
      else
      {
        setState(() {
          errorMessage = 'We are having some dificulties, please try again latter';
          loading = false;
          failedToLoad = true;
        });
      }
    });
  }

  // getBody
  // determina e retorna o Widget que será o corpo da página
  Widget getPageBody(){

    if(loading)
    {
      refreshPage();
      return LoadingScreen();
    }
    else
    {
      // se a operação get falhou, exibe a tela de erro com a mensagem apropriada
      if(failedToLoad)
        return FailedToLoadScreen(
          errorMessage, 
          () {
            setState(() {
              loading = true;
              failedToLoad = false;
            });
            refreshPage();
          }
        );
      else
      {
        // se houver sucesso, exibe os detalhes do filme
        return Stack(
          children: [
            // Imagem de fundo
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  poster_url,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, exception, stackTrace) {
                      return Image(image: AssetImage('assets/placeHolderPoster.png'));
                  },
                ),
              ]
            ),
            // frontground da tela
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
                  
                  // lista de informações----------------------------
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
    
    // recebendo dados passados pela rota
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