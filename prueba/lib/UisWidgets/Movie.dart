import 'package:flutter/material.dart';
import 'package:prueba/Models/Movies.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

//WIDGET INDEPENDIENTE QUE TRAE LAS PELICULAS DE LA API , Y DIBUJA LA FOTO Y ELNOMBRE Y LAS ESTRELLAS
class MovieCard extends StatelessWidget {
  MovieCard(
      {Key key,
      @required this.widthContainer,
      @required this.heightContainer,
      @required this.movie})
      : super(key: key);

  final widthContainer;
  final heightContainer;
  final Result movie;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
        height: heightContainer,
        width: widthContainer,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(width * 0.05),
                child: Image.network(
                    "https://image.tmdb.org/t/p/w185" + movie.posterPath,
                    width: width * 0.35,
                    fit: BoxFit.fitWidth),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.03,
                  top: width * 0.015,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    movie.title,
                    style: TextStyle(
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.03,
                    ),
                    child: SmoothStarRating(
                      size: width * 0.05,
                      color: Colors.yellow,
                      isReadOnly: true,
                      rating: getrating(movie.voteAverage),
                      borderColor: Colors.yellow.withOpacity(0.8),
                    ),
                  ),
                ))
          ],
        ));
  }
}

double getrating(double rat) {
  return (5.0 * rat) / 10.0;
}
