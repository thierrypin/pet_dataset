
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

  String getThumbnail() {
    return path + suffix;
  }
}

class Pet {
  String name = "";
  Species species = Species.none;
  Sex sex = Sex.none;
  Breed? breed;
  List<Photo> photos = [];

  Pet.empty();
  Pet(this.name, this.species, this.sex, this.breed);

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

