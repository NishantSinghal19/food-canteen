import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../models/user_model.dart';
import 'menu_page.dart';
import 'cart_screen.dart';
import 'admin_panel_screen.dart';

class HomePage extends StatefulWidget {
  final UserModel? user;
  HomePage({super.key, required this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _currentIndex = 0;

  List<MenuItem> cartItems = [];

  void addToCart(MenuItem item) {
    setState(() {
      item.quantity++;
    });
  }

  void removeFromCart(MenuItem item) {
    setState(() {
      if (item.quantity > 0) {
        item.quantity--;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        
      ),
      body: buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
            
          ),
        ],
      ),
    );
  }

   Widget buildBody() {
    switch (_currentIndex) {
      case 0:
        return MenuPage(user: widget.user!);
      case 1:
        return CartScreen();
      case 2:
        return AdminPanelScreen();
      default:
        return Container();
    }
  }

  // Widget buildBottomNavigationBar() {
  //   return BottomNavigationBar(
  //     items: menuItems.map((item) {
  //       return BottomNavigationBarItem(
  //         icon: Icon(Icons.check),
  //         label: item.name,
  //       );
  //     }).toList(),
  //     currentIndex: _selectedIndex,
  //     onTap: (index) {
  //       setState(() {
  //         _selectedIndex = index;
  //       });
  //     },
  //   );
  // }
}
