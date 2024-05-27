import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pet_dataset/model/model.dart';
import 'package:provider/provider.dart';

// ********************************************************
// New Pet
// ********************************************************
class NewPetPage extends StatefulWidget {
  const NewPetPage({super.key});

  @override
  State<NewPetPage> createState() => _NewPetPageState();
}

class _NewPetPageState extends State<NewPetPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final breedController = TextEditingController();

  Pet newPet = Pet.empty();
  String speciesErrorMessage = "";
  String sexErrorMessage = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    breedController.dispose();
    super.dispose();
  }

  bool _validateSpecies() {
    if (newPet.species == Species.none) {
      setState(() {
        speciesErrorMessage = "É gato ou cachorro?";
      });
      return false;
    } else {
      setState(() {
        speciesErrorMessage = "";
      });
      return true;
    }
  }

  bool _validateSex() {
    if (newPet.sex == Sex.none) {
      setState(() {
        sexErrorMessage = "Insira o sexo do bichinho";
      });
      return false;
    } else {
      setState(() {
        sexErrorMessage = "";
      });
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Novo Pet"),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              // *************
              // Name
              TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      hintText: "O nome do bichinho",
                      labelText: "Nome",
                      icon: Icon(Icons.abc)),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "O nome não pode ficar vazio";
                    }
                    return null;
                  }),

              // *************
              // Species
              const Text("Espécie"),
              RadioListTile<Species>(
                title: const Text("Cachorro"),
                value: Species.dog,
                groupValue: newPet.species,
                onChanged: (Species? value) {
                  setState(() {
                    newPet.species = value!;
                  });
                },
              ),
              RadioListTile<Species>(
                title: const Text("Gato"),
                value: Species.cat,
                groupValue: newPet.species,
                onChanged: (Species? value) {
                  setState(() {
                    newPet.species = value!;
                  });
                },
              ),
              Text(speciesErrorMessage, style: const TextStyle(color: Colors.red)),

              // *************
              // Sex
              const Text("Sexo"),
              RadioListTile<Sex>(
                title: const Text("Macho"),
                value: Sex.masc,
                groupValue: newPet.sex,
                onChanged: (Sex? value) {
                  setState(() {
                    newPet.sex = value!;
                  });
                },
              ),
              RadioListTile<Sex>(
                title: const Text("Fêmea"),
                value: Sex.fem,
                groupValue: newPet.sex,
                onChanged: (Sex? value) {
                  setState(() {
                    newPet.sex = value!;
                  });
                },
              ),
              Text(sexErrorMessage, style: const TextStyle(color: Colors.red)),

              // *************
              // Breed
              TextFormField(
                controller: breedController,
                decoration: const InputDecoration(
                    labelText: "Raça", icon: Icon(Icons.abc)),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Salvar',
        icon: const Icon(Icons.save),
        label: const Text("Salvar"),
        onPressed: () {
          if (_formKey.currentState!.validate() && _validateSpecies() && _validateSex()) {
            newPet.name = nameController.text;
            String breedName = breedController.text;
            newPet.breed = Breed(breedName);
            Provider.of<PetsModel>(context, listen: false).add(newPet);

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Pet salvo com sucesso")));
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

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
      tooltip: 'Increment',
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
                Text(widget.pet.species.name,
                    style: Theme.of(context).textTheme.bodyLarge)
              ],
            ),
            // Sex
            Row(
              children: [
                // const Icon(Icons.fema),
                Text(widget.pet.sex.name,
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

  Widget makeOptionsRow() {
    return const Text("Options Row");
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
        floatingActionButton: getDeleteButton());
  }
}
