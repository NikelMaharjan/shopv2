
import 'package:simple_shop/models/cart/cart_item.dart';



class Orders{

  final List<CartItem> orderItems;
  final int totalPrice;

  Orders({
    required this.orderItems,
    required this.totalPrice
  });

  factory Orders.fromJson(Map<String, dynamic> json){
    return Orders(
        orderItems: (json['orderItems'] as List).map((e) => CartItem.fromJson(e)).toList(),
        totalPrice: json['totalPrice']
    );
  }


}