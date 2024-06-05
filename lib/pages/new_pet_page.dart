
import 'package:flutter/material.dart';
import 'package:pet_dataset/model/model.dart';
import 'package:pet_dataset/pages/view_pet_pages.dart';
import 'package:provider/provider.dart';


// ********************************************************
// New Pet
// ********************************************************
class NewPetPage extends StatefulWidget {
  const NewPetPage({super.key, this.pet});

  final Pet? pet;

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
  bool isNew = true;

  @override
  void initState() {
    super.initState();

    if (widget.pet != null) {
      newPet = widget.pet!;
      isNew = false;
      nameController.text = newPet.name;
      breedController.text = newPet.breed?.name ?? "";
    }
  }

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
            newPet.breed = Breed(breedController.text);

            if (isNew) {
              Provider.of<PetsModel>(context, listen: false).add(newPet);

              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pet salvo com sucesso")));
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPetPage(pet: newPet)));
            } else {
              Provider.of<PetsModel>(context, listen: false).update(widget.pet!, newPet);

              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pet salvo com sucesso")));
              Navigator.pop(context);
              setState(() {});
            }
          }
        },
      ),
    );
  }
}
