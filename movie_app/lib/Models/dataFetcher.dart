import 'package:http/http.dart' as http;
import 'dart:convert';

class DataFetcher{

  String endPoint = 'https://desafio-mobile.nyc3.digitaloceanspaces.com/movies';

  Future<List> fetchAllMovies() async{

    print('LOG: (dataFetcher) Fetching previews data');
    var res = await http.get(Uri.parse(endPoint));
    return json.decode(res.body);
  }

  Future<Map> fetchMovie(int id) async{

    print('LOG: (dataFetcher) Fetching details for movie of id: ' + id.toString());
    var res = await http.get(Uri.parse(endPoint + '/' + id.toString()));
    return json.decode(res.body);
    // var url = Uri.parse(endPoint + '/' + id.toString());
    // var res = await http.get(url);
    // return jsonDecode(utf8.decode(res.bodyBytes)) as Map;
  }
}