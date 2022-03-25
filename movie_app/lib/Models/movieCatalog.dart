import 'package:movie_app/Models/dataFetcher.dart';
import 'package:movie_app/Models/movie.dart';

// MOVIE CATALOG
// controla as informações armazenadas em cache dos filmes
//solicita para o dataFecther novas informações quando necessário
class MovieCatalog{

  DataFetcher fetcher = new DataFetcher();

  // mantem um hashset com o id de todos os filmes que já possuem suas informações detalhadas armazenadas em cache
  // mantem um hashmap com o id dos filmes como chave e um objeto filme como valor contendo as infos do filme com aquele id
  static Set<int> cachedMovies = {};
  static Map<int, Movie> movies = {};

  // apiFetchPreviews
  // solicita para o dataFecther as informações resumidas de todos os filmes
  // dada as informações recebidas, converte-as em objetos 'Movie' e salva-os
  // no hashmap 'movies'
  Future<void> apiFetchPreviews() async{

    List movieDatas = [];
    await fetcher.fetchAllMovies().then((value) {movieDatas = value;});

    movieDatas.forEach((movieData) {

      Movie movie = new Movie.fromPreviewJson(movieData);
      movies[movie.id] = movie;
    });
  }

  // apiFetchDetails
  // dado um id, solicita para o dataFetcher as informações detalhadas daquele filme
  // cria um novo objeto 'Movie' a partir das informações recebidas e substitui o objeto antigo representante daquele filme no hashmap 'movies'
  // salva o id do filme no hashset, indicando que aquele filme possui a partir de agora as informações salvas em cache,
  // e por isso não precisam ser recarregadas
  Future<void> apiFetchDetails(int id) async{

    Map movieData = {};
    await fetcher.fetchMovie(id).then((value) {movieData = value;});
    Movie movie = new Movie.fromCompleteJson(movieData);
    movies[movie.id] = movie;
    cachedMovies.add(movie.id);
  }

  // getPreviews
  // retorna uma lista de mapas, cada um representando um objeto 'movie'
  Future<List<Map>> getPreviews() async{

    // se o hashmap de cache está vazio, solicita ao dataFetcher novos dados
    if(movies.isEmpty)
      await apiFetchPreviews();

    // itera sobre o hashmap de cache e converte cada objeto movie em um mapa
    List<Map> movieMaps = [];
    movies.forEach((key, value) => movieMaps.add(value.convertToMap()));

    // retorna uma lisata com os mapas
    return movieMaps;
  }

  // getDetails
  // retorna um mapa representando o objeto 'movie' com o id correspondente
  Future<Map> getDetails(int id) async{

    print('LOG: (movieCatalog) retreiving details for movie of id: ' + id.toString());
    
    // se o hashmap de cache está vazio, solicita ao dataFetcher novos dados
    if(movies.isEmpty)
      await apiFetchPreviews();
    
    // se o id do filme não consta no hashset, significa que aquele filme ainda não tem em cache suas informações
    // detalhadas, apenas suas informações resumidas. Por isso, solicita ao dataFetcher os dados detalhados
    if(!cachedMovies.contains(id))
      await apiFetchDetails(id);
    
    // retorna um mapa correspondente ao obejto 'movie' do filme com aquele id
    return movies[id]!.convertToMap();
  }

}