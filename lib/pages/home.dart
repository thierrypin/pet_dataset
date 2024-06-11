import 'package:flutter/material.dart';
import 'package:pet_dataset/pages/drawer.dart';
import 'package:provider/provider.dart';

import 'package:pet_dataset/model/model.dart';
import 'package:pet_dataset/pages/view_pet_pages.dart';

import '../control/pets_control.dart';
import 'new_pet_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _petToCard(Pet pet) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ViewPetPage(pet: pet)));
      },
      child: Card(
          child: Column(
          children: [
            const Spacer(),
            const Text("Sem imagens"),
            const Spacer(),
            Row(
              children: [
                Text(pet.name),
                const Spacer(),
                pet.sex.icon,
                Text(getPetEmoji(pet.species)),
            ],
          ),
        ],
      )),
    );
  }

  Widget _getPetCards() {
    return Consumer<PetsController>(builder: (context, petsModel, child) {
      return GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          children: petsModel.pets.map((pet) => _petToCard(pet)).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const MyDrawer(),
      body: Center(child: _getPetCards()),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Increment',
        icon: const Icon(Icons.add),
        label: const Text("Adicionar Pet"),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewPetPage()));
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
