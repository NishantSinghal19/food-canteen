import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/menu_item.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addnewitem(
    String name,
    double price,
    bool isAvailable,
    int quantity,
  ) async {
    String result = "Some error occurred";
    try {
      String itemId = Uuid().v1();
      MenuItem item = MenuItem(
        name: name,
        price: price,
        isAvailable: isAvailable,
        quantity: quantity,
      );
      _firestore.collection('items').doc(itemId).set(
            item.toJson(),
          );
      result = "success";
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  Future<List<MenuItem>> getItemList() async {
    List<MenuItem> itemList = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('items').get();

      querySnapshot.docs.forEach((doc) {
        final data = doc.data()! as Map<String, dynamic>;
        // Extract item data from Firestore document
        String name = data['name'];
        double price = data['price'];
        int quantity = data['quantity'];
        bool availability = data['isAvailable'];

        // Create an Item object and add it to the itemList
        MenuItem item = MenuItem(
          name: name,
          price: price,
          quantity: quantity,
          isAvailable: availability,
        );
        itemList.add(item);
      });
    } catch (error) {
      print('Error fetching item list: $error');
    }

    return itemList;
  }
}
