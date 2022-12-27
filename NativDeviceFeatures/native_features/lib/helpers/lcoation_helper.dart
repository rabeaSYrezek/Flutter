import 'dart:convert';

import 'package:http/http.dart' as http;

//const GOOGLE_API_KEY = 'AIzaSyBg9yn5JtQgKRFbg6FCTy4ewbF24kRuAYI';
const GOOGLE_API_KEY = 'AIzaSyAOqYYyBbtXQEtcHG7hwAwyCPQSYidG8yU';

class LocationHelper {
  static String generateLocationPreviewImage({
    required double latitude,
    required double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlcaeAddress(double lat, double lng) async {
    var url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY');
    final response = await http.get(url);

    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
