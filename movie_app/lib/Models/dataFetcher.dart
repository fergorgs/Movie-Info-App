import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

// DATA FETCHER
// se comunica com a API que contem as infos dos filmes
class DataFetcher{

  String endPoint = 'https://desafio-mobile.nyc3.digitaloceanspaces.com/movies';

  // fetchAllMovies
  // busca as informações resumidas de todos os filmes
  // converte as informações em uma lista de mapas json
  // trata qualquer excessão como uma socket exception
  Future<List> fetchAllMovies() async{

    print('LOG: (dataFetcher) Fetching previews data');
    var jsonResponse;
    try
    {
      var res = await http.get(Uri.parse(endPoint));
      jsonResponse = json.decode(res.body);
    }
    on Exception
    {
      print('LOG: (dataFetcher) Caught exception');
      throw SocketException('Network error');
    }

    return jsonResponse;
  }

  // fetchMovie
  // busca as informações detalhadas de um filme expecifico
  // converte as informações em um mapa json
  // trata qualquer excessão como uma socket exception
  Future<Map> fetchMovie(int id) async{

    print('LOG: (dataFetcher) Fetching details for movie of id: ' + id.toString());
    var jsonResponse;
    try
    {
      var res = await http.get(Uri.parse(endPoint + '/' + id.toString()));
      jsonResponse = json.decode(res.body);
    }
    on Exception
    {
      throw SocketException('Network error');
    }

    return jsonResponse;
  }
}