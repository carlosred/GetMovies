import 'package:flutter/cupertino.dart';
import 'package:prueba/Models/Movies.dart';

//CLASE PROVIDER DE TODA LA APP
// DONDE SE MANEJA Y SE ALOJA LA INFORMACION PARA QUE ESTE PERSISTENTE EN TODA LA APP.
//SE TIENE LOS 2 TIPOS DE PELICULAS QUE SE TRAEN DE LA API
class ModelMovies with ChangeNotifier {
  Movies app_movies;
  Movies top_rated_movies;

  get getMoviesApp => this.app_movies;

  set setMoviesApp(Movies currentMovies) {
    this.app_movies = currentMovies;
    notifyListeners();
  }

  get geTopRatedMoviesApp => this.top_rated_movies;

  set setTopRatedMoviesApp(Movies currentMovies) {
    this.top_rated_movies = currentMovies;
    notifyListeners();
  }
}
