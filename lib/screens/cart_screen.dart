import 'package:flutter/material.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';
import '../widget/ccart_items.dart';
import '../providers/order.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "\$${cart.totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Colors.pink,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OrderButton(cart: cart),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItems(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].title),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (widget.cart.totalAmount <= 0 || isLoading)
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrders(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                setState(() {
                  isLoading = false;
                });
                widget.cart.clear();
              },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Text(
                'Order Now!!',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ));
  }
}
