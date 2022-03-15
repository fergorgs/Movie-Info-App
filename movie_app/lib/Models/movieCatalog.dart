import 'package:movie_app/Models/dataFetcher.dart';
import 'package:movie_app/Models/movie.dart';

class MovieCatalog{

  DataFetcher fetcher = new DataFetcher();

  Set<int> cachedMovies = {};
  Map<int, Movie> movies = {};

  Future<void> apiFetchPreviews() async{

    List movieDatas = [];
    await fetcher.fetchAllMovies().then((value) {movieDatas = value;});

    movieDatas.forEach((movieData) {

      Movie movie = new Movie.fromPreviewJson(movieData);
      movies[movie.id] = movie;
    });
  }

  Future<void> apiFetchDetails(int id) async{
    // fetch that movie's data
    // create a new movie object from that data
    // replace the old movie object with the new one on the movies map
    // add current movie's id to the cached list
    Map movieData = {};
    await fetcher.fetchMovie(id).then((value) {movieData = value;});
    Movie movie = new Movie.fromCompleteJson(movieData);
    movies[movie.id] = movie;
    cachedMovies.add(movie.id);
  }

  Future<List<Map>> getPreviews() async{

    print('LOG: (movieCatalog) retreiving previews for all movies');
    // if there are no movies what so ever
      // fetchPreviews
    if(movies.isEmpty)
      await apiFetchPreviews();

    // create a new list
    // for each movie object present in the movies list
    // convert it into a map format and add it to the new list
    // return the new list
    List<Map> movieMaps = [];
    movies.forEach((key, value) => movieMaps.add(value.convertToMap()));

    return movieMaps;
  }

  Future<Map> getDetails(int id) async{

    print('LOG: (movieCatalog) retreiving details for movie of id: ' + id.toString());
    // if there are no movies what so ever
      // fetchPreviews
    if(movies.isEmpty)
      await apiFetchPreviews();
    
    // if the requested movie is not cached
      // fetchDetails
    if(!cachedMovies.contains(id))
      await apiFetchDetails(id);
    
    // get the requested movie from the map
    // convert it into a map format
    // return the map
    return movies[id]!.convertToMap();
  }

}