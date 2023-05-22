// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String name;
  final double price;
  late int quantity;

  CartItem({ required this.name, required this.price, required this.quantity});
  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "quantity": quantity,
        // "followers": followers,
        // "following": following,
      };

  static CartItem? fromSnap (DocumentSnapshot snap) {
    if (snap == null) {
    // Handle the case where the JSON data is null
    // Return a default or placeholder CartItem object
    return CartItem(name: '', price: 0.0, quantity: 0);
  }
    var snapshot = snap.data() as Map<String, dynamic>;
    return CartItem(
      name: snapshot['name'] as String,
      price: snapshot['price'] as double,
      // following: snapshot['following'],
      // followers: snapshot['followers'],
      // email: snapshot['email']
      quantity: snapshot['quantity']as int,
    );
  }
  
}
