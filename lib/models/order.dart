import 'cart_item.dart';

class OrderItem {
  final String orderId;
  final List<CartItem> items;
  final double totalPrice;
  final String userId;
  final DateTime orderTime;
  String status; //Pending, Accepted, Ready, Declined
  OrderItem({
    required this.orderId,
    required this.items,
    required this.totalPrice,
    required this.userId,
    required this.orderTime,
    this.status = 'Pending'
  });
  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "items": items.map((item) => item.toJson()).toList(),
        "totalPrice": totalPrice,
        "userId": userId,
        "orderTime": orderTime,
        "status": status,
      };
    static OrderItem? fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderId: json['orderId'],
      items: json['items'].map<CartItem>((item) => CartItem.fromSnap(item)).toList(),
      totalPrice: json['totalPrice'],
      userId: json['userId'],
      orderTime: json['orderTime'].toDate(),
      status: json['status'],
    );
}
}
