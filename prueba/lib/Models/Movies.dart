import 'dart:convert';
//CLASE QUE CONTIENE LA INFORMACION QUE SE TRAE DE LA API.
// SE HACE AUTOMATICAMENTE MEDIANTE LA PAGINA WEB : https://app.quicktype.io/
// EN EL CUAL SOLO ES COPIAR Y PEGAR EL JSON RESULTANTE Y AUTOMATICAMENTE SE TRANSFORMA EN CODIGO DART.

//CLASE QUE TRAE LA INFORMACION DE TODAS LAS PELICULAS. EN ESTE EJEMPLO PUEDEN SER DE 2 TIPOS : POPULARES O MEJOR CALIFICADAS.
Movies moviesFromJson(String str) => Movies.fromJson(json.decode(str));

String moviesToJson(Movies data) => json.encode(data.toJson());

class Movies {
  Movies({
    this.page,
    this.totalResults,
    this.totalPages,
    this.results,
  });

  int page;
  int totalResults;
  int totalPages;
  List<Result> results;

  factory Movies.fromJson(Map<String, dynamic> json) => Movies(
        page: json["page"],
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "total_results": totalResults,
        "total_pages": totalPages,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
  });

  double popularity;
  int voteCount;
  bool video;
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  OriginalLanguage originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String title;
  double voteAverage;
  String overview;
  DateTime releaseDate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        popularity: json["popularity"].toDouble(),
        voteCount: json["vote_count"],
        video: json["video"],
        posterPath: json["poster_path"],
        id: json["id"],
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        originalLanguage: originalLanguageValues.map[json["original_language"]],
        originalTitle: json["original_title"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        title: json["title"],
        voteAverage: json["vote_average"].toDouble(),
        overview: json["overview"],
        releaseDate: DateTime.parse(json["release_date"]),
      );

  Map<String, dynamic> toJson() => {
        "popularity": popularity,
        "vote_count": voteCount,
        "video": video,
        "poster_path": posterPath,
        "id": id,
        "adult": adult,
        "backdrop_path": backdropPath,
        "original_language": originalLanguageValues.reverse[originalLanguage],
        "original_title": originalTitle,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "title": title,
        "vote_average": voteAverage,
        "overview": overview,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
      };
}

enum OriginalLanguage { EN, RU, KO, JA }

final originalLanguageValues = EnumValues({
  "en": OriginalLanguage.EN,
  "ja": OriginalLanguage.JA,
  "ko": OriginalLanguage.KO,
  "ru": OriginalLanguage.RU
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
