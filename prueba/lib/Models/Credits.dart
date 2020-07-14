//CLASE QUE CONTIENE LA INFORMACION QUE SE TRAE DE LA API.
// SE HACE AUTOMATICAMENTE MEDIANTE LA PAGINA WEB : https://app.quicktype.io/
// EN EL CUAL SOLO ES COPIAR Y PEGAR EL JSON RESULTANTE Y AUTOMATICAMENTE SE TRANSFORMA EN CODIGO DART.

//CLASE QUE TRAE LOS CREDITOS DE LA PELICULA QUE HAYAMOS ESCODIGO PARA VERLA DETALLADAMENTE.
// AQUI SE TRAEN EL CAST DE LA PELICULA
import 'dart:convert';

Credits creditsFromJson(String str) => Credits.fromJson(json.decode(str));

String creditsToJson(Credits data) => json.encode(data.toJson());

class Credits {
  Credits({
    this.id,
    this.cast,
    this.crew,
  });

  int id;
  List<Cast> cast;
  List<Crew> crew;

  factory Credits.fromJson(Map<String, dynamic> json) => Credits(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Crew>.from(json["crew"].map((x) => Crew.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
      };
}

class Cast {
  Cast({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        castId: json["cast_id"],
        character: json["character"],
        creditId: json["credit_id"],
        gender: json["gender"],
        id: json["id"],
        name: json["name"],
        order: json["order"],
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "cast_id": castId,
        "character": character,
        "credit_id": creditId,
        "gender": gender,
        "id": id,
        "name": name,
        "order": order,
        "profile_path": profilePath == null ? null : profilePath,
      };
}

class Crew {
  Crew({
    this.creditId,
    this.department,
    this.gender,
    this.id,
    this.job,
    this.name,
    this.profilePath,
  });

  String creditId;
  Department department;
  int gender;
  int id;
  String job;
  String name;
  String profilePath;

  factory Crew.fromJson(Map<String, dynamic> json) => Crew(
        creditId: json["credit_id"],
        department: departmentValues.map[json["department"]],
        gender: json["gender"],
        id: json["id"],
        job: json["job"],
        name: json["name"],
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "credit_id": creditId,
        "department": departmentValues.reverse[department],
        "gender": gender,
        "id": id,
        "job": job,
        "name": name,
        "profile_path": profilePath == null ? null : profilePath,
      };
}

enum Department {
  PRODUCTION,
  CREW,
  COSTUME_MAKE_UP,
  DIRECTING,
  SOUND,
  ART,
  EDITING,
  WRITING,
  VISUAL_EFFECTS
}

final departmentValues = EnumValues({
  "Art": Department.ART,
  "Costume & Make-Up": Department.COSTUME_MAKE_UP,
  "Crew": Department.CREW,
  "Directing": Department.DIRECTING,
  "Editing": Department.EDITING,
  "Production": Department.PRODUCTION,
  "Sound": Department.SOUND,
  "Visual Effects": Department.VISUAL_EFFECTS,
  "Writing": Department.WRITING
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
