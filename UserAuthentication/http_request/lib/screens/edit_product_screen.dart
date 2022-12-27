import '/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static final String routeName = '/edit-product';

  _EditeProductScreenState createState() => _EditeProductScreenState();
}

class _EditeProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrl = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final id = ModalRoute.of(context)!.settings.arguments;
      if (id != null) {
        final product =
            Provider.of<Products>(context, listen: false).getById(id as String);
        _editedProduct = product;

        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrl.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _priceFocusNode.dispose();
    // _descriptionFocusNode.dispose();
    // _imageUrl.dispose();
    // _imageUrlFocusNode.dispose();
    // _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrl.text.startsWith('http') &&
              !_imageUrl.text.startsWith('https')) ||
          (!_imageUrl.text.endsWith('.png') &&
              !_imageUrl.text.endsWith('.jpg') &&
              !_imageUrl.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
       await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occured'),
                  content: Text('Something went wrong'),
                  actions: [
                    TextButton(
                        child: Text('okay'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        })
                  ],
                ));
      } 
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });

      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _initValues['title'],
                          decoration: const InputDecoration(
                              labelText: 'Title',
                              errorStyle: TextStyle(color: Colors.green)),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please provide a value';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                title: value!,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite);
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(labelText: 'Price'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter a price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'please enter a valid number';
                            }
                            if (double.parse(value) <= 0) {
                              return 'please enter number greater than zero';
                            }
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                price: double.parse(value!),
                                description: _editedProduct.description,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite);
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter some text';
                            }
                            if (value.length < 10) {
                              return 'description must att least 10 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: value!,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite);
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: _imageUrl.text.isEmpty
                                  ? Text('Enter a URL')
                                  : FittedBox(
                                      child: Image.network(_imageUrl.text),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image Url'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrl,
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) => _saveForm(),
                                validator: (value) {
                                  // if (value!.isEmpty) {
                                  //   return 'Please enter image URL';
                                  // }
                                  // if (!value.startsWith('http') &&
                                  //     !value.startsWith('https')) {
                                  //   return 'please enter valid URL';
                                  // }
                                  // if (!value.endsWith('.png') &&
                                  //     !value.endsWith('.jpg') &&
                                  //     !value.endsWith('.jpeg')) {
                                  //   return 'please enter a valid image URL';
                                  // }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                      title: _editedProduct.title,
                                      price: _editedProduct.price,
                                      description: _editedProduct.description,
                                      imageUrl: value!,
                                      id: _editedProduct.id,
                                      isFavorite: _editedProduct.isFavorite);
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            ),
    );
  }
}
