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
}