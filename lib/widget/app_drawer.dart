
import '../screens/order_screen.dart';
import 'package:flutter/material.dart';
import '../screens/user_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  static const routeName ='app-drawer';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friends'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: (){
            Navigator.of(context).pushReplacementNamed('/');
          },),
            Divider(),
          ListTile(leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: (){
            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
          },),
           Divider(),
          ListTile(leading: Icon(Icons.edit),
          title: Text('User Products'),
          onTap: (){
            Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
          },),
            Divider(),
          ListTile(leading: Icon(Icons.logout,),
          title: Text('Logout'),
          onTap: (){
            Provider.of<Auth>(context,listen: false).logOut();
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, '/');
          },),
        ],
      ),
    );
  }
}
