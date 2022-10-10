import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../widget/user_product_item.dart';
import '../widget/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = 'user-product-scrren';

  Future<void> _reFreshIndicator(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _reFreshIndicator(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.brown,
                  ))
                : RefreshIndicator(
                    onRefresh: () => _reFreshIndicator(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<Products>(
                        builder: (ctx, productsData, _) => ListView.builder(
                          itemCount: productsData.item.length,
                          itemBuilder: (ctx, i) => Column(
                            children: [
                              UserProductItem(
                                productsData.item[i].ImageUrl,
                                productsData.item[i].title,
                                productsData.item[i].id,
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
