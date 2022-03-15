import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:movie_app/Models/movieCatalog.dart';

class Controller extends ControllerMVC{

  factory Controller([StateMVC? state]) => _this ??= Controller._(state);
  Controller._(StateMVC? state)
      : _model = MovieCatalog(),
        super(state);
  static Controller? _this;

  final MovieCatalog _model;

  Future<List<Map>> get previews => _model.getPreviews();

  Future<List<List>> getDetails(int id) async{
    
    Map rawContent = await _model.getDetails(id);
    
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

    List<List> displayableContent = [
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

    

    return displayableContent;

  }
    


}