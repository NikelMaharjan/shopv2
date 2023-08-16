import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/api.dart';
import 'package:simple_shop/constants/colors.dart';
import 'package:simple_shop/common/show_snack.dart';
import 'package:simple_shop/providers/auth_provider.dart';
import 'package:simple_shop/providers/cart_provider.dart';
import 'package:simple_shop/providers/common_provider.dart';
import 'package:get/get.dart';


class CartPage extends ConsumerWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final cartData = ref.watch(cartProvider);
    final totalData = ref.watch(cartProvider.notifier).totalAmount;
    final auth = ref.watch(authProvider);
    final isLoad = ref.watch(loadingProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: cartData.isEmpty ?  Center(child: Text("Empty! Add Items to Cart", style: TextStyle(color: Colors.grey),),) :  Column(
          children: [
            Expanded(
              child:   ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: cartData.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 6),

                            height: 120,
                            child: Row(
                              children: [
                                Container(
                                    child: Image.network("${Api.baseUrl}${cartData[index].image}", width: 160,)),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(cartData[index].name, style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18 ),),
                                      Container(
                                          margin: EdgeInsets.symmetric(vertical: 6),
                                          child: Text('Rs.${cartData[index].price}', style: TextStyle(fontSize: 12),)),
                                      Row(
                                        children: [
                                          OutlinedButton(
                                              onPressed: () {
                                                ref.read(cartProvider.notifier).singleAdd(cartData[index]);
                                              },
                                              child: Icon(Icons.add, color: AppColor.blue,)),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Text('${cartData[index].qty}'),
                                          ),
                                          OutlinedButton(
                                              onPressed: () {
                                                ref.read(cartProvider.notifier).singleRemove(cartData[index]);
                                              },
                                              child: Icon(Icons.remove, color: AppColor.blue,))
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(icon: Icon(Icons.clear, color: AppColor.blue,), onPressed: (){
                                ref.read(cartProvider.notifier).removeFromCart(cartData[index]);
                              },),
                            )),
                      ],
                    );
                  }),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Total'), Text('Rs. ${totalData}')],
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColor.blue),
                    onPressed: (){

                    },
                    child: isLoad ? Text("Please wait") : Text('Check Out'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
