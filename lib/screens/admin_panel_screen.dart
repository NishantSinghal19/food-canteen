// ignore_for_file: unnecessary_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_canteen/models/cart_item.dart';
import 'package:food_canteen/models/order.dart';
import 'package:food_canteen/models/user_model.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  final UserModel user;
  const AdminPage({super.key, required this.user});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    // Access the current user from the provider

    final currentUser = widget.user;

    // Check if the user is an admin
    if (currentUser.role == 'admin') {
      // Redirect to another page or show an error message
      return Scaffold(
        body: Center(
          child: Text('You do not have permission to access this page.'),
        ),
      );
    }

    // Fetch the order list from the database or any other source
    final orders = fetchOrders();

    return Scaffold(
      body: FutureBuilder<List<OrderItem>>(
        future: orders,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final orderItems = snapshot.data!;
          return ListView.builder(
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                final order = orderItems[index];

                return ListTile(
                  title: Text('Order ID: ${order.orderId}'),
                  subtitle: Text(
                      'Total Price: \$${order.totalPrice.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle the accept button action
                          _acceptOrder(order.orderId);
                        },
                        child: Text('Accept'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Handle the decline button action
                          _declineOrder(order.orderId);
                        },
                        child: Text('Decline'),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }

  // Fetch orders from the database or any other source

  Future<List<OrderItem>> fetchOrders() async {
    List<OrderItem> orders = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      querySnapshot.docs.forEach((doc) {
        if (doc.data() != null) {
          // Cast the data to a Map<String, dynamic>
          final data = doc.data()! as Map<String, dynamic>;
          String orderId = data['orderId'] ?? doc.id;
          double totalPrice = data['totalPrice'] ?? 0.0;
          List<CartItem> items = [];
          
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
              items: items,
              orderTime: orderTime);
          orders.add(order);
        }
      });
    } catch (error) {
      Text('Error fetching orders: $error');
      print('Error fetching orders: $error');
    }

    return orders;
  }

  // Handle the accept button action
  void _acceptOrder(String orderId) {
    // Replace this with your actual implementation
    print('Order $orderId accepted');
  }

  // Handle the decline button action
  void _declineOrder(String orderId) {
    // Replace this with your actual implementation
    print('Order $orderId declined');
  }
}
