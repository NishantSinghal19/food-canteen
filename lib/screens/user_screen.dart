import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:food_canteen/models/cart_item.dart';
import 'package:food_canteen/models/order.dart';
import 'package:food_canteen/models/user_model.dart';

class UserScreen extends StatefulWidget {
  final UserModel? user;
  const UserScreen({super.key, this.user});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<OrderItem> orderItems = [];

  @override
  Widget build(BuildContext context) {
    String uid = widget.user!.uid;
    //List<OrderItem> orders = orderItems.where((item) => item.userId == uid).toList();
    final orders = fetchOrders(uid);
    //print(orders.length);
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
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  const UserScreen();
                });
              },
              child: ListView.builder(
                  itemCount: orderItems.length,
                  itemBuilder: (context, index) {
                    final order = orderItems[index];

                    String orderItemStr = "";

                    for (var item in order.items) {
                      orderItemStr += '${item.name} (${item.quantity})\n';
                    }

                    return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10.0), // Border radius value
                            color: const Color.fromARGB(255, 254, 250,
                                246) // Background color of the container

                            ),
                        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: ListTile(
                          title: Text('Order:\n$orderItemStr'),
                          subtitle: Text(
                              'Total Price: ${'\u20B9'}${order.totalPrice.toStringAsFixed(2)}'),
                          trailing: Text(order.status, style: TextStyle(color: order.status != 'Ready' ? Colors.red : Colors.green, fontSize: 16),),
                        ));
                  }),
            );
          }),
    );
  }
}
// Future<List<OrderItem>> fetchOrders(uId) async {
//     List<OrderItem> orders = [];

//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('orders').where('userId',isEqualTo: uId).get();

//       querySnapshot.docs.forEach((doc) {
//         if (doc.data() != null) {
//           // Cast the data to a Map<String, dynamic>
//           final data = doc.data()! as Map<String, dynamic>;
//           String orderId = data['orderId'] ?? doc.id;
//           double totalPrice = data['totalPrice'] ?? 0.0;
//           List<CartItem> items = [];
          
//           data['items'].forEach((item) {
//             items.add(CartItem(
//               name: item['name'],
//               price: item['price'],
//               quantity: item['quantity'],
//             ));
//           });

//           DateTime orderTime = data['orderTime'].toDate();
//           // Create an Order object and add it to the orders list
//           OrderItem order = OrderItem(
//               orderId: orderId,
//               totalPrice: totalPrice,
//               userId: uId,
//               items: items,
//               orderTime: orderTime);
//           orders.add(order);
//         }
//       });
//     } catch (error) {
//       Text('Error fetching orders: $error');
//       print('Error fetching orders: $error');
//     }

//     return orders;
//   }
  Future<List<OrderItem>> fetchOrders(userId) async {
    List<OrderItem> orders = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('orders').where('userId',isEqualTo: userId).get();

      for (var doc in querySnapshot.docs) {
        if (doc.data() != null) {
          // Cast the data to a Map<String, dynamic>
          final data = doc.data()! as Map<String, dynamic>;
          String orderId = data['orderId'] ?? doc.id;
          double totalPrice = data['totalPrice'] ?? 0.0;
          String status = data['status'] ?? 'Pending';
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
