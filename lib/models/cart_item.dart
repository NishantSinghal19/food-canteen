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
    var snapshot = snap.data() as Map<String, dynamic>;
    return CartItem(
      name: snapshot['name'],
      price: snapshot['price'],
      // following: snapshot['following'],
      // followers: snapshot['followers'],
      // email: snapshot['email']
      quantity: snapshot['quantity'],
    );
  }
}
