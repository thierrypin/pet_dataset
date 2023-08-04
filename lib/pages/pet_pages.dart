import 'package:flutter/material.dart';
import 'package:pet_dataset/model.dart';
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
                  icon: Icon(Icons.abc)
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "O nome não pode ficar vazio";
                  }
                  return null;
                }
              ),

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
                      labelText: "Raça",
                      icon: Icon(Icons.abc)
                  ),
              ),
            ],
          )
        ),
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
                const SnackBar(content: Text("Pet salvo com sucesso"))
            );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.pet.name),
      ),
      body: Center(
          child: Column(
            children: [
              Text("Nome: ${widget.pet.name}"),
              Text(widget.pet.species.name),
              Text(widget.pet.sex.name),
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: const Icon(Icons.delete),
        onPressed: () {
          Provider.of<PetsModel>(context, listen: false).remove(widget.pet);

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Pet deletado"))
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}




