import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/model/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
   List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;
  final String authToken;
  final String userId;
  Products( this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((productItem) => productItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoritItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }
  // void showFavorite() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product getById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }


  Future<void> addProduct(Product product) async{
    var url = Uri.parse('http://192.168.1.104:3000/index');
    Map<String, dynamic> data = {
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
          'creatorId': userId,
        };

        var body = json.encode(data);
    try {
     final response = await http.post(
      url,
      headers: {"Content-Type": "application/json", 'auth': authToken},
      body: body,
    ); 
    Map<dynamic, dynamic> id = json.decode(response.body);
      print(id['id']);
      final newProduct = Product(
        id: id['id'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
    
      _items.add(newProduct);

      notifyListeners();
    } catch(error) {
      print(error);
      throw error;
    }

  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse('http://192.168.1.104:3000/index/update/$id');

      Map<String, dynamic> data = {
        'title': newProduct.title,
        'price': newProduct.price,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      };

      var body = json.encode(data);
      await http.patch(url,
          headers: {'Content-Type': 'application/json', 'auth': authToken}, body: body);
      _items[prodIndex] = newProduct;

      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('http://192.168.1.104:3000/index/delete/$id');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url, headers: {'Content:Type': 'application/json','auth': authToken});
    

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(message: "Could not delete product");
    }
    existingProduct = null;
  }


  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    var url = Uri.parse('http://192.168.1.104:3000/index');
    try {
      final result =
          await http.get(url, headers: {"Content-Type": "application/json", 'auth': authToken});
         // print(json.decode(result.body));
          final extractedData = json.decode(result.body);
          if (extractedData == null) return;
          
          final List<Product> loadedProducts = [];

          for (var item in extractedData) {
            loadedProducts.add(Product(
              id: item['_id'],
              description: item['description'],
              imageUrl: item['imageUrl'],
              price: item['price'],
              title: item['title'],
              isFavorite: item['isFavorite']
            ));
          }
          _items = loadedProducts;
          notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
