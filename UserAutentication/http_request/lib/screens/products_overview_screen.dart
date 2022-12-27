import 'package:flutter/material.dart';
import '/providers/products.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '/widgets/app_drawer.dart';
import '/screens/cart_screen.dart';

enum FilterOPtions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
         _isLoading = true;
      });
     
      Provider.of<Products>(context).fetchAndSetProducts()
        .then((_) {
          setState(() {
            _isLoading = false;
          });
          
        });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOPtions selectedValue) {
              setState(() {
                if (selectedValue == FilterOPtions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('only favorites'),
                value: FilterOPtions.Favorites,
              ),
              PopupMenuItem(
                child: Text('show all'),
                value: FilterOPtions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch!, value: cart.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator(),) : ProductsGrid(
        showFav: _showOnlyFavorites,
      ),
    );
  }
}
