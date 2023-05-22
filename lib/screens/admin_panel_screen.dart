// ignore_for_file: unnecessary_import, unnecessary_brace_in_string_interps, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_canteen/models/cart_item.dart';
import 'package:food_canteen/models/order.dart';
import 'package:food_canteen/models/user_model.dart';
import 'dart:async';

class AdminPage extends StatefulWidget {
  final UserModel user;
  const AdminPage({super.key, required this.user});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Timer _timer;
  int _reloadInterval = 60; // Reload interval in seconds

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: _reloadInterval), (timer) {
      setState(() {
        // Perform any necessary logic or update widget state here
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Access the current user from the provider

    final currentUser = widget.user;
    final uid = currentUser.uid;
    // Check if the user is an admin
    if (currentUser.role.toString() != 'Userrole.admin') {
      // Redirect to another page or show an error message
      return const Scaffold(
        body: Center(
          child: Text('You do not have permission to access this page.'),
        ),
      );
    }

    // Fetch the order list from the database or any other source
    final orders = fetchOrders(uid);

    return Scaffold(
      backgroundColor: const Color.fromARGB(105, 253, 227, 202),
      body: FutureBuilder<List<OrderItem>>(
        future: orders,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final orderItems = snapshot.data!;
          return ListView.builder(
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                final order = orderItems[index];
                String orderItemStr = "";

                for (var item in order.items) {
                  orderItemStr += '${item.name} (${item.quantity})\n';
                }

                return Container(
                  decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Border radius value
                color: const Color.fromARGB(255, 254, 250, 246) // Background color of the container
                
              ),
              margin: const EdgeInsets.fromLTRB(5,5,5,5),
                  child: ListTile(
                  title: Text('Order:\n${orderItemStr}'),
                  subtitle: Text(
                      'Total Price: \$${order.totalPrice.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(orderItems[index].status != 'Accepted') ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(eccentricity: 0.5),
                          shadowColor: const Color.fromARGB(105, 253, 227, 202),
                        ),
                        onPressed: () async {
                          // Handle the accept button action
                          var oid = orderItems[index].orderId;
                          bool ans = await _updateOrderStatus(oid, 'Accepted');
                          if(ans) orderItems[index].status = 'Accepted';
                        },
                        child: const Icon(Icons.check, color: Color.fromARGB(255, 47, 255, 54),),
                      ),
                      const SizedBox(width: 10),
                      if(orderItems[index].status == 'Accepted') ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(eccentricity: 0.5)
                        ),
                        onPressed: () async {
                          setState(() {
                              orderItems[index].status = 'Finished';
                           });  
                          // Handle the decline button action
                          var oid = orderItems[index].orderId;
                          Future<bool> ans = _updateOrderStatus(oid, 'Ready');
                          if(await ans) orderItems[index].status = 'Ready';
                        },
                        child: const Text('Ready', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                      const SizedBox(width: 10),
                      if(orderItems[index].status != 'Declined') ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(eccentricity: 0.5)
                        ),
                        onPressed: () async {
                          // Handle the decline button 
                          var oid = orderItems[index].orderId;
                          Future<bool> ans = _updateOrderStatus(oid, 'Declined');
                          if(await ans) orderItems[index].status = 'Declined';
                        },
                        child: const Icon(Icons.close, color: Color.fromARGB(255, 255, 17, 0),),
                      ),
                    ],
                  ),
                ));
              });
        },
      ),
    );
  }

  // Fetch orders from the database or any other source

  Future<List<OrderItem>> fetchOrders(userId) async {
    List<OrderItem> orders = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      for (var doc in querySnapshot.docs) {
        if (doc.data() != null) {
          // Cast the data to a Map<String, dynamic>
          final data = doc.data()! as Map<String, dynamic>;
          String orderId = data['orderId'] ?? doc.id;
          double totalPrice = data['totalPrice'] ?? 0.0;
          List<CartItem> items = [];
          String status = data['status'] ?? 'Pending';
          
          data['items'].forEach((item) {
            items.add(CartItem(
              name: item['name'],
              price: item['price'],
              quantity: item['quantity'],
            ));
          });

          DateTime orderTime = data['orderTime'].toDate();
          // Create an Order object and add it to the orders list
          OrderItem order = OrderItem(
              orderId: orderId,
              totalPrice: totalPrice,
              userId: userId,
              items: items,
              orderTime: orderTime,
              status: status);
          orders.add(order);
        }
      }
    } catch (error) {
      Text('Error fetching orders: $error');
    }

    return orders;
  }

  // Handle the accept button action
  // bool (num ind, String status) {
          
  //   print('Order $ind $status');
  //   return true;
  // }

  Future<bool> _updateOrderStatus(String orderId, String status) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('orderId', isEqualTo: orderId)
        .get();

    // Iterate over the query snapshot to update the matching documents
    for (DocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.update({'status': status});
    }

    print('Successfully updated order status');
    return true;
  } catch (error) {
    print('Error updating order status: $error');
    return false;
  }
}

//   Future<bool> _updateOrderStatus(String orderId,String status) async {
    
//   try {
//     final DocumentReference documentRef =
//           FirebaseFirestore.instance.collection('orders').where('orderId');

//       await documentRef.update({'status': status});
//     // await FirebaseFirestore.instance
//     //     .collection('orders')
//     //     .doc(orderId)
//     //     .update({'status': status}); // Replace 'status' with the field name in your Firestore documents

//     print('Order $orderId $status');
//     return true;
//   } catch (error) {
//     // Handle any errors that occur during the update process
//     print('Error accepting order: $error');
//     return false;
//   }
// }

}
