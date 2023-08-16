

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:simple_shop/common/show_snack.dart';
import 'package:simple_shop/models/product.dart';
import 'package:simple_shop/views/main.dart';

import '../models/cart/cart_item.dart';





final cartProvider = StateNotifierProvider<CartProvider, List<CartItem>>((ref) => CartProvider(ref.watch(boxA)));

class CartProvider extends StateNotifier<List<CartItem>>{
  CartProvider(super.state);

  void addToCart(Product product, BuildContext context){
    if(state.isEmpty){
      final newCartItem = CartItem(
          product: product.id,
          name: product.product_name,
          image: product.product_image,
          price: product.product_price,
          qty: 1
      );
      Hive.box<CartItem>('carts').add(newCartItem);   //to add to hive
      state = [newCartItem];   //to change the state/display in app
      CommonSnack.successSnack(context: context,msg:  'Successfully added to cart', isCart: true);
    }else{
      final isThere = state.firstWhereOrNull((element) => element.product == product.id);
      if(isThere == null){
        final newCartItem = CartItem(
            product: product.id,
            name: product.product_name,
            image: product.product_image,
            price: product.product_price,
            qty: 1
        );
        Hive.box<CartItem>('carts').add(newCartItem);
        state = [...state, newCartItem];
        CommonSnack.successSnack(context: context,msg:  'Successfully added to cart', isCart: true);
      }else{
        CommonSnack.successSnack(context: context,msg:  'Already added to cart', isCart: true);
      }

    }

  }


  void singleAdd(CartItem cartItem){
    cartItem.qty = cartItem.qty + 1;
    cartItem.save();
    state = [
      for(final c in state) c.product == cartItem.product ? cartItem : c
    ];
  }
  void singleRemove(CartItem cartItem){
    if(cartItem.qty > 1){
      cartItem.qty = cartItem.qty - 1;
      cartItem.save();
      state = [
        for(final c in state) c.product == cartItem.product ? cartItem : c
      ];
    }
  }

  void removeFromCart(CartItem cartItem){
    cartItem.delete();
    state.remove(cartItem);
    state = [...state];
  }

  int get totalAmount{
    int total = 0;
    state.forEach((element) {
      total += element.qty * element.price;
    });
    return total;
  }


  void clearCart(){
    Hive.box<CartItem>('carts').clear();
    state = [];
  }






}