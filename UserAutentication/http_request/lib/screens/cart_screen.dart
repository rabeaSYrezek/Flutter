import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totlaAmount.toStringAsFixed(2)}',
                      // style: TextStyle(
                      //     color:
                      //         Theme.of(context).primaryTextTheme.title!.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderWidget(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(child: ListView.builder(
            itemCount: cart.items.length,
          itemBuilder: (ctx, index) => ci.CartItem(
            id: cart.items.values.toList()[index].id,
            price: (cart.items.values.toList()[index].price) , 
            quantity: cart.items.values.toList()[index].quantity,
            title: cart.items.values.toList()[index].title,
            productId: cart.items.keys.toList()[index],
          )))
        ],
      ),
    );
  }
}

class OrderWidget extends StatefulWidget {
    final Cart cart;

  const OrderWidget({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
      onPressed: (widget.cart.totlaAmount <=0.0  || _isLoading) ? null : () async{
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false).adOrder(
          widget.cart.items.values.toList(),
          widget.cart.totlaAmount,
        );
        setState(() {
          _isLoading = false;
        });
        widget.cart.clear();
      },
    );
  }
}
