import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:prueba/Models/Movies.dart';
import 'package:prueba/Pages/DetailMovies.dart';
import 'package:prueba/ProviderModels/MoviesModel.dart';
import 'package:prueba/UisWidgets/Movie.dart';

//CLASE QUE CONTIENE LOS WIDGETS INDEPENDIENTES QUE PUEDEN SER REUTILIZADOS EN OTRAS PANTALLAS
// O QUE SIMPLEMENTE SE EXTRAEN Y SE PONEN AQUI PARA QUE NO SE VEA TAN SPAGUETTI EL CODIGO EN LAS PANTALLAS PRINCIPALES
// DEBIDO A QUE ESO DIFICULTA SU LECTURA. =( CREANME , ME HA TOCADO... ES FEO.
class PrincipalMessage extends StatelessWidget {
  //WIDGET QUE CONTIENE EL MENSAJE DE SALUDO
  const PrincipalMessage({
    Key key,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width * 0.8,
        height: height * 0.1,
        child: Text(
          "Hello, what do you want to watch?",
          style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.07,
              fontFamily: "Montserrat"),
        ));
  }
}

class SearchBox extends StatelessWidget {
  // ESTE ES EL SEARCHBOX
  SearchBox({
    Key key,
    this.textfieldKey,
  }) : super(key: key);

  final GlobalKey<FormState> textfieldKey;
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.8,
      height: height * 0.05,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(width * 0.1))),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Icon(
                Icons.search,
                color: Colors.white,
              )),
          Expanded(
            flex: 5,
            child: TextField(
              key: textfieldKey,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search movie",
                  hintStyle: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class MoviesContainer extends StatefulWidget {
  // ESTE ES EL CONTENEDOR DONDE SE ENCUENTRAN LAS PELICULAS SEPARADAS POR RECOMENDADAS Y MEJOR CALIFICADAS
  MoviesContainer({
    Key key,
    @required this.width,
    @required this.height,
    @required this.moviesapp,
  }) : super(key: key);

  final double width;
  final double height;
  final Movies moviesapp;

  @override
  _MoviesContainerState createState() => _MoviesContainerState();
}

class _MoviesContainerState extends State<MoviesContainer> {
  Movies topratedMovies;
  @override
  void initState() {
    //Debido a que en el estado general de la app ya esta seteado las Top Rated Movies , no la pasamos como parametro , sino que solamente , se devuelve su valor
    // para ser utilizada.
    topratedMovies =
        Provider.of<ModelMovies>(context, listen: false).geTopRatedMoviesApp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xff2C3848),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.width * 0.09),
              topRight: Radius.circular(widget.width * 0.09))),
      height: widget.height * 0.7,
      width: widget.width,
      child: Padding(
        padding: EdgeInsets.only(
            top: widget.width * 0.1,
            left: widget.width * 0.01,
            bottom: widget.width * 0.03),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TypeMoviesContainer(
                width: widget.width,
                height: widget.height,
                moviesapp: widget.moviesapp,
                type: "RECOMMENDEND FOR YOU",
              ),
            ),
            Expanded(
              flex: 1,
              child: TypeMoviesContainer(
                width: widget.width,
                height: widget.height,
                moviesapp: topratedMovies,
                type: "TOP RATED",
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TypeMoviesContainer extends StatelessWidget {
  // ESTE WIDGET ES LO QUE CONTIENE CADA UNA DE LOS "TIPOS" DE PELICULAS EN ESTE CASO RECOMENDADAS Y MEJORES CALIFICADAS ,
  //EL WIDGET DE ARRIBA TIENE 2 INSTANCIAS DE ESTE WIDGET UNO JUNTO AL OTRO.
  const TypeMoviesContainer({
    Key key,
    @required this.width,
    @required this.height,
    @required this.moviesapp,
    @required this.type,
  }) : super(key: key);

  final double width;
  final double height;
  final Movies moviesapp;
  final type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        height: height * 0.35,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      type,
                      style: TextStyle(
                        fontSize: width * 0.045,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "See all",
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 5,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: moviesapp.results.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      List<Result> movies = moviesapp.results;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailMovie(
                                      movie: movies[index],
                                    )),
                          );
                        },
                        child: MovieCard(
                          widthContainer: width * 0.4,
                          heightContainer: width * 0.315,
                          movie: movies[index],
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  //PANTALLA DE INICIO O DE CARGA , LA QUE SE MUESTRA MIENTRAS SE ESPERA QUE CARGUEN LOS DATOS
  const Loading({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff8dbde0),
      body: Container(
        child: Center(
          child: HeartbeatProgressIndicator(
            child: RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "GET",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.07,
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                    text: "MOVIES",
                    style: TextStyle(
                      color: Color(0xff2C3848),
                      fontSize: width * 0.07,
                      fontWeight: FontWeight.bold,
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class NoConnectionWidget extends StatelessWidget {
  // EN CASO DE QUE NO HAYA CONEXION , SE MOSTRARA ESTE WIDGET
  const NoConnectionWidget({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff8dbde0),
      body: Container(
        child: Center(
          child: RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: "NO TIENES ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.07,
                    fontWeight: FontWeight.bold,
                  )),
              TextSpan(
                  text: "INTERNET =( ",
                  style: TextStyle(
                    color: Color(0xff2C3848),
                    fontSize: width * 0.07,
                    fontWeight: FontWeight.bold,
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}
