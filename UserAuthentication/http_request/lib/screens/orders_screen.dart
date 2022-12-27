import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '/widgets/order_item.dart';
import '/widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetcAndSetOrders();    
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //final ordersData = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              _ordersFuture,
          builder: (ctx, dataSnapsot) {
            if (dataSnapsot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapsot.error != null) {
                return const Center(
                  child: Text('An error occured'),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, ordersData, child) => ListView.builder(
                        itemCount: ordersData.orders.length,
                        itemBuilder: (ctx, index) => OrderItem(
                              order: ordersData.orders[index],
                            )));
              }
            }
          },
        ));
  }
}
