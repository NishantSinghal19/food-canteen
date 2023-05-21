import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItem {
  final String name;
  final double price;
  final bool isAvailable;
  int quantity;

  MenuItem({required this.name, required this.isAvailable, required this.price,this.quantity = 0});
   Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "isAvailable": isAvailable,
        "quantity": quantity,
        // "followers": followers,
        // "following": following,
      };

  static MenuItem? fromSnap (DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return MenuItem(
      name: snapshot['name'],
      price: snapshot['price'],
      isAvailable: snapshot['isAvailable'],
      // following: snapshot['following'],
      // followers: snapshot['followers'],
      // email: snapshot['email']
      quantity: snapshot['quantity'],
    );
  }
}
