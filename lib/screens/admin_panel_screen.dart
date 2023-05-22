// ignore_for_file: unnecessary_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_canteen/models/cart_item.dart';
import 'package:food_canteen/models/order.dart';
import 'package:food_canteen/models/user_model.dart';

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
    final uid = currentUser.uid;
    // Check if the user is an admin
    if (currentUser.role.toString() != 'Userrole.admin') {
      // Redirect to another page or show an error message
      return Scaffold(
        body: Center(
          child: Text('You do not have permission to access this page.'),
        ),
      );
    }

    // Fetch the order list from the database or any other source
    final orders = fetchOrders(uid);

    return Scaffold(
      backgroundColor: Color.fromARGB(105, 253, 227, 202),
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
                String orderItemStr = "";

                order.items.forEach((item) {
                  orderItemStr += '${item.name} (${item.quantity})\n';
                });

                return Container(
                  decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Border radius value
                color: Color.fromARGB(255, 254, 250, 246) // Background color of the container
                
              ),
              margin: EdgeInsets.fromLTRB(5,5,5,5),
                  child: ListTile(
                  title: Text('Order:\n${orderItemStr}'),
                  subtitle: Text(
                      'Total Price: \$${order.totalPrice.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(eccentricity: 0.5),
                          shadowColor: Color.fromARGB(105, 253, 227, 202),
                        ),
                        onPressed: () {
                          // Handle the accept button action
                              setState(() {
                              orderItems[index].status = 'Accepted';
                           });  
                           
                          
                          _acceptOrder(index);
                        },
                        child: Icon(Icons.check, color: Color.fromARGB(255, 47, 255, 54),),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(eccentricity: 0.5)
                        ),
                        onPressed: () {
                          setState(() {
                              orderItems[index].status = 'Declined';
                           });  
                          // Handle the decline button action
                          
                          _declineOrder(index);
                        },
                        child: Icon(Icons.close, color: Color.fromARGB(255, 255, 17, 0),),
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
              userId: userId,
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
  void _acceptOrder(num ind) {
    // Replace this with your actual implementation
          
    print('Order $ind accepted');
  }

  // Handle the decline button action
  void _declineOrder(num ind) {
    // Replace this with your actual implementation
    print('Order $ind declined');
  }
}
