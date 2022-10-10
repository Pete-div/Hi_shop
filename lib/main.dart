import 'package:flutter/material.dart';
import 'package:shop_with_auth/screens/products_overview_screen.dart';
import './screens/order_screen.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import './screens/product_details_screen.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/order.dart';
import './widget/app_drawer.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          //    ChangeNotifierProvider(
          //   create:(ctx)=> Products(),
          // ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products('', [], ''),
            update: (ctx, auth, previousProduct) => Products(auth.token ?? '',
                previousProduct == null ? [] : previousProduct.item, auth.userId ?? ''),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', [], ''),
            update: (ctx, auth, previousOrders) => Orders(
                auth.token ?? '',
                previousOrders == null ? [] : previousOrders.order,
                auth.userId ?? ''),
          ),
          ChangeNotifierProvider(
              create: (
            ctx,
          ) =>
                  Cart()),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Shop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'maagkramp',
            ),
            home: 




             auth.isAuth 
                ? ProductOverviewScreen()
                
             
            //: AuthScreen(),
                :FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (
                      ctx,
                      authSnapshot,
                    ) =>
                        authSnapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              AppDrawer.routeName: (ctx) => AppDrawer(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
