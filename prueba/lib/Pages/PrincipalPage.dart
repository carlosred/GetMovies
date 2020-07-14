import 'package:flutter/material.dart';

import 'package:prueba/ProviderModels/MoviesModel.dart';
import 'package:animate_do/animate_do.dart';
import 'package:prueba/UisWidgets/Widgets.dart';

import 'package:provider/provider.dart';

class PrincipalPage extends StatefulWidget {
  PrincipalPage({Key key}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  static GlobalKey<FormState> textfieldKeySearchBox = GlobalKey<FormState>();

  SearchBox searchBox;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // variables que referencia el ancho y alto de la pantalla para poder lograr un diseño responsive , de acuerdo a las dimensiones del movil.
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xff8dbde0),
          body: SingleChildScrollView(
            child: HomePage_movies(
                width: width,
                height: height,
                textfieldKeySearchBox: textfieldKeySearchBox),
          )),
    );
  }
}

class HomePage_movies extends StatelessWidget {
  //PANTALLA QUE CONTIENE LA PAGINA PRINCIPAL  Y SUS SUBWIGETS.
  const HomePage_movies({
    Key key,
    @required this.width,
    @required this.height,
    @required this.textfieldKeySearchBox,
  }) : super(key: key);

  final double width;
  final double height;
  final GlobalKey<FormState> textfieldKeySearchBox;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
              left: width * 0.15,
              right: width * 0.15,
              top: height * 0.07,
              child: SlideInUp(
                  delay: Duration(milliseconds: 500),
                  child: PrincipalMessage(width: width, height: height))),
          Positioned(
              top: height * 0.2,
              left: width * 0.1,
              right: width * 0.1,
              child: SlideInLeft(
                  delay: Duration(milliseconds: 700), child: SearchBox())),
          Positioned(
              bottom: 0,
              child: SlideInDown(
                delay: Duration(milliseconds: 900),
                child: MoviesContainer(
                    moviesapp: Provider.of<ModelMovies>(context, listen: false)
                        .getMoviesApp,
                    width: width,
                    height: height),
              ))
        ],
      ),
    );
  }
}
