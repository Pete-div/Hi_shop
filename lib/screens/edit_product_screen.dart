import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'Edit-screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _form = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  var _editedProduct =
      Product(id: '', ImageUrl: '', description: '', price: 0, title: '');
  var isInit = false;
  var isLoading = false;

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImage);
    super.initState();
  }

  var iniValue = {
    'id': null,
    'imageUrl': '',
    'description': '',
    'price': '',
    'title': '',
  };

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId.isNotEmpty) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        iniValue = {
          'imageUrl': '',
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'title': _editedProduct.title,
        };
        _imageUrlController.text = _editedProduct.ImageUrl;
      }
    }

    isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();

    super.dispose();
  }

  Future<void> _saveForm() async{
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      isLoading = true;
    });
    if (_editedProduct.id.isNotEmpty) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try{ await Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct);} catch(error) {
       await showDialog(
          context: context,
          useSafeArea: true,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('An error occurred'),
              content: Text('Something went wrong'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'))
              ],
            );
          },
        );
      }
    //finally{ setState(() {
    //   isLoading = false;
    // });
    setState(() {
      isLoading = false;
    });}
    Navigator.of(context).pop();
    }
    
  void _updateImage() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.orangeAccent,
            ))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        initialValue: iniValue['title'],
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            ImageUrl: _editedProduct.ImageUrl,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            title: value.toString(),
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        focusNode: _descriptionFocusNode,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        initialValue: iniValue['price'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            ImageUrl: _editedProduct.ImageUrl,
                            description: _editedProduct.description,
                            price: double.parse(value.toString()),
                            title: _editedProduct.title,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        textInputAction: TextInputAction.next,
                        initialValue: iniValue['description'],
                        maxLines: 3,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            ImageUrl: _editedProduct.ImageUrl,
                            description: value.toString(),
                            price: _editedProduct.price,
                            title: _editedProduct.title,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        keyboardType: TextInputType.multiline,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter a Url')
                                  : FittedBox(
                                      child: Image.network(
                                          _imageUrlController.text,
                                          fit: BoxFit.cover),
                                    )),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageFocusNode,
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  ImageUrl: value.toString(),
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  title: _editedProduct.title,
                                  isFavorite: _editedProduct.isFavorite,
                                );
                              },
                              onFieldSubmitted: (_) => _saveForm(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
