import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba/Pages/SplashScreen.dart';

// la clase principal donde se corre la app.

import 'package:prueba/ProviderModels/MoviesModel.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => ModelMovies(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prueba',
      theme: ThemeData(
        fontFamily: "Monserrat",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
