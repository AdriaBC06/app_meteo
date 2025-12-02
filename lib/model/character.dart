import 'package:meta/meta.dart';
import 'dart:convert';

class NowPlayingResponse {
    List<Item> items;
    Meta meta;
    Links links;

    NowPlayingResponse({
        required this.items,
        required this.meta,
        required this.links,
    });

    factory NowPlayingResponse.fromRawJson(String str) => NowPlayingResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory NowPlayingResponse.fromJson(Map<String, dynamic> json) => NowPlayingResponse(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
        links: Links.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "meta": meta.toJson(),
        "links": links.toJson(),
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

    factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        ki: json["ki"],
        maxKi: json["maxKi"],
        race: json["race"],
        gender: genderValues.map[json["gender"]]!,
        description: json["description"],
        image: json["image"],
        affiliation: affiliationValues.map[json["affiliation"]]!,
        deletedAt: json["deletedAt"],
    );

    Map<String, dynamic> toJson() => {
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

enum Affiliation {
    ARMY_OF_FRIEZA,
    FREELANCER,
    Z_FIGHTER
}

final affiliationValues = EnumValues({
    "Army of Frieza": Affiliation.ARMY_OF_FRIEZA,
    "Freelancer": Affiliation.FREELANCER,
    "Z Fighter": Affiliation.Z_FIGHTER
});

enum Gender {
    FEMALE,
    MALE
}

final genderValues = EnumValues({
    "Female": Gender.FEMALE,
    "Male": Gender.MALE
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

    factory Links.fromRawJson(String str) => Links.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        previous: json["previous"],
        next: json["next"],
        last: json["last"],
    );

    Map<String, dynamic> toJson() => {
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

    factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        totalItems: json["totalItems"],
        itemCount: json["itemCount"],
        itemsPerPage: json["itemsPerPage"],
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
    );

    Map<String, dynamic> toJson() => {
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
