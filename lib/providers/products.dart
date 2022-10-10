import 'dart:convert';
import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
   
  ];

  final String authToken;
  final String userId;
  Products(this.authToken, this._items, this.userId);

  var showFavoritesOnly = false;

  List<Product> get item {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItems) => prodItems.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://shopp-abd19-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://shopp-abd19-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');

      final favouriteResponse = await http.get(url);
      final favoriteData = json.decode(favouriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, proData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: proData['title'],
            description: proData['description'],
            price: proData['price'],
            ImageUrl: proData['imageUrl'],
            isFavorite: favoriteData == null ? false  :favoriteData[prodId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shopp-abd19-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.ImageUrl,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        ImageUrl: product.ImageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeItems(String id) async {
    final url = Uri.parse(
        'https://shopp-abd19-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);

    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct as Product);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final proIndex = _items.indexWhere((prod) => prod.id == id);
    if (proIndex >= 0) {
      final url = Uri.parse(
          'https://shopp-abd19-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      http.patch(url,
          body: json.encode({
            'description': newProduct.description,
            'imageUrl': newProduct.ImageUrl,
            'price': newProduct.price,
            'title': newProduct.title,
          }));
      _items[proIndex] = newProduct;
    } else {}

    notifyListeners();
  }

  // void isToggleFavStatus(Product id){
  //   id.isTogggle();
  //   notifyListeners();
  // }
}
