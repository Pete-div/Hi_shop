import 'package:flutter/foundation.dart';

class CartItem{
  final String title;
  final String id;
  final int quantity;
  final double price;
  CartItem({required this.title,required this.id,required this.quantity,required this.price});
}

class Cart with ChangeNotifier{
Map<String,CartItem> _items={};




Map<String,CartItem> get items{
  return{..._items};
}


double get totalAmount{
  var total = 0.0;
  _items.forEach((key, cartItem) {
    total +=cartItem.price *cartItem.quantity;
   }
  );
  return total;
}

int get itemCount{
  return
  _items.length;

}

void addItems(String productId,double price,String title){
  if(_items.containsKey(productId)){
    _items.update(productId, (existingCartItems) => CartItem(
      title:existingCartItems.title, 
      id: existingCartItems.id, 
      quantity:existingCartItems.quantity +1 , 
      price: existingCartItems.price));
  }else{
    _items.putIfAbsent(productId, () => CartItem(
      title: title, id: DateTime.now().toString(), quantity: 1, price: price));
  }
  notifyListeners();
}
void removeItem(String prodId){
  _items.remove(prodId);
  notifyListeners();
}
void clear(){
  _items.clear();
  notifyListeners();
}
}