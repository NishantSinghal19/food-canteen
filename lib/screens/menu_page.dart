import 'package:flutter/material.dart';
import 'package:food_canteen/models/cart_item.dart';
import 'package:food_canteen/services/firestore_methods.dart';
import 'package:food_canteen/utils/utils.dart';
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
      backgroundColor: Color.fromARGB(105, 253, 227, 202),
      body: 
        FutureBuilder<List<MenuItem>>(
          future: menuItems,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final menuItems = snapshot.data!;
         return ListView.builder(
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            MenuItem menuItem = menuItems[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Border radius value
                color: Color.fromARGB(255, 254, 250, 246) // Background color of the container
                
              ),
              margin: EdgeInsets.fromLTRB(5,5,5,5),
              child: ListTile(
                  title: Text(menuItem.name, style: TextStyle(fontWeight: menuItem.isAvailable ? FontWeight.w500 : FontWeight.normal, fontSize: menuItem.isAvailable ? 18 : 14)),
                  subtitle: Text('\u20B9' + menuItem.price.toString(),  style: TextStyle(fontSize: menuItem.isAvailable ? 14 : 12)),
                  trailing: menuItem.isAvailable ? IconButton(onPressed: () {
                    cartProvider.addToCart(CartItem(
                      name: menuItem.name,
                      price: menuItem.price,
                      quantity: 1,
                    ));
                    showSnackBar('${menuItem.name} added to Cart', context);
                  }, icon: Icon(Icons.add_shopping_cart_rounded, color: Colors.orangeAccent,)) : Text('Not Available', style: TextStyle(color: const Color.fromARGB(255, 255, 123, 123))),
                ),
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
                onChanged: (bool? value) {
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