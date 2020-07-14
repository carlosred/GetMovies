import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba/Models/Movies.dart';
import 'package:prueba/Pages/PrincipalPage.dart';
import 'package:prueba/ProviderModels/MoviesModel.dart';
import 'package:prueba/UisWidgets/Widgets.dart';

// PANTALLA INICIAL DONDE SE MUESTRA EL LOGO DE LA APP , MIENTRAS ESTA CARGA LOS DATOS INICIALES , QUE SON LAS PELICULAS
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool hasinternet = true;
  // METODO PARA VERIFICAR QUE EL USUARIO TENGA CONEXION A INTERNET
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  void loadingMovies() async {
    //condicional en el que se verifica si tiene internet o no  y de acuerdo a eso , se ejecuta un setstate para cambiar la vista.
    check().then((intenet) async {
      if (intenet != null && intenet) {
        //si tiene internet
        await getMovies(false);

        await getMovies(true);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => PrincipalPage()));
      } else {
        // no tiene internet
        setState(() {
          hasinternet = !hasinternet;
        });
      }
    });
  }

  Future<bool> getMovies(bool topRated) async {
    bool cargo = false;
    // una simple bandera para que se llenen los 2 tipos de peliculas 1: Popular , 2: Top Rated Movies.
    if (topRated == true) {
      Map<String, String> headers = {"Content-type": "application/json"};
      String url =
          "https://api.themoviedb.org/3/movie/top_rated?api_key=73e422795d39514dab23ecf3c23a8ab1";

      //print(json);
      Response response = await get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        Movies movies = moviesFromJson(response.body);

        Provider.of<ModelMovies>(context, listen: false).setTopRatedMoviesApp =
            movies;

        cargo = true;
      } else {}
    } else {
      Map<String, String> headers = {"Content-type": "application/json"};
      String url =
          "https://api.themoviedb.org/3/movie/popular?api_key=73e422795d39514dab23ecf3c23a8ab1";

      //print(json);
      Response response = await post(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        Movies movies = moviesFromJson(response.body);

        Provider.of<ModelMovies>(context, listen: false).setMoviesApp = movies;

        cargo = true;
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
    }
    return cargo;
  }

  @override
  void initState() {
    super.initState();
    loadingMovies();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return (hasinternet)
        ? Loading(width: width)
        : NoConnectionWidget(width: width);
  }
}
