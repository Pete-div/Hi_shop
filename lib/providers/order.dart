import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.amount,
      required this.dateTime,
      required this.id,
      required this.products});
}



class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
    List<OrderItem> get order => [..._orders];
  
    final String authToken;
  final String userId;
  Orders(this.authToken,this._orders,this.userId);





  Future<void> fetchAndSetOrders() async {
     final url = Uri.parse(
        'https://shopp-abd19-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
      
      final response = await http.get(url);
        print(json.decode(response.body));
      final List<OrderItem> loadedOrders = [];
      final extractedOrders =
          json.decode(response.body) as Map<String, dynamic>;
          if(extractedOrders.isEmpty){
            return;
          }
      extractedOrders.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
              amount: orderData['amount'],
              dateTime: DateTime.parse(
                orderData['dateTime'],
              ),
              id: orderId,
              products: (orderData['products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                        title: item['title'],

                        id: item['id'],
                        quantity: item['quantity'],
                        price: item['price']),
                  )
                  .toList()),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    
  }

  Future<void> addOrders(List<CartItem> cartProduct, double total) async {
    final url = Uri.parse(
        'https://shopp-abd19-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProduct
              .map((cp) => {
                    'title': cp.title,
                    'id': cp.id,
                    'amount': cp.quantity,
                    'price': cp.price
                  })
              .toList()
        }),
      );

      _orders.insert(
          0,
          OrderItem(
              amount: total,
              dateTime: timestamp,
              id: json.decode(response.body)['name'],
              products: cartProduct));
      notifyListeners();
    } catch (error) {
      throw HttpException('Could not add the Orders');
    }
  }
}
