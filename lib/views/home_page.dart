import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:simple_shop/constants/colors.dart';
import 'package:simple_shop/providers/auth_provider.dart';
import 'package:simple_shop/services/product_service.dart';
import 'package:simple_shop/views/cart_page.dart';
import 'package:simple_shop/views/detail_page.dart';
import 'package:simple_shop/views/product_list.dart';

import '../api.dart';
import '../providers/cart_provider.dart';









class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ref, child) {
          final productData = ref.watch(productProvider);
          final authData = ref.watch(authProvider);
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                actions: [
                  if(!authData.user!.isAdmin) IconButton(onPressed: (){
                    Get.to(() => CartPage());
                   }, icon: Icon(Icons.shopping_cart))
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: AppColor.blue,
                      ),
                      accountName: Text(authData.user!.isAdmin ? '${authData.user!.fullname} (Admin)' :authData.user!.fullname , style: TextStyle(fontSize: 18),),
                      accountEmail: Text(authData.user!.email),
                      currentAccountPicture:   CircleAvatar(
                        radius: 25,
                        child: Text(authData.user!.fullname.substring(0,1).toUpperCase()),
                      ),

                    ),




                    if(authData.user!.isAdmin) ListTile(
                      onTap: () {
                        Get.back();
                        Get.to(() => ProductList(), transition: Transition.leftToRight);

                      },
                      leading: Icon(Icons.account_balance_wallet, color: AppColor.blue,),
                      title: Text('Product List'),
                    ),
                    ListTile(
                      onTap: () {
                        ref.read(authProvider.notifier).userLogOut();
                        ref.read(cartProvider.notifier).clearCart();
                      },
                      leading: Icon(Icons.exit_to_app, color: AppColor.blue,),
                      title: Text('User Log Out'),
                    ),


                  ],
                ),
              ),
              body:  Container(
                child:   productData.when(
                    data: (data) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: data.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.679
                            ),
                            itemBuilder: (context, index){
                              final product = data[index];
                              return  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Get.to(()=> DetailPage(product), transition: Transition.leftToRight);
                                    },
                                    child: Card(
                                      elevation: 2,

                                      child: SizedBox(
                                        height: 200,
                                        width:  200,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: CachedNetworkImage(
                                            placeholder: (c, s) => Center(child: const CircularProgressIndicator()),
                                            imageUrl: '${Api.baseUrl}${product.product_image}', fit: BoxFit.fitWidth,),
                                        ),

                                      ),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      child: Text(data[index].product_name, style: const TextStyle(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis,)),
                                  Text("Rs ${product.product_price.toString()}", style: const TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis,),
                                ],
                              );
                            }
                        ),
                      );
                    },
                    error: (err, stack) => Center(child: Text('$err')),
                    loading: () => Center(child: CircularProgressIndicator())
                ),
              )


          );
        }
    );
  }
}