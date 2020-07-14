import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:prueba/Models/Credits.dart' as credit;

//WIDGET INDEPENDIENTE QUE TRAE A LOS ACTORES DEL CAST DE LA PELICULA
class Cast extends StatefulWidget {
  const Cast({
    Key key,
    this.widthContainer,
    this.heightContainer,
    this.actor,
  }) : super(key: key);
  final widthContainer;
  final heightContainer;
  final credit.Cast actor;

  @override
  _CastState createState() => _CastState();
}

class _CastState extends State<Cast> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: widget.heightContainer,
      width: widget.widthContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CircleAvatar(
            radius: width * 0.07,
            backgroundImage: (widget.actor.profilePath != null)
                ? NetworkImage(
                    "https://image.tmdb.org/t/p/w185" +
                        widget.actor.profilePath,
                  )
                : AssetImage("assets/desconocido.png"),
          ),
          Container(
            width: widget.widthContainer * 0.5,
            child: AutoSizeText(
              widget.actor.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.99),
                  fontSize: width * 0.04),
            ),
          )
        ],
      ),
    );
  }
}
