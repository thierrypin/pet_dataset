

import 'package:flutter/material.dart';

enum Species { none, cat, dog }
extension SpeciesExtension on Species {
  String get prettyName {
    switch (this) {
      case Species.cat:
        return 'Gato';
      case Species.dog:
        return 'Cachorro';
      default:
        return 'Desconhecido';
    }
  }
  String get emoji {
    switch(this) {
      case Species.cat:
        return '🐱';
      case Species.dog:
        return '🐕';
      default:
        return '👽';
    }
  }
}


enum Sex { none, masc, fem }
extension SexExtension on Sex {
  String get prettyName {
    switch (this) {
      case Sex.masc:
        return 'Macho';
      case Sex.fem:
        return 'Femea';
      default:
        return 'Desconhecido';
    }
  }

  Icon get icon {
    switch (this) {
      case Sex.masc:
        return const Icon(Icons.male);
      case Sex.fem:
        return const Icon(Icons.female);
      default:
        return const Icon(Icons.question_mark);
    }
  }
}

class Breed {
  late String name;
  String? desc;

  Breed(this.name);
  Breed.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json.containsKey('desc')) {
      desc = json['desc'];
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> out = {
      'name': name
    };

    if (desc != null) {
      out['desc'] = desc;
    }

    return out;
  }
}

class Photo {
  static const String suffix = ".thumbnail.png";
  bool uploaded = false;
  String path;

  Photo({this.uploaded=false, required this.path});

  String getThumbnail() {
    return path + suffix;
  }

  Photo.fromJson(Map<String, dynamic> json) :
        uploaded = json['uploaded'], path = json['path'];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> out = {
      "path": path,
      "uploaded": uploaded,
    };

    return out;
  }
}

class Pet {
  int? id;
  int? localId;
  String name = "";
  Species species = Species.none;
  Sex sex = Sex.none;
  Breed? breed;
  List<Photo> photos = [];

  Pet.empty();
  Pet(this.name, this.species, this.sex, this.breed);

  void addPhoto(Photo photo) {
    photos.add(photo);
  }

  void removePhoto(int i) {
    photos.removeAt(i);
  }

  Pet.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    species = Species.values.byName(json['species']);
    sex = Sex.values.byName(json['sex']);

    // Set photos
    for (var jsonPhoto in json['photos']) {
      photos.add(Photo.fromJson(jsonPhoto));
    }
    // photos = json['photos'].map((Map<String, dynamic> e) => Photo.fromJson(e));
    
    if (json.containsKey('breed')) {
      breed = Breed.fromJson(json['breed']);
    }
    if (json.containsKey('localId')) {
      localId = json['localId'];
    }
    if (json.containsKey('id')) {
      id = json['id'];
    }
  }

  Map<String, dynamic> toJson({bool local=true}) {
    var photosJson = photos.map((Photo p) => p.toJson()).toList();

    Map<String, dynamic> out = {
      'name': name,
      'species': species.name,
      'sex': sex.name,
      'photos': photosJson,
    };

    if (breed != null) {
      out['breed'] = breed!.toJson();
    }
    if (localId != null) {
      out['localId'] = localId;
    }
    if (id != null) {
      out['id'] = id;
    }

    return out;
  }

}

String getPetEmoji(Species petType) {
  if (petType == Species.cat) {
    return "🐱";
  } else if (petType == Species.dog) {
    return "🐶";
  } else {
    return "👽";
  }
}
