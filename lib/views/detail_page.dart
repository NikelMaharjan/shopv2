import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/constants/colors.dart';
import 'package:simple_shop/common/show_snack.dart';
import 'package:simple_shop/models/product.dart';
import 'package:simple_shop/providers/auth_provider.dart';
import 'package:simple_shop/providers/cart_provider.dart';

import '../api.dart';



class DetailPage extends StatelessWidget {
  final Product product;
  DetailPage(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [

              Container(
                color: AppColor.blue,

                child: Container(
                  decoration: BoxDecoration(
                      color: AppColor.lightWhite,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                  ),
                  margin: EdgeInsets.only(top: 220),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 20, right: 20, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.product_name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(product.product_detail),
                              ),
                              Text('Rs ${product.product_price}'),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(product.brand),
                              ),
                              Text(product.category),

                            ],
                          ),
                        ),

                        Consumer(
                          builder: (context, ref, child) {

                            final auth = ref.watch(authProvider);
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.blue,
                                ),
                                onPressed: auth.user!.isAdmin ? null : () {
                                  ref.read(cartProvider.notifier).addToCart(product, context);
                                }, child: Text('Add To Cart')
                            );
                          }
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment(0.8, -0.9),
                child: Container(

                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(imageUrl:'${Api.baseUrl}${product.product_image}', fit: BoxFit.cover, height: 220, width: 200,)),
                ),
              )


            ],
          ),
        )
    );
  }
}