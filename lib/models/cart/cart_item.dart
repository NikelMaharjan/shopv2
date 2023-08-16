

import 'package:hive/hive.dart';
part 'cart_item.g.dart';


@HiveType(typeId: 0)
class CartItem extends HiveObject{

  @HiveField(0)
  String name;

  @HiveField(1)
  int qty;

  @HiveField(2)
  String image;

  @HiveField(3)
  int price;

  @HiveField(4)
  String product;

  CartItem({
    required this.product,
    required this.name,
    required this.image,
    required this.price,
    required this.qty
  });

  factory CartItem.fromJson(Map<String, dynamic> json){
    return CartItem(
        product: json['product'],
        name: json['name'],
        image: json['image'],
        price: json['price'],
        qty: json['qty']
    );
  }

  //converting into map. we send list of CartItems in server. so need to convert into map
  Map<String, dynamic> toJson (){
    return {
      'name': this.name,
      'qty' : this.qty,
      'image': this.image,
      'price': this.price,
      'product': this.product
    };
  }


}
