
import 'dart:collection';

import 'package:flutter/material.dart';

enum Species { none, cat, dog }
extension SpeciesExtension on Species {
  String get name {
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
  String get name {
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
  String name;
  String? desc;

  Breed(this.name);
}

class Photo {
  static const String suffix = ".thumbnail.png";
  bool uploaded = false;
  String path;

  Photo({this.uploaded=false, required this.path});

  Photo.fromJson(Map<String, dynamic> json) :
        uploaded = json['edited'], path = json['path'];

  String getThumbnail() {
    return path + suffix;
  }

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

  Pet.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    breed = json['breed'];
    species = Species.values.byName(json['species']);
    sex = Sex.values.byName(json['sex']);

    // Set photos
    photos = json['photos'].map((Map<String, dynamic> e) {
      return Photo.fromJson(e);
    });

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
      'breed': breed,
      'species': species.name,
      'sex': sex.name,
      'photos': photosJson,
    };

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
    return "🐕";
  } else {
    return "👽";
  }
}

class PetsModel extends ChangeNotifier {
  // State
  final List<Pet> pets = [];

  // View
  UnmodifiableListView<Pet> get items => UnmodifiableListView(pets);

  void add(Pet pet) {
    pets.add(pet);
    notifyListeners();
  }

  void remove(Pet pet) {
    pets.remove(pet);
    notifyListeners();
  }

}

