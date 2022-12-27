import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';

import '/helpers/lcoation_helper.dart';
import '/screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  const LocationInput({Key? key, required this.onSelectPlace})
      : super(key: key);

  @override
  _LoactionInputState createState() => _LoactionInputState();
}

class _LoactionInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImage = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);

    setState(() {
      _previewImageUrl = staticMapImage;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    try {
      _locationData = await Location().getLocation();
      print('longitude: ${_locationData.longitude}');
      print('latitude: ${_locationData.latitude}');
      _showPreview(
          _locationData.latitude ?? 0.0, _locationData.longitude ?? 0.0);
      widget.onSelectPlace(_locationData.latitude, _locationData.longitude);
    } catch (e) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }

    _showPreview(selectedLocation.latitude, selectedLocation.longitude);

    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? const Text('No loaction choosen', textAlign: TextAlign.center)
              : Image.network(
                  _previewImageUrl ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on map'),
              onPressed: _selectOnMap,
            )
          ],
        ),
      ],
    );
  }
}
