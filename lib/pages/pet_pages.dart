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

  Pet new_pet = Pet.empty();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    breedController.dispose();
    super.dispose();
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
              // Nome
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
              // Espécie
              Text("Espécie"),
              RadioListTile<Species>(
                title: const Text("Cachorro"),
                value: Species.dog,
                groupValue: new_pet.species,
                onChanged: (Species? value) {
                  setState(() {
                    new_pet.species = value!;
                  });
                },
              ),
              RadioListTile<Species>(
                title: const Text("Gato"),
                value: Species.cat,
                groupValue: new_pet.species,
                onChanged: (Species? value) {
                  setState(() {
                    new_pet.species = value!;
                  });
                },
              ),

              // *************
              // Sexo
              Text("Sexo"),
              RadioListTile<Sex>(
                title: const Text("Macho"),
                value: Sex.masc,
                groupValue: new_pet.sex,
                onChanged: (Sex? value) {
                  setState(() {
                    new_pet.sex = value!;
                  });
                },
              ),
              RadioListTile<Sex>(
                title: const Text("Fêmea"),
                value: Sex.fem,
                groupValue: new_pet.sex,
                onChanged: (Sex? value) {
                  setState(() {
                    new_pet.sex = value!;
                  });
                },
              ),

              // *************
              // Nome
              TextFormField(
                controller: breedController,
                decoration: const InputDecoration(
                    labelText: "Raça", icon: Icon(Icons.abc)),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Increment',
        icon: const Icon(Icons.save),
        label: const Text("Salvar"),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            new_pet.name = nameController.text;
            String breed_name = breedController.text;
            new_pet.breed = Breed(breed_name);
            Provider.of<PetsModel>(context, listen: false).add(new_pet);

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
                    style: Theme.of(context).textTheme.displaySmall)
              ],
            ),
            // Sex
            Row(
              children: [
                Text(widget.pet.sex.name,
                    style: Theme.of(context).textTheme.displaySmall)
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
      padding: const EdgeInsets.all(24.0),
      color: Theme.of(context).colorScheme.background,
      child: Expanded(child: makeGalleryContent())
    ));
  }

  Widget makeOptionsRow() {
    return Text("Options Row");
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
