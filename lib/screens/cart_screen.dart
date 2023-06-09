// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/cart_item.dart';
// import '../models/menu_item.dart';
// import '../models/order.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [];
  double getTotalPrice() {
    double totalPrice = 0.0;
    for (var item in cartItems) {
      totalPrice += item.price * item.quantity;
    }
    return totalPrice;
  }

  Future<void> placeOrder() async {
    // Generate a unique order ID
    String orderId = Uuid().v4();
    String _generateOrderId() {
      // Generate a random order ID
      // You can replace this with your own logic to generate an order ID
      // For simplicity, we'll use a random number between 1000 and 9999
      final random = new Random();
      int orderId = random.nextInt(9000) + 1000;
      return 'ORD$orderId';
    }
    // Create an Order object

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'totalPrice': getTotalPrice(),
        'orderId': orderId,
        'items': cartItems.map((item) => item.toJson()).toList(),
        'orderTime': DateTime.now(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'status': 'Pending',
        // Add any other order details you want to store in Firestore
      });
      print('Order placed successfully!');
      CartProvider cartProvider =
          Provider.of<CartProvider>(context, listen: false);
      //cartProvider.saveCartItems();
      // Send the order to the backend or perform any necessary actions
      // Here you can make API requests or save the order to a database
      // Replace this with your actual implementation

      // Display a success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // ignore: prefer_const_constructors
            title: Text('Order Placed'),
            content: Text(
                'Your order has been placed successfully.\nOrder ID: $orderId\nTotal Price: ${'\u20B9'}${getTotalPrice().toStringAsFixed(2)}'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  // Clear the cart and navigate back
                  cartProvider.clearCart();
                  //cartProvider.saveCartItems();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error placing order: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // Load the cart items when the page is initialized
    //Provider.of<CartProvider>(context, listen: false).loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    cartItems = cartProvider.cartItems;
    return Scaffold(
      backgroundColor: const Color.fromARGB(105, 253, 227, 202),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(10.0), // Border radius value
                        color: const Color.fromARGB(255, 254, 250,
                            246) // Background color of the container

                        ),
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (item.quantity == 1) {
                                cartProvider.removeFromCart(item);
                                return;
                              }
                              setState(() {
                                if (item.quantity > 0) {
                                  item.quantity--;
                                }
                              });
                            },
                          ),
                          Text(item.quantity.toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                if (item.quantity < 10) {
                                  item.quantity++;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
            child: Text(
              'Total Price: ${'\u20B9'}${getTotalPrice().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: cartItems.isEmpty ? null : placeOrder,
            child: const Text('Place Order'),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20))
        ],
      ),
    );
  }
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem item) {
    var ind = _cartItems.indexWhere((element) => element.name == item.name);
    if (ind != -1) {
      _cartItems[ind].quantity++;
    } else {
      _cartItems.add(item);
      //saveCartItems();
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    //saveCartItems();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Future<void> saveCartItems() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> cartItemsJson =
  //       _cartItems.map((item) => json.encode(item.toJson())).toList();
  //   await prefs.setStringList('cartItems', cartItemsJson);
  // }

  // Future<void> loadCartItems() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? cartItemsJson = prefs.getStringList('cartItems');
  //   if (cartItemsJson != null && cartItemsJson.isNotEmpty) {
  //     _cartItems = cartItemsJson
  //         .map((json) => CartItem.fromSnap(jsonDecode(json))!)
  //         .toList() as List<CartItem>;
  //   }
  // }
}
