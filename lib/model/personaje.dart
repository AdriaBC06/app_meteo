import 'dart:convert';

class Personaje {
  List<Item> items;
  Meta meta;
  Links links;

  Personaje({
    required this.items,
    required this.meta,
    required this.links,
  });

  factory Personaje.fromJson(String str) =>
      Personaje.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Personaje.fromMap(Map<String, dynamic> json) => Personaje(
        items: List<Item>.from(
          (json["items"] ?? []).map((x) => Item.fromMap(x)),
        ),
        meta: Meta.fromMap(json["meta"] ?? {}),
        links: Links.fromMap(json["links"] ?? {}),
      );

  Map<String, dynamic> toMap() => {
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
        "meta": meta.toMap(),
        "links": links.toMap(),
      };
}

class Item {
  int id;
  String name;
  String ki;
  String maxKi;
  String race;
  Gender gender;
  String description;
  String image;
  Affiliation affiliation;
  dynamic deletedAt;

  Item({
    required this.id,
    required this.name,
    required this.ki,
    required this.maxKi,
    required this.race,
    required this.gender,
    required this.description,
    required this.image,
    required this.affiliation,
    required this.deletedAt,
  });

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        id: json["id"] ?? 0,
        name: json["name"] ?? 'Desconocido',
        ki: json["ki"]?.toString() ?? '',
        maxKi: json["maxKi"]?.toString() ?? '',
        race: json["race"] ?? 'Unknown',
        gender: genderValues.map[json["gender"]] ?? Gender.MALE,
        description: json["description"] ?? '',
        image: json["image"] ?? '',
        affiliation: affiliationValues.map[json["affiliation"]] ??
            Affiliation.FREELANCER,
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "ki": ki,
        "maxKi": maxKi,
        "race": race,
        "gender": genderValues.reverse[gender],
        "description": description,
        "image": image,
        "affiliation": affiliationValues.reverse[affiliation],
        "deletedAt": deletedAt,
      };
}

enum Affiliation { ARMY_OF_FRIEZA, FREELANCER, Z_FIGHTER }

final affiliationValues = EnumValues({
  "Army of Frieza": Affiliation.ARMY_OF_FRIEZA,
  "Freelancer": Affiliation.FREELANCER,
  "Z Fighter": Affiliation.Z_FIGHTER
});

enum Gender { FEMALE, MALE }

final genderValues = EnumValues({
  "Female": Gender.FEMALE,
  "Male": Gender.MALE,
});

class Links {
  String first;
  String previous;
  String next;
  String last;

  Links({
    required this.first,
    required this.previous,
    required this.next,
    required this.last,
  });

  factory Links.fromJson(String str) => Links.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Links.fromMap(Map<String, dynamic> json) => Links(
        first: json["first"] ?? '',
        previous: json["previous"] ?? '',
        next: json["next"] ?? '',
        last: json["last"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "first": first,
        "previous": previous,
        "next": next,
        "last": last,
      };
}

class Meta {
  int totalItems;
  int itemCount;
  int itemsPerPage;
  int totalPages;
  int currentPage;

  Meta({
    required this.totalItems,
    required this.itemCount,
    required this.itemsPerPage,
    required this.totalPages,
    required this.currentPage,
  });

  factory Meta.fromJson(String str) => Meta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
        totalItems: json["totalItems"] ?? 0,
        itemCount: json["itemCount"] ?? 0,
        itemsPerPage: json["itemsPerPage"] ?? 0,
        totalPages: json["totalPages"] ?? 0,
        currentPage: json["currentPage"] ?? 1,
      );

  Map<String, dynamic> toMap() => {
        "totalItems": totalItems,
        "itemCount": itemCount,
        "itemsPerPage": itemsPerPage,
        "totalPages": totalPages,
        "currentPage": currentPage,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
