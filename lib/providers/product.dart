import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String ImageUrl;
  bool isFavorite;

  Product(
      {required this.id,
       required this.title,
        required this.description,
          required this.price,
      required this.ImageUrl,
      this.isFavorite = false,
     
    
     });

      void _setFav(newValue){
        isFavorite = newValue;
      }

    Future<void> isToggle( String token,String userId)async{
      final oldStatus =isFavorite;
      isFavorite =!isFavorite;
      notifyListeners();
          final url = Uri.parse(
     'https://shopp-abd19-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
     
     try{
       final response = await http.put(url,body: json.encode(
isFavorite
     ),);
if(response.statusCode >=400){
_setFav(oldStatus);
    notifyListeners();
}
    }catch(error){
     _setFav(oldStatus);
   
    }
     }

    //     void isTogggle(){
    //   isFavorite =!isFavorite;
    //   // notifyListeners();

    // }
}
