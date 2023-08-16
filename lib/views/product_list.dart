

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart';
import 'package:simple_shop/common/show_snack.dart';
import 'package:simple_shop/constants/colors.dart';
import 'package:simple_shop/providers/auth_provider.dart';
import 'package:simple_shop/providers/product_provider.dart';
import 'package:simple_shop/services/product_service.dart';
import 'package:simple_shop/views/crud/create_page.dart';

import '../api.dart';
import 'crud/edit_page.dart';




class ProductList extends ConsumerWidget {

  const ProductList({Key? key}) : super(key: key);







  @override
  Widget build(BuildContext context, ref) {

    ref.listen(crudProvider, (previous, next) {
      if(next.isError){
        CommonSnack.errrorSnack(context: context,msg:  next.errText);
      }else if(next.isSuccess){
        ref.invalidate(productProvider);
        CommonSnack.successSnack(context: context,msg:  'successfully deleted');
      }
    });

    final productDb = ref.watch(productProvider);
    final auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Customize"),
        elevation: 0,
        actions: [
          TextButton(onPressed: (){

            Get.to(()=> CreatePage(), transition: Transition.leftToRight);

           }, child: Text("Add Products", style: TextStyle(color: AppColor.lightWhite),))
        ],
      ),
      body: Container(
        child: productDb.when(
            data: (data){
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index){
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ListTile(
                          leading:Card(child: CachedNetworkImage(imageUrl: '${Api.baseUrl}${data[index].product_image}', width: 80)),
                          title: Text(data[index].product_name,),
                          trailing: Container(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(onPressed: (){
                                 Get.to(EditPage(data[index]), transition: Transition.leftToRight);
                                }, icon: Icon(Icons.edit)),
                                IconButton(onPressed: ()  {

                                  showDialog(context: context, builder: (context){
                                    return AlertDialog(
                                      elevation: 0,
                                      title: Text('Delete'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {

                                              Navigator.of(context).pop();
                                              ref.read(crudProvider.notifier).removeProduct(
                                                  oldImage: data[index].product_image,
                                                  productId: data[index].id,
                                                  token: auth.user!.token
                                              );


                                            }, child: Text('Yes')),
                                        TextButton(
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            }, child: Text('No')),
                                      ],
                                    );
                                  });

                                }, icon: Icon(Icons.delete)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              );
            },
            error: (err, stack) => Center(child: Text('$err')),
            loading: () => Center(child: CircularProgressIndicator())
        ),
      ),
    );
  }
}