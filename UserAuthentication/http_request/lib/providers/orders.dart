import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_request/widgets/order_item.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final int amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.dateTime,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;


  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> adOrder(List<CartItem> cartProducts, int total) async{
    print('111');
    final timeStamp = DateTime.now();
    final url = Uri.parse('http://192.168.1.104:3000/index/add-order');
    var body = json.encode({
      'amount': total ,
      'dateTime': timeStamp.toIso8601String(),
      'products': cartProducts.map((cp) => {
        'id': cp.id,
        'title': cp.title,
        'quantity': cp.quantity,
        'price': cp.price,
      }).toList(),
    });
    try {
      final response = await http.post(url, headers: {'Content-Type': 'application/json', 'auth': authToken},body: body);
    } catch (error) {
      throw error;
    }
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: timeStamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> fetcAndSetOrders() async{
    final url = Uri.parse('http://192.168.1.104:3000/index/get-orders');
    final response = await http.get(url, headers: {'Contebt-Type': 'application/json', 'auth': authToken});
    final extractedOrders = json.decode(response.body);

    if (extractedOrders == null) return;

    final List<OrderItem> loadedOrders = [];

    for (var order in extractedOrders) {
      loadedOrders.add(OrderItem(
        id: order['_id'],
        amount: order['amount'],
        dateTime: DateTime.parse(order['dateTime']),
        products: (order['products'] as List<dynamic>)
        .map((item) => CartItem(
                id: item['id'],
                title: item['title'],
                price: item['price'] as int,
                quantity: item['quantity']))
            .toList(),
      ));
    }
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
