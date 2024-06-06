
import 'dart:collection';

import 'package:flutter/material.dart';

import '../model/model.dart';
import '../model/persistence.dart';

class PetsController extends ChangeNotifier {
  // State
  final List<Pet> pets = [];

  // View
  UnmodifiableListView<Pet> get items => UnmodifiableListView(pets);

  void initPets(List<Pet> pets) {
    this.pets.clear();
    this.pets.addAll(pets);
    notifyListeners();
  }

  void add(Pet pet) {
    pets.add(pet);
    savePet(pet);
    notifyListeners();
  }

  void update(Pet pet, Pet newPet) {
    pet.name = newPet.name;
    pet.species = newPet.species;
    pet.sex = newPet.sex;
    pet.breed = newPet.breed;
    updatePet(pet);
    notifyListeners();
  }

  void remove(Pet pet) {
    pets.remove(pet);
    deletePet(pet);
    notifyListeners();
  }

}
