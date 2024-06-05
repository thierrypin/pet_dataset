
import 'dart:io';
import 'dart:convert';

import 'package:image/image.dart' as pimg;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';

import 'model.dart';

Future<Directory> getPetDir(Pet pet) async {
  Directory basepath = await getApplicationDocumentsDirectory();
  return Directory(join(basepath.path, pet.localId.toString().padLeft(6, '0')));
}

void savePet(Pet pet) async {
  var prefs = await SharedPreferences.getInstance();

  int? localId = prefs.getInt('id_counter');
  if (localId == null) {
    prefs.setInt("id_counter", 0);
    localId = 0;
  }

  pet.localId = localId;
  print("Local id: $localId");

  // Make pet directory
  Directory directory = await getPetDir(pet);
  // Directory basepath = await getApplicationDocumentsDirectory();
  // Directory directory = Directory(join(basepath.path, pet.localId.toString().padLeft(6, '0')));
  await directory.create();
  print(directory.path);

  // Populate json
  File f = File('${directory.path}/info.json');
  f.writeAsString(json.encode(pet.toJson()));

  prefs.setInt("id_counter", localId + 1);
}

void updatePet(Pet pet) async {
  // Make pet directory
  Directory directory = await getPetDir(pet);
  // Directory basepath = await getApplicationDocumentsDirectory();
  // Directory directory = Directory(join(basepath.path, pet.localId.toString().padLeft(6, '0')));
  print(directory.path);

  // Populate json
  File f = File('${directory.path}/info.json');
  f.writeAsString(json.encode(pet.toJson()));
}

void deletePet(Pet pet) async {
  Directory directory = await getPetDir(pet);
  await directory.delete(recursive: true);
}

Future<List<Pet>> loadPets() async {
  Directory directory = await getApplicationDocumentsDirectory();
  print(directory);
  List<Directory> petDirs = List<Directory>.empty(growable: true);

  for (FileSystemEntity e in directory.listSync()) {
    if (e is Directory) {
      petDirs.add(e);
    }
  }

  List<Pet> pets = List<Pet>.empty(growable: true);
  // A Valid pet is a folder having a info.json file
  for (Directory dir in petDirs) {
    File f = File('${dir.path}/info.json');
    bool exists = await f.exists();
    if (exists) {
      String contents = await f.readAsString();
      Pet pet = Pet.fromJson(json.decode(contents));
      // pet.photos = List<Photo>.empty();
      //
      // // Load images
      // for (FileSystemEntity e in dir.listSync()) {
      //   if (e is File && (e.path.endsWith(".png") || e.path.endsWith(".jpg"))) {
      //     pet.photos.add(Photo(path: e.path));
      //   }
      // }

      pets.add(pet);
    }
  }

  return pets;
}

//void populateThumbnails(Pet pet) {
//  if (pet.photos.length > pet.thumbnails.length) {
//    for (int i = pet.thumbnails.length; i < pet.photos.length; i++) {
//      String img = pet.photos[i];
//      print(img);
//      pimg.Image image = pimg.decodeImage(File(img).readAsBytesSync());
//      print("${image.width}x${image.height}");
//
//      // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
//
//      pet.addThumbnail(pimg.encodePng(thumbnail));
//    }
//  }
//}

void addPhoto(Pet pet, dynamic f) {
  File file;
  if (f is String) {
    file = File(f);
  } else if (f is File) {
    file = f;
  } else {
    throw("addPhoto arguments can only be String or File");
  }

  Future<String> res = persistImage(pet, file);

  res.then((value) {
    pet.photos.add(Photo(path: value));
  });
}

void deletePhoto(Pet pet, int idx) {
  File file = File(pet.photos[idx].path);
  file.delete(recursive: false);

  file = File(pet.photos[idx].getThumbnail());
  file.delete(recursive: false);

  pet.photos.remove(idx);
}

// Returns a Tuple3 with: encoded image, width, height
Tuple3<List<int>, num, num> getPhoto(dynamic f) {
  File file;
  if (f is String) {
    file = File(f);
  } else if (f is File) {
    file = f;
  } else {
    throw("getPhoto arguments can only be String or File");
  }

  pimg.Image? image = pimg.decodeImage(file.readAsBytesSync());

  return Tuple3<List<int>, num, num>(pimg.encodePng(image!), image.width, image.height);
}

Future<String> persistImage(Pet pet, File file) async {
  String newPath = join(await getPetPath(pet), '${DateTime.now()}.png').replaceAll(" ", "_");
  file.copy(newPath);

  pimg.Image? image = pimg.decodeImage(file.readAsBytesSync());
  pimg.Image thumbnail = pimg.copyResize(image!, width: 150, height: 150);

  File fileThumb = File("$newPath.thumbnail.png");
  fileThumb.writeAsBytesSync(pimg.encodePng(thumbnail));

  return newPath;
}

Future<String> getPetPath(Pet pet) async {
  Directory directory = await getApplicationDocumentsDirectory();

  return join(directory.path, pet.localId.toString().padLeft(6, '0'));
}

