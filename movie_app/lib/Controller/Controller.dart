import 'dart:io';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:movie_app/Models/movieCatalog.dart';

class Controller extends ControllerMVC{

  factory Controller([StateMVC? state]) => _this ??= Controller._(state);
  Controller._(StateMVC? state)
      : _model = MovieCatalog(),
        super(state);
  static Controller? _this;

  final MovieCatalog _model;

  Future<List<Map>> get previews async{

    List<Map> res = [];
    
    try
    {
     res = await _model.getPreviews();
    }
    on SocketException
    {
      print('Received socket exception');
      res.add({'error' : 'socket'});
      return res;
    }
    on Exception
    {
      print('Received generic exception');
      res.add({'error' : 'generic'});
      return res;
    }
      
    res.add({'error' : null});
    return res;
    // return _model.getPreviews();
  }

  Future<List<List>> getDetails(int id) async{
    
    List<List> displayableContent = [];
    Map rawContent = {};
    
    try{
      rawContent = await _model.getDetails(id);
    }
    on SocketException
    {
      displayableContent.add(['socket']);
      return displayableContent;
    }
    on Exception
    {
      displayableContent.add(['generic']);
      return displayableContent;
    }

    print('LOG: (Controller) received back details');

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

    String imdbUrl = 'https://www.imdb.com/title/' + rawContent['imdb_id'];

    displayableContent = [
      ['Title', rawContent['title']],
      ['Poster url', rawContent['poster_url']],
      ['Rating', rawContent['vote_avg']],
      ['Production year', rawContent['production_year']],
      ['Overview', rawContent['overview']],
      ['Spoken Languages', spokenLangs],
      ['Shoot in', countries],
      ['IMDb page', imdbUrl],
      ['Genres', genres]
    ];

    displayableContent.add([null]);    

    return displayableContent;

  }
    


}