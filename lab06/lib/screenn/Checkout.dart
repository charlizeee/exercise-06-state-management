import 'package:flutter/material.dart';                                               
import '../model/Item.dart';
import "package:provider/provider.dart";
import "../provider/shoppingcart_provider.dart";

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool hasitems = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Item details"),
          getItems(context),
          const Divider(height: 4, color: Colors.black),
          Flexible(child: Column(
            children: [
              const SizedBox(height: 20,),
              showDetails(context)
            ],
          )),
          TextButton(
            child: const Text("Go back to Product Catalog"),
            onPressed: () {
              Navigator.pushNamed(context, "/products");
            },
          ),
        ],
      ),
    );
  }

  Widget computeCost() {
    return Consumer<ShoppingCart>(builder: (context, cart, child) {
       return Text("Total cost to Pay: ${cart.cartTotal}");
    });
  }

  Widget showDetails(BuildContext context) {
    return Visibility(
      visible: hasitems,
      child: Column(
        children: [
          computeCost(),
          ElevatedButton(
            onPressed: () {
              if (checkCart(context)){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Payment Successful!"),
                  )
                );
                context.read<ShoppingCart>().resetTotal();
                context.read<ShoppingCart>().removeAll();
                Navigator.pushNamed(context, "/products");
              } else {
                setState(() {
                  hasitems = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Add items first!"),
                  )
                );
              }
            },
          child: const Text("Pay Now!"))
        ],
      )
    );
  }



  Widget getItems(BuildContext context) {
    List<Item> products = context.read<ShoppingCart>().cart;
    return products.isEmpty
        ? const Text('No Items to checkout!')
        : Expanded(
            child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.food_bank),
                    title: Text(products[index].name),
                    trailing: Text(products[index].price.toString())
                  );
                },
              )),
              ],
          ));
          
  }

  bool checkCart(BuildContext context) {
    List<Item> products = context.read<ShoppingCart>().cart;
    return products.isNotEmpty;
  }

}