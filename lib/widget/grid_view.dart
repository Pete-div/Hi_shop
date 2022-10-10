import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widget/product_items.dart';



class GridViewd extends StatelessWidget {
  final bool showFav;
  GridViewd(this.showFav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context,);
    final product =showFav? productsData.favoriteItems: productsData.item;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) => 
// ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: GridTile(
//         child: GestureDetector(
//           onTap: ()=> Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,arguments:product[i].id ),
//           child: Image.network(
//             product[i].ImageUrl,
//             fit: BoxFit.cover,
//           ),
//         ),
//         footer: GridTileBar(
//           backgroundColor: Colors.black87,
//           leading: IconButton(
//             onPressed: () {
//               productsData.isToggleFavStatus(product[i]);
//             },
//             icon: Icon(product[i].isFavorite?
//               Icons.favorite:Icons.favorite_border_outlined,
//               color: Colors.red,
//             ),
//           ),
//           trailing: IconButton(
//             onPressed: () {},
//             icon: Icon(Icons.shopping_cart),
//             color:Theme.of(context).accentColor,
//           ),
//           title: Text(
//            product[i]. title,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),

//     ),
    ChangeNotifierProvider.value(
      value: product[i],
      child: ProductItems(
        // product[i].id,
        //   product[i].ImageUrl,product[i].title
          ),
    ),
        itemCount:product.length);
  }
}
