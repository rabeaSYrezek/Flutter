import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/great_places.dart';
import '/screens/map_screen.dart';
import '/models/place.dart';

class PlaceDetails extends StatelessWidget {
  static const routeName = '/place-details';

  const PlaceDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final selectedPlace =
        Provider.of<GreatePlaces>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            selectedPlace.location!.address ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.grey),
          ),
          const SizedBox(
            height: 10,
          ),
          // FlatButton(child: const Text('View on map'),
          // textColor: Theme.of(context).primaryColor,
          //  onPressed: () {
          //    Navigator.of(context).push(
          //       MaterialPageRoute(
          //         fullscreenDialog: true,
          //         builder: (ctx) => MapScreen(
          //           initialLocation: selectedPlace.location ??
          //               const PlaceLocation(latitude: 0.0, longitude: 0.0),
          //               isSelecting: false,
          //         ),
          //       ),
          //     );
          // }, )
        ],
      ),
    );
  }
}
