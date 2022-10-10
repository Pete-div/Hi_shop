import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
static const routeName = 'Product-details';

  @override
  Widget build(BuildContext context) {
    final productId=ModalRoute.of(context)!.settings.arguments as String ;
    final loadedProduct = Provider.of<Products>(context,listen: false).findById(productId);
    return Scaffold(
     
      
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title,textAlign: TextAlign.center,),
              background:Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.ImageUrl,
                  fit: BoxFit.cover,
                ),
              ) ,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
               SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProduct.price}',textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ]),
          ),
          ],
        ),
    );
  }
}