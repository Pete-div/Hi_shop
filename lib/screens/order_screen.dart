import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_with_auth/widget/app_drawer.dart';
import '../providers/order.dart';
import '../widget/order_items.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = 'order-screen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}


class _OrderScreenState extends State<OrderScreen> {
  var isLoading = false;
  // @override
  // void initState() {
  //    setState(() {
  //       isLoading = true;
  //     });
  //   Future.delayed(Duration.zero).then((value) async {
     
  //     await Provider.of<Orders>(context,listen: false).fetchAndSetOrders().then((_) {
  //       setState(() {
  //       isLoading = false;
  //     });
  //     } );
      

  //   super.initState();
  // });
  // }

  @override
  void didChangeDependencies() {
    setState(() {
      isLoading = true;});
      Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
      setState(() {
        isLoading = false;
      });
      
    
  
    super.didChangeDependencies();
  }
  // if you have other features that will update again and again,use this for the ones u dont want to keep updating

  // Future? _ordersFuture;
  // Future _obtainOrdersFuture(){
  //   return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  // }

  // @override
  // void initState() {
  //  _ordersFuture = _obtainOrdersFuture();
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context,listen: false);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: isLoading? Center(child: CircularProgressIndicator()):

      Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: orderData.order.length,
                      itemBuilder: (ctx, i) =>
                          OrderItems(orderData.order[i]),
                    ),
                  ));
  //     body: FutureBuilder(
  //         future: _ordersFuture,
  //         // Provider.of<Orders>(context).fetchAndSetOrders(),
  //         builder: (ctx, dataSnapshot) {
  //           if (dataSnapshot.connectionState == ConnectionState.waiting) {
  //             return Center(child: CircularProgressIndicator());
  //           } else {
  //             if (dataSnapshot.error != null) {
  //               return Center(
  //                 child: Container(
  //                   child: Text(
  //                     'Can not get your Orders',
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //               );
  //             } else {
  //               return Consumer<Orders>(
  //                 builder: (ctx, orderData, child) {
  //                   return Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: ListView.builder(
  //                       itemCount: orderData.order.length,
  //                       itemBuilder: (ctx, i) => OrderItems(orderData.order[i]),
  //                     ),
  //                   );
  //                 },
  //               );
  //             }
  //           }
  //         }),
  //   );
  }
}
        //   },
        // ));
//   }
// }
