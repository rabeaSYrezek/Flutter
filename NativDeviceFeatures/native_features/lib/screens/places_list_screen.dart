import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/great_places.dart';

import '/screens/add_place_screen.dart';
import '/screens/place_details_screen.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Places',
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatePlaces>(context, listen: false).fetchAndSetPlaces(),
        builder: (ctx, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
        ? const Center(child: CircularProgressIndicator(),)
        : Consumer<GreatePlaces>(
          child: const Center(
            child: Text('Got no places yet, try adding some !'),
          ),
          builder: (ctx, greatePlaces, ch) => greatePlaces.items.length <= 0
              ? ch ?? const Center()
              : ListView.builder(
                  itemCount: greatePlaces.items.length,
                  itemBuilder: (ctx, i) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage: FileImage(greatePlaces.items[i].image),
                      ),
                      title: Text(greatePlaces.items[i].title),
                      subtitle: Text(greatePlaces.items[i].location!.address ?? ''),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                                PlaceDetails.routeName,
                                arguments: greatePlaces.items[i].id,
                              );
                      }),
                ),
        ),
      ),
    );
  }
}
