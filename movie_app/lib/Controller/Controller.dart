import 'dart:io';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:movie_app/Models/movieCatalog.dart';

// CONTROLADOR
// Faz a interface entre as telas (Views) e as classes de dados (Models)
class Controller extends ControllerMVC{

  factory Controller([StateMVC? state]) => _this ??= Controller._(state);
  Controller._(StateMVC? state)
      : _model = MovieCatalog(),
        super(state);
  static Controller? _this;

  final MovieCatalog _model;

  // getPreviews
  // solicita ao model as informações resumidas dos filmes
  // se necessário, filtra as informações de acordo com os parâmetros
  // definidos pelo usuário
  Future<List<Map>> getPreviews(List genres) async{

    List<Map> res = [];
    List<Map> filteredRes = [];
    
    // solicita as informações ao model
    // trata qualquer excessão
    try
    {
     res = await _model.getPreviews();
    }
    on SocketException
    {
      print('LOG: (Controller) Caught socket exception');
      throw SocketException('Socket exception');
    }
    on Exception
    {
      print('LOG: (Controller) Caught generic exception');
      throw Exception('Exception');
    }
    
    // se nenhum gênero foi selecionado, retorna todos os filmes
    // sem filtrar nada
    if(genres.length == 0)
      return res;

    // caso contrário, itera sobre os filmes, mantendo na lista que 
    // será retornada apenas aqueles que contém pelo menos um dos gêneros
    // indicados pelo usuário
    for(int i = 0; i < res.length; i++)
    {
      var movie = res[i];

      for(int j = 0; j < movie['genres'].length; j++)
      {
        var genre = movie['genres'][j];
        if(genres.contains(genre))
        {
          filteredRes.add(movie);
          break;
        }
      }
    }
      
    return filteredRes;
  }


  // getDetails
  // solicita ao model as informações detalhadas de um determinado filme
  // processa e reorganiza os dados recebidos, e deixa-os no formato esperado pelo front
  // imprime no console qualuqer excessão detectada
  Future<List<List>> getDetails(int id) async{
    
    List<List> displayableContent = [];
    Map rawContent = {};
    
    // solicita as informações e trata excessões
    try{
      rawContent = await _model.getDetails(id);
    }
    on SocketException
    {
      print('LOG: (Controller) Caught socket exception');
      throw SocketException('Socket exception');
    }
    on Exception
    {
      print('LOG: (Controller) Caught generic exception');
      throw Exception('Exception');
    }

    print('LOG: (Controller) received back details');

    // converte as listas de linguas, paises e generos em strings 
    // que podem ser exibidas ao usuário
    String spokenLangs = '';
    rawContent['spoken_languages'].forEach((lang) {
      spokenLangs += lang['name'] + ', ';
    });
    spokenLangs = spokenLangs.substring(0, spokenLangs.length-2);

    String countries = '';
    rawContent['production_countries'].forEach((country) {
      countries += country['name'] + ', ';
    });
    countries = countries.substring(0, countries.length-2);

    String genres = '';
    rawContent['genres'].forEach((genre) {
      genres += genre + ', ';
    });
    genres = genres.substring(0, genres.length-2);

    // forma a url da imdb
    String imdbUrl = 'https://www.imdb.com/title/' + rawContent['imdb_id'];

    // estrutura a lista com as informações num formato esperado pelo front
    var aux = [
      ['Title', rawContent['title']],
      ['Poster url', rawContent['poster_url']],
      ['Rating', rawContent['vote_avg']],
      ['Production year', rawContent['production_year']],
      ['Overview', rawContent['overview']],
      ['Spoken Languages', spokenLangs],
      ['Shot in', countries],
      ['IMDb page', imdbUrl],
      ['Genres', genres]
    ];

    aux.forEach((pair) {

      if(pair[1] != null && pair[1] != '')
        displayableContent.add(pair);
    });

    return displayableContent;
  }
}