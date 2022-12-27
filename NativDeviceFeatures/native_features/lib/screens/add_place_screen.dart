import 'dart:io';

import 'package:flutter/material.dart';
import '/models/place.dart';
import 'package:provider/provider.dart';

import '/widgets/image_input.dart';
import '/widgets/location_input.dart';
import '/providers/great_places.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _pickedImage;
  PlaceLocation? _pickedLocation;

  void _selectIamge(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlcae(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }
    Provider.of<GreatePlaces>(
      context,
      listen: false,
    ).addPlace(
      pickedTitle: _titleController.text,
      pickedImage: _pickedImage ?? File(''),
      pickedLocation: _pickedLocation,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ImageInput(onSelectImage: _selectIamge),
                    const SizedBox(height: 10,),
                    LocationInput(onSelectPlace: _selectPlcae,),
                  ],
                ),
              ),
            ),
          ),

          // RaisedButton.icon(
          //   icon: const Icon(Icons.add),
          //   label: const Text('Add Place'),
          //   elevation: 0,
          //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //   color: Theme.of(context).colorScheme.secondary,
          //   onPressed: _savePlace,
          // ),
        ],
      ),
    );
  }
}
