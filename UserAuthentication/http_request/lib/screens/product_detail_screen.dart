import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-detail';
  // final String title;

  //   ProductDetailScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(
      context,
    )!
        .settings
        .arguments as String;
    final loadProduct =
        Provider.of<Products>(context, listen: false).getById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
              loadProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '\$ ${loadProduct.price}',
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              )),
        ]),
      ),
    );
  }
}
