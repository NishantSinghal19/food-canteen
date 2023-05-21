import 'package:flutter/material.dart';
import 'package:food_canteen/models/cart_item.dart';
import 'package:food_canteen/services/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../models/menu_item.dart';
import '../models/user_model.dart';
import 'cart_screen.dart';

class MenuPage extends StatefulWidget {
final UserModel user;
  MenuPage({super.key, required this.user});
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

    // User object to determine role

  List<CartItem> cartItems = [];
  Future<List<MenuItem>> menuItems = FirestoreMethods().getItemList();

  @override
  Widget build(BuildContext context) {
     final cartProvider = Provider.of<CartProvider>(context, listen: false);
    bool isAdmin = widget.user.role == Userrole.customer;

    return Scaffold(
      body: 
        FutureBuilder<List<MenuItem>>(
          future: menuItems,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            final menuItems = snapshot.data!;
         return ListView.builder(
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            MenuItem menuItem = menuItems[index];
            return ListTile(
              title: Text(menuItem.name),
              subtitle: Text(menuItem.price.toString()),
              trailing: Text(menuItem.isAvailable ? 'Available' : 'Not Available'),
              
              onTap: () {
                cartProvider.addToCart(CartItem(
                  name: menuItem.name,
                  price: menuItem.price,
                  quantity: 1,
                ));
              },
            );
          },
        );
          },
        ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                // Handle the action for adding menu items
                _showAddMenuItemDialog(context);
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  void _addToCart(MenuItem menuItem) {
    setState(() {
      cartItems.add(CartItem(
        name: menuItem.name,
        price: menuItem.price,
        quantity: 1,
      ));
    });
    // Show a snackbar or any other notification to indicate that the item has been added to the cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to cart: ${menuItem.name}'),
      ),
    );
  }
  void _showAddMenuItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String itemName= '';
        double itemPrice= 0.0;
        bool itemAvailability = false;
        String itemQuantity= '';
        return AlertDialog(
          title: Text('Add Menu Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  itemName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Item Name',
                ),
              ),
              TextField(
                onChanged: (value) {
                  itemPrice = double.parse(value);
                },
                decoration: InputDecoration(
                  labelText: 'Item Price',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                onChanged: (value) {
                  itemQuantity = value;
                },
                decoration: InputDecoration(
                  labelText: 'Item Quantity',
                ),
                keyboardType: TextInputType.number,
              ),
              CheckboxListTile(
                value: itemAvailability,
                onChanged: (value) {
                  setState(() {
                    itemAvailability = value!;
                  });
                },
                title: Text('Availability'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Create a new menu item object
              
                MenuItem newItem = MenuItem(
                  name: itemName,
                  price: itemPrice,
                  isAvailable: itemAvailability,
                  quantity: int.parse(itemQuantity),
                );

                await FirestoreMethods()
          .addnewitem(itemName, itemPrice, itemAvailability,int.parse(itemQuantity));
                // Add the new menu item to the list
                setState(() {
                  menuItems = FirestoreMethods().getItemList();
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}