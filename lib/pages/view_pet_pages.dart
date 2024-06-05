import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pet_dataset/model/model.dart';
import 'package:provider/provider.dart';

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
  Widget getDeleteButton() {
    return FloatingActionButton(
      tooltip: 'Deletar',
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      child: const Icon(Icons.delete),
      onPressed: () {
        Provider.of<PetsModel>(context, listen: false).remove(widget.pet);

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Pet deletado")));
        Navigator.pop(context);
      },
    );
  }

  Widget getEditButton() {
    return FloatingActionButton(
      tooltip: 'Editar',
      // backgroundColor: Colors.red,
      // foregroundColor: Colors.white,
      child: const Icon(Icons.edit),
      onPressed: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => NewPetPage(pet: widget.pet)));
        setState(() {});
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

  Widget buildPhotoTile(int index) {
    return GridTile(
        child: GestureDetector(
      onTap: () {
        // Mostrar imagem como um popup
      },
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: FileImage(File(widget.pet.photos[index].getThumbnail())),
                fit: BoxFit.cover)),
      ),
    ));
  }

  Widget makeGalleryContent() {
    if (widget.pet.photos.isEmpty) {
      return const Center(child: Text("Este pet ainda não possui fotos"));
    } else {
      return Consumer<PetsModel>(builder: (context, petsModel, child) {
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
      });
    }
  }

  Widget makeGallery() {
    return Expanded(child: Container(
      // padding: const EdgeInsets.all(24.0),
      color: Theme.of(context).colorScheme.background,
      child: makeGalleryContent()
    ));
  }

  void _showDeleteDialog() async {
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
                Provider.of<PetsModel>(context, listen: false).remove(widget.pet);
                Navigator.pop(context); // Return to previous screen
              },
            ),
          ],
        );
      },
    );
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
              _showDeleteDialog();
            },
          ),
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
              children: [
                makeDescription(),
                makeGallery(),
                makeOptionsRow()
              ],
            )),
        floatingActionButton: getEditButton());
  }
}
