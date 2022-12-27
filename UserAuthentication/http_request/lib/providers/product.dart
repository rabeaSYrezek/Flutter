import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final dynamic price;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  void _setFavVal(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoritStatus(String token) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse('http://192.168.1.104:3000/index/isFavorite/$id');
    try {
     var response =  await http.patch(
        url,
        headers: {'auth': token},
        body: json.encode(
          {
            'isFavorite': isFavorite,
          },
        ),
      );

      if(response.statusCode >= 400) {
        _setFavVal(oldStatus);
      }
    } catch (e) {
      _setFavVal(oldStatus);
    }
  }
}
