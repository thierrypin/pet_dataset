import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pet_dataset/pages/take_picture_page.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pet_dataset/model/persistence.dart';
import 'package:pet_dataset/model/model.dart';
import 'package:tuple/tuple.dart';
import '../control/pets_control.dart';
import 'new_pet_page.dart';

// ********************************************************
// View Pet
// ********************************************************
class ViewPetPage extends StatefulWidget {
  const ViewPetPage({super.key, required this.pet});

  final Pet pet;

  @override
  State<ViewPetPage> createState() => _ViewPetPageState();
}

class _ViewPetPageState extends State<ViewPetPage> {
  late final List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    //availableCameras().then((cameraList) => cameras = cameraList);
    // ImagePicker.platform.
  }

  Widget getDeleteButton() {
    return FloatingActionButton(
      tooltip: 'Deletar',
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      child: const Icon(Icons.delete),
      onPressed: () {
        Provider.of<PetsController>(context, listen: false).remove(widget.pet);

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Pet deletado")));
        Navigator.pop(context);
      },
    );
  }

  Widget makeDescription() {
    return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Name
            Row(
              children: [
                Text(
                  widget.pet.name,
                  style: Theme.of(context).textTheme.displayMedium,
                )
              ],
            ),
            // Species
            Row(
              children: [
                Text(widget.pet.species.prettyName,
                    style: Theme.of(context).textTheme.bodyLarge)
              ],
            ),
            // Sex
            Row(
              children: [
                // const Icon(Icons.fema),
                Text(widget.pet.sex.prettyName,
                    style: Theme.of(context).textTheme.bodyLarge)
              ],
            ),
            // Breed
            Row(
              children: [
                Text("Raça: ${widget.pet.breed!.name}",
                    style: Theme.of(context).textTheme.bodyLarge)
              ],
            ),
          ],
        ));
  }

  void showDeletePhotoDialog(int photoIdx) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("Deletar imagem?"),
          content: const Text("Esta ação não poderá ser desfeita"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("Não"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("Sim"),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                // Provider.of<PetsController>(context, listen: false).remove(widget.pet);
                deletePhoto(widget.pet, photoIdx);
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildPhotoTile(int index) {
    var tuple = getPhoto(widget.pet.photos[index].getThumbnail());
    double aspect = tuple.item2.toDouble() / tuple.item3.toDouble();
    return GridTile(
        child: GestureDetector(
      onTap: () async {
        print("apertou");
        await showDialog(
            context: context,
            builder: (_) => ImageDialog(path: widget.pet.photos[index].path));
      },
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: FileImage(File(widget.pet.photos[index].getThumbnail())),
                fit: BoxFit.cover)),
        child: AspectRatio(
            aspectRatio: aspect,
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.delete_forever),
                color: Colors.red,
                onPressed: () => showDeletePhotoDialog(index),
              ),
            )),
      ),
    ));
  }

  Widget makeGalleryContent() {
    if (widget.pet.photos.isEmpty) {
      return const Center(child: Text("Este pet ainda não possui fotos"));
    } else {
      return GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          children:
              List<Widget>.generate(widget.pet.photos.length, (int index) {
            return buildPhotoTile(index);
          }));
    }
  }

  Widget makeGallery() {
    return Expanded(
        child: Container(
            // padding: const EdgeInsets.all(24.0),
            color: Theme.of(context).colorScheme.surface,
            child: makeGalleryContent()));
  }

  void showDeletePetDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Deletar ${widget.pet.name}?"),
          content: const Text("Esta ação não poderá ser desfeita"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("Não"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("Sim"),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Provider.of<PetsController>(context, listen: false)
                    .remove(widget.pet);
                Navigator.pop(context); // Return to previous screen
              },
            ),
          ],
        );
      },
    );
  }

  // Widget getEditButton() {
  //   return FloatingActionButton(
  //     tooltip: 'Editar',
  //     // backgroundColor: Colors.red,
  //     // foregroundColor: Colors.white,
  //     child: const Icon(Icons.edit),
  //     onPressed: () async {
  //       await Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => NewPetPage(pet: widget.pet)));
  //       setState(() {});
  //     },
  //   );
  // }

  void takePhoto() async {
    var cameras = await availableCameras();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(camera: cameras.first)));
  }

  void pickPhoto() {
    Future<List<XFile?>> f = ImagePicker()
        .pickMultiImage(maxHeight: 1080.0, maxWidth: 1920.0, imageQuality: 80);
    f.then((List<XFile?> files) {
      for (var xfile in files) {
        if (xfile != null) {
          setState(() {
            addPhoto(widget.pet, File(xfile.path));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Não foi possível adicionar a imagem")));
        }
      }
    });
  }

  Widget makeOptionsRow() {
    return Row(
      children: [
        Expanded(
          child: IconButton(
            color: Colors.red,
            icon: const Icon(Icons.delete_forever),
            tooltip: "Deletar pet",
            onPressed: () {
              showDeletePetDialog();
            },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Editar",
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewPetPage(pet: widget.pet)));
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.camera),
            tooltip: "Adicionar da câmera",
            onPressed: () => takePhoto(),
          ),
        ),
        Expanded(
          child: IconButton(
              icon: const Icon(Icons.photo_album),
              tooltip: "Adicionar da galeria",
              onPressed: () => pickPhoto()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.pet.name),
      ),
      body: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [makeDescription(), makeGallery(), makeOptionsRow()],
          )),
      // floatingActionButton: getEditButton()
    );
  }
}

class ImageDialog extends StatefulWidget {
  final String path;

  const ImageDialog({super.key, required this.path});

  @override
  State<StatefulWidget> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  late final Future<Tuple3<List<int>, num, num>> photo;
  double aspect = 0;

  Future<Tuple3<List<int>, num, num>> loadPhoto() async {
    var tuple = getPhoto(widget.path);
    aspect = tuple.item2.toDouble() / tuple.item3.toDouble();

    return tuple;
  }

  @override
  void initState() {
    super.initState();
    photo = loadPhoto();
  }

  Widget makeImageViewer(tuple) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: MemoryImage(Uint8List.fromList(tuple.item1)),
        fit: BoxFit.cover,
      )),
      child: AspectRatio(
          aspectRatio: aspect,
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.cancel),
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
            ),
          )),
    );
  }

  Widget makeFutureImageViewer() {
    return FutureBuilder(
        future: photo,
        builder: (ctx, snapshot) {
          // Checking if future is resolved
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: const TextStyle(fontSize: 18),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              return makeImageViewer(snapshot.data);
            }
          }

          // Displaying LoadingSpinner to indicate waiting state
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(child: makeFutureImageViewer());
  }
}
