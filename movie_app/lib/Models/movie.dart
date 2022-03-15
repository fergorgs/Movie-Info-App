

class Movie{

  int id = -1;
  String backdrop_url = '';
  List genres = [];
  String imdb_id = '';
  String overview = '';
  double popularity = -1;
  String poster_url = '';
  List production_countries = [];
  String production_year = '';
  int runtime = -1;
  List spoken_languages = [];
  String title = '';
  String tagline = '';
  double vote_avg = -1;
  int vote_count = -1;

  Movie(
    this.id,
    this.backdrop_url,
    this.genres,
    this.imdb_id,
    this.overview,
    this.popularity,
    this.poster_url,
    this.production_countries,
    this.production_year,
    this.runtime,
    this.spoken_languages,
    this.title,
    this.tagline,
    this.vote_avg,
    this.vote_count
  );

  Movie.fromCompleteJson(Map json){
    id = json['id'];
    backdrop_url = json['backdrop_url'];
    genres = json['genres'];
    imdb_id = json['imdb_id'];
    overview = json['overview'];
    popularity = json['popularity'];
    poster_url = json['poster_url'];
    production_countries = json['production_countries'];
    production_year = json['release_date'].substring(0, 4);
    runtime = json['runtime'];
    spoken_languages = json['spoken_languages'];
    title = json['title'];
    tagline = json['tagline'];
    vote_avg = json['vote_average'];
    vote_count = json['vote_count'];
  }

  Movie.fromPreviewJson(Map json){
    id = json['id'];
    vote_avg = json['vote_average'];
    title = json['title'];
    poster_url = json['poster_url'];
    genres = json['genres'];
    production_year = json['release_date'].substring(0, 4);
  }

  Map convertToMap(){

    Map converted = {
      'id': id,
      'backdrop_url': backdrop_url,
      'genres': genres,
      'imdb_id': imdb_id,
      'overview': overview,
      'popularity': popularity,
      'poster_url': poster_url,
      'production_countries': production_countries,
      'production_year': production_year,
      'runtime': runtime,
      'spoken_languages': spoken_languages,
      'title': title,
      'tagline': tagline,
      'vote_avg': vote_avg,
      'vote_count': vote_count
    };
    
    return converted;
  }
}