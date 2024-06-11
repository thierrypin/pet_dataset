

import 'package:flutter/material.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 1,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: const Text('Pet Dataset'),
          ),
          ListTile(
            title: const Text("Instruções"),
            onTap: () => {},
          ),
          ListTile(
            title: const Text("Sobre"),
            onTap: () => {},
          )
        ],
      ),
    );
  }
}
