
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pet_dataset/model.dart';
import 'package:pet_dataset/pages/pet_pages.dart';


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
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewPetPage(pet: pet))
        );
      },
        child: Card(
            child: Column(
              children: [
                const Text("Image here..."),
                Row(
                  children: [
                    Text(pet.name),
                    pet.sex.icon
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    Provider.of<PetsModel>(context, listen: false).remove(pet);
                  },
                )
              ],
            )
        ),
    );
  }

  Widget _getPetCards() {
    return Consumer<PetsModel>(
        builder: (context, petsModel, child) {
          return GridView(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
            children: List<Widget>.generate(
                petsModel.pets.length, (int index) {
                return _petToCard(petsModel.pets[index]);
              }
            )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _getPetCards()
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Increment',
        icon: const Icon(Icons.add),
        label: const Text("Adicionar Pet"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewPetPage())
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
