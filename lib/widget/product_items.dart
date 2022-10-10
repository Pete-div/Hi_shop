import 'package:flutter/material.dart';
import '../screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItems extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
final productDa =Provider.of<Product>(context,listen: false);
final auth = Provider.of<Auth>(context,listen: false);

final cart = Provider.of<Cart>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: ()=> Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,arguments:productDa.id ),
          child: Image.network(
            productDa.ImageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx,product,child)=>
            IconButton(
              onPressed: () {
                productDa.isToggle(auth.token as String,auth.userId as String);
              },
              icon: Icon(productDa.isFavorite?
                Icons.favorite:Icons.favorite_border_outlined,
                color: Colors.red,
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItems(productDa.id, productDa.price, productDa.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added Item to the cart!'),
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeItem(productDa.id);
                      },
                    ),),);
            },
            icon: Icon(Icons.shopping_cart),
            color:Theme.of(context).accentColor,
          ),
          title: Text(
           productDa. title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
