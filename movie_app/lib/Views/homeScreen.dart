import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_app/Controller/Controller.dart';
import 'package:movie_app/Views/movieCard.dart';
import 'package:movie_app/Views/loadingScreen.dart';
import 'package:movie_app/Views/failedToLoadScreen.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

// TELA PRINCIPAL-----------------------------------------------------------------------
// Lista detalhes resumidos dos filmes e permite acesso à tela de detalhes de cada filme
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

  // buildMovieCards
  // dada uma lista com os dados dos filmes
  // constroi uma lista de widgets que serão os cards para cada filme
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

  // refreshPage
  // solicita ao controlador que forneça os dados dos filmes
  void refreshPage() async{

    // esse await tem um propósito apenas estético. Ele força que a tela de carregamento
    // seja exibida por pelo menos meio segundo. Remover isso pode fazer com que o usuário
    // tenha a impressão que o botão de recarregar a página ('retry') não está funcionando
    await Future.delayed(const Duration(milliseconds: 500), () {});
    
    // solicita ao controlador que forneça os dados dos filmes
    // se bem sucedido, atualiza a tela e exibe os dados
    _con.previews.then((res) {

        setState(() {
          movieDatas = res;
          buildMovieCards();
          loading = false;
          } 
        );

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

    // se 'loading', busca os dados dos filmes
    // enquanto a operação não conclui, exibe a tela de 'carregando'
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
        // se houve sucesso, exibe a lista de filmes
        return SingleChildScrollView(
          child: Container(
            color: Colors.grey[800],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                
                // título no topo da pagina-----------
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

                // lista de filmes-------------------
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
      // Appbar com o logo e um botão de filtragem (a ser feito)
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

      // corpo
      body: getPageBody(),
    );
  }
}