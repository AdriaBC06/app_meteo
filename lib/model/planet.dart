import 'dart:convert';

class Planets {
  List<PlanetItem> items;
  Meta meta;
  Links links;

  Planets({
    required this.items,
    required this.meta,
    required this.links,
  });

  factory Planets.fromJson(String str) =>
      Planets.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Planets.fromMap(Map<String, dynamic> json) => Planets(
        items: List<PlanetItem>.from(
          (json["items"] ?? []).map((x) => PlanetItem.fromMap(x)),
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

class PlanetItem {
  int id;
  String name;
  bool isDestroyed;
  String description;
  String image;
  dynamic deletedAt;

  PlanetItem({
    required this.id,
    required this.name,
    required this.isDestroyed,
    required this.description,
    required this.image,
    required this.deletedAt,
  });

  factory PlanetItem.fromJson(String str) =>
      PlanetItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlanetItem.fromMap(Map<String, dynamic> json) => PlanetItem(
        id: json["id"] ?? 0,
        name: json["name"] ?? 'Unknown',
        isDestroyed: json["isDestroyed"] ?? false,
        description: json["description"] ?? '',
        image: json["image"] ?? '',
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "isDestroyed": isDestroyed,
        "description": description,
        "image": image,
        "deletedAt": deletedAt,
      };
}

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
