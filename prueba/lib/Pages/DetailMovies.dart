import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:prueba/Models/Credits.dart' as credit;
import 'package:prueba/Models/DetailMovies.dart' as detail;
import 'package:prueba/Models/Movies.dart';
import 'package:prueba/UisWidgets/Cast.dart';
import 'package:prueba/UisWidgets/Movie.dart';
import 'package:prueba/UisWidgets/Widgets.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

//  PANTALLA QUE TIENE LOS DETALLES DE LA PELICULA SELECCIONADA
//ESTA CONFORMADA POR 2 STATEFULWIDGETS , 1 PARA TRAER LOS DATOS Y CON EL OTRO SE MUESTRAN LOS DETALLES , SE DIVIDEN EN 2 PARA HACER MAS FACIL LA LECTURA DEL
// CODIGO.
class DetailMovie extends StatefulWidget {
  DetailMovie({Key key, @required this.movie}) : super(key: key);
  final Result movie; // ESTA ES LA INSTANCIA DE LA PELICULA SELECCIONADA
  @override
  _DetailMovieState createState() => _DetailMovieState();
}

class _DetailMovieState extends State<DetailMovie> {
  credit.Credits creditos; // CREDITOS DE LA PELICULA
  detail.DetailMovies detalles; // DETALLES DE LA PELICULA
  // METODO QUE TRAE LOS DETALLES O CREDITOS DEPENDIENDO DE UNA BANDERA
  Future<bool> getCastorDetails(bool isCast) async {
    if (isCast) {
      bool has_cast = false;
      var id = widget.movie.id;
      Map<String, String> headers = {"Content-type": "application/json"};
      String url =
          "https://api.themoviedb.org/3/movie/$id/credits?api_key=73e422795d39514dab23ecf3c23a8ab1";

      //print(json);
      Response response = await get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        creditos = credit.creditsFromJson(response.body);
        has_cast = true;
      } else {}

      return has_cast;
    } else {
      bool has_details = false;
      var id = widget.movie.id;
      Map<String, String> headers = {"Content-type": "application/json"};
      String url =
          "https://api.themoviedb.org/3/movie/$id?api_key=73e422795d39514dab23ecf3c23a8ab1&language=en-US";

      //print(json);
      Response response = await get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        detalles = detail.detailMoviesFromJson(response.body);
        has_details = true;
      } else {
        // No es boilerPlate , no se puede minimizar o extraer este widget debido a que es un metodo que se renderiza al llegar a esta seccion de codigo
        // y muestra este flushbar ,posiblemente no lo vean ,es un caso en el que esta cargando los datos y la internet se va o algo por el estilo.
        // la pongo en caso tal que el metodo post o get fallen. para indicar al usuario.
        // es decir , se debe poner todo
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          title: "Carga Interrumpida!",
          message: "Por favor revisa tu conexion de internet o datos",
          backgroundColor: Colors.red,
          boxShadows: [
            BoxShadow(
              color: Colors.yellow[600],
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          icon: Icon(
            Icons.error_outline,
            size: 28.0,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.white,
        )..show(context);
      }
      return has_details;
    }
  }

// METODO EN EL CUAL SE REALIZA OPERACION ASINCRONA PARA ESPERAR QUE LOS DATOS VENGAN DE LA API.
  Future<bool> getDetails() async {
    try {
      await getCastorDetails(true);
      await getCastorDetails(false);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: FutureBuilder<bool>(
            future: getDetails(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // aqui se pinta o muestra el mapa
                return DetailScreen(
                  height: height,
                  width: width,
                  widget: widget,
                  creditos: creditos,
                  detalles: detalles,
                );
              } else {
                return Loading(
                  width: width,
                );
              }
            }));
  }
}

// PANTALLA DONDE ESTA UBICADA CADA UNO DE LOS COMPONENTES O WIDGETS QUE SE MUESTRAN EN PANTALLA
class DetailScreen extends StatefulWidget {
  const DetailScreen({
    Key key,
    @required this.height,
    @required this.width,
    @required this.widget,
    @required this.creditos,
    @required this.detalles,
  }) : super(key: key);
// SIEMPRE SE RECIBE HEIGHT Y WIDTH PARA QUE SEA RESPONSIVE
  final double height;
  final double width;
  final DetailMovie widget;
  final credit.Credits creditos;
  final detail.DetailMovies detalles;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool favorite = false;
  // METODO QUE PERMITE VER LA PAGINA DE LA PELICULA , O HOMEPAGE QUE TRAE LA API THE MOVIE
  watchMovie(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo acceder $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: widget.height * 1.2,
        width: widget.width,
        color: Color(0xff2C3848),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                height: widget.height * 0.45,
                width: widget.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(widget.width * 0.07),
                      bottomRight: Radius.circular(widget.width * 0.07)),
                  child: Image.network(
                      "https://image.tmdb.org/t/p/w500" +
                          widget.widget.movie.backdropPath,
                      fit: BoxFit.fitHeight),
                ),
              ),
            ),
            Positioned(
                top: widget.height * 0.05,
                left: widget.width * 0.07,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: widget.width * 0.09,
                  ),
                )),
            Positioned(
                top: widget.height * 0.05,
                right: widget.width * 0.07,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      favorite = !favorite;
                    });
                  },
                  child: (favorite)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: widget.width * 0.09,
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: widget.width * 0.09,
                        ),
                )),
            Positioned(
                top: widget.height * 0.5,
                left: widget.width * 0.05,
                child: Container(
                  width: widget.width * 0.9,
                  height: widget.height * 0.05,
                  child: AutoSizeText(
                    widget.widget.movie.title,
                    style: TextStyle(
                        fontSize: widget.width * 0.06,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )),
            Positioned(
                top: widget.height * 0.55,
                left: widget.width * 0.03,
                child: GestureDetector(
                  onTap: () {
                    watchMovie(widget.detalles.homepage);
                  },
                  child: Container(
                    height: widget.height * 0.05,
                    width: widget.width * 0.35,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.width * 0.1))),
                    child: Center(
                      child: Text(
                        "WATCH NOW",
                        style: TextStyle(
                            fontSize: widget.width * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )),
            Positioned(
                top: widget.height * 0.559,
                right: 0,
                child: Container(
                  height: widget.height * 0.05,
                  width: widget.width * 0.35,
                  child: SmoothStarRating(
                    size: widget.width * 0.05,
                    color: Colors.yellow,
                    isReadOnly: true,
                    rating: getrating(widget.widget.movie.voteAverage),
                    borderColor: Colors.yellow.withOpacity(0.8),
                  ),
                )),
            Positioned(
                top: widget.height * 0.62,
                child: Container(
                  width: widget.width,
                  height: widget.height * 0.2,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: widget.width * 0.05,
                          right: widget.width * 0.05),
                      child: AutoSizeText(
                        widget.widget.movie.overview,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: widget.width * 0.04),
                      ),
                    ),
                  ),
                )),
            Positioned(
                bottom: 0,
                child: Container(
                  width: widget.width,
                  height: widget.height * 0.35,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.creditos.cast.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  List<credit.Cast> actors =
                                      widget.creditos.cast;

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Cast(
                                      widthContainer: widget.width * 0.3,
                                      actor: actors[index],
                                    ),
                                  );
                                }),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                    left: widget.width * 0.05,
                                    bottom: widget.height * 0.12,
                                    child: Text(
                                      "Studio",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: widget.width * 0.04),
                                    )),
                                Positioned(
                                    left: widget.width * 0.2,
                                    bottom: widget.height * 0.12,
                                    child: (widget.detalles.productionCompanies
                                            .isNotEmpty)
                                        ? Text(
                                            widget.detalles.productionCompanies
                                                .elementAt(0)
                                                .name,
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                fontSize: widget.width * 0.04),
                                          )
                                        : Text(
                                            "Unknown",
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                fontSize: widget.width * 0.04),
                                          )),
                                Positioned(
                                    left: widget.width * 0.05,
                                    bottom: widget.height * 0.08,
                                    child: Text(
                                      "Genre",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: widget.width * 0.04),
                                    )),
                                Positioned(
                                    left: widget.width * 0.2,
                                    bottom: widget.height * 0.08,
                                    child: Text(
                                      widget.detalles.genres
                                          .map((e) => e.name)
                                          .join(","),
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: widget.width * 0.04),
                                    )),
                                Positioned(
                                    left: widget.width * 0.05,
                                    bottom: widget.height * 0.04,
                                    child: Text(
                                      "Release",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: widget.width * 0.04),
                                    )),
                                Positioned(
                                    left: widget.width * 0.25,
                                    bottom: widget.height * 0.04,
                                    child: Text(
                                      widget.detalles.releaseDate.year
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: widget.width * 0.04),
                                    )),
                              ],
                            ),
                          ))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
