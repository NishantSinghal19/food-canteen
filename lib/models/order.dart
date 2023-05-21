import 'cart_item.dart';

class Order {
  final String orderId;
  final List<CartItem> items;
  final double totalPrice;
  final DateTime orderTime;
  Order({
    required this.orderId,
    required this.items,
    required this.totalPrice,
    required this.orderTime,
  });
}
