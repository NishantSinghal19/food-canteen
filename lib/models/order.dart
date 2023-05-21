import 'cart_item.dart';

class OrderItem {
  final String orderId;
  final List<CartItem> items;
  final double totalPrice;
  final DateTime orderTime;
  OrderItem({
    required this.orderId,
    required this.items,
    required this.totalPrice,
    required this.orderTime,
  });
  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "items": items.map((item) => item.toJson()).toList(),
        "totalPrice": totalPrice,
        "orderTime": orderTime,
      };
    static OrderItem? fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderId: json['orderId'],
      items: json['items'].map<CartItem>((item) => CartItem.fromSnap(item)).toList(),
      totalPrice: json['totalPrice'],
      orderTime: json['orderTime'].toDate(),
    );
}
}
