import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
    String uid= widget.user!.uid;
    List<OrderItem> orders = orderItems.where((item) => item.userId == uid).toList();
   return Scaffold(
      backgroundColor: Color.fromARGB(105, 253, 227, 202),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
          });
        },
        child: ListView.builder(
  itemCount: orders.length,
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
                          'Total Price: \$${order.totalPrice.toStringAsFixed(2)} and Status : ${order.status}' ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                      ),
                    ));
                  }

        ),
      ),
    );
  }
}