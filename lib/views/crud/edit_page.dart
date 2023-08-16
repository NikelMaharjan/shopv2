import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/api.dart';
import 'package:simple_shop/constants/colors.dart';
import 'package:simple_shop/common/show_snack.dart';
import 'package:simple_shop/models/product.dart';
import 'package:simple_shop/providers/auth_provider.dart';
import 'package:simple_shop/providers/product_provider.dart';
import 'package:simple_shop/services/product_service.dart';
import 'package:simple_shop/validation.dart';
import 'package:get/get.dart';

import '../../../providers/common_provider.dart';


class EditPage extends ConsumerStatefulWidget with Validation {
  Product product;
  EditPage(this.product);

  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {
  final nameController = TextEditingController();

  final detailController = TextEditingController();

  final priceController = TextEditingController();

  final stockController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode detailFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode stockFocus = FocusNode();


  final _form = GlobalKey<FormState>();

  final category = ['Mobile', 'TV', 'Laptop ' ];

  final brand = ['Nike', 'Addidas', 'Jordan' ];

  String brandValue = "Jordan";
  String categoryValue = "Mobile";

  @override
  void initState() {
    nameController..text = widget.product.product_name;
    detailController..text = widget.product.product_detail;
    priceController..text = widget.product.product_price.toString();
    stockController..text = widget.product.countInStock.toString();
    brandValue = widget.product.brand;
    categoryValue = widget.product.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final deviceheight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final devicewidth = MediaQuery.of(context).size.width;

    final image = ref.watch(imageProvider);
    final crud = ref.watch(crudProvider);
    final auth = ref.watch(authProvider);
    final mode = ref.watch(modeProvider);


    ref.listen(crudProvider, (previous, next) {
      if(next.isError){
        CommonSnack.errrorSnack(context: context,msg:  next.errText);
      }else if(next.isSuccess){
        ref.invalidate(productProvider);
        CommonSnack.successSnack(context: context,msg:  'successfully added');
        Get.back();
      }
    });

    return SafeArea(
      child: Scaffold(

          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Add Products"),
            elevation: 0,
          ),
          //  backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: (
                  Column(
                    children: [
                      Form(
                        key: _form,
                        autovalidateMode: mode,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),

                            _buildTextFormField(
                              focus: nameFocus,
                              controller: nameController,
                              labelText: 'Product Name',
                              validator: widget.validateUserName,
                              suffixIcon: Icons.clear,
                            ),


                            _buildTextFormField(
                              focus: detailFocus,
                              maxLines: 2,
                              controller: detailController,
                              labelText: 'Product Detail',
                              validator: widget.validateDescription,
                              suffixIcon:  Icons.clear,
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFormField(
                                    focus: priceFocus,
                                    controller: priceController,
                                    isPrice: true,
                                    labelText: 'Price',
                                    validator: widget.validatePrice,
                                    suffixIcon: Icons.clear,
                                  ),
                                ),

                                SizedBox(width: 20,),

                                Expanded(
                                  child: _buildTextFormField(
                                    focus: stockFocus,
                                    controller: stockController,
                                    isPrice: true,
                                    labelText: 'stock',
                                    validator: widget.validateStock,
                                    suffixIcon: Icons.clear,
                                  ),
                                ),
                              ],
                            ),



                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Select Brand"),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: brandValue,
                                      items: brand.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                          ),
                                        );
                                      }).toList(),

                                      onChanged: (String? newValue) {
                                        setState(() {
                                          brandValue = newValue!;

                                        });


                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),



                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Select Category"),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: categoryValue,
                                      items: category.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                          ),
                                        );
                                      }).toList(),

                                      onChanged: (String? newValue) {
                                        setState(() {
                                          categoryValue = newValue!;

                                        });


                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),


                            SizedBox(height: 10,),


                            Container(
                              height: 200,
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white
                                  ),
                                  onPressed: (){
                                    showDialog(context: context, builder: (context){
                                      return AlertDialog(
                                        title: Text('choose option'),
                                        actions: [
                                          TextButton(
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                                ref.read(imageProvider.notifier).pickAnImage(true);
                                              }, child: Text('camera')),
                                          TextButton(
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                                ref.read(imageProvider.notifier).pickAnImage(false);
                                              }, child: Text('gallery')),
                                        ],
                                      );
                                    });
                                  },
                                  child: image != null ? Image.file(File(image.path)) : Center(child: Image.network('${Api.baseUrl}${widget.product.product_image}')),),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),



                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff4252B5),
                            minimumSize: const Size(double.infinity, 40),
                          ),
                          onPressed:  crud .isLoad ? null : ()  async {
                            _form.currentState!.save();
                            if(_form.currentState!.validate()){

                              if(image == null){

                                ref.read(crudProvider.notifier).updateProduct(
                                  product_name: nameController.text.trim(),
                                  product_detail: detailController.text.trim(),
                                  product_price: int.parse(priceController.text.trim()),
                                  brand: brandValue,
                                  category: categoryValue,
                                  countInStock: int.parse(stockController.text.trim()),
                                  token: auth.user!.token,
                                  productId: widget.product.id,
                                );

                              }

                              else{


                                ref.read(crudProvider.notifier).updateProduct(
                                    product_name: nameController.text.trim(),
                                    product_detail: detailController.text.trim(),
                                    product_price: int.parse(priceController.text.trim()),
                                    product_image: image,
                                    brand: brandValue,
                                    category: categoryValue,
                                    countInStock: int.parse(stockController.text.trim()),
                                    token: auth.user!.token,
                                    productId: widget.product.id,
                                    oldImage: widget.product.product_image,
                                );

                              }

                            }

                            else {
                              ref.read(modeProvider.notifier).changeMode();
                            }




                          },
                          child: crud.isLoad ? CircularProgressIndicator() : const Text("Submit"))
                    ],
                  )
              ),
            ),
          )
      ),
    );
  }

  Widget _buildTextFormField({ bool? isPrice, required FocusNode focus, int? maxLines,  String? Function(String?)? validator, required IconData suffixIcon,  String? labelText, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: isPrice == true ? TextInputType.number : TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: validator,
        controller: controller,
        maxLines: maxLines ?? 1,
        focusNode: focus,



        decoration: InputDecoration(
            helperText: "",
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,


            hintText: labelText,
            // labelStyle: TextStyle(
            //     fontSize: focus.hasFocus ? 10 : 22,
            //     color: AppColor.blue
            // ),


            contentPadding: isPrice == null ? null : EdgeInsets.symmetric(horizontal: 10) ,

            focusedBorder:  OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppColor.blue),
            ),




            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.blue),
            ),


            errorBorder:  OutlineInputBorder(
              borderSide:  BorderSide(
                  color: Colors.red),
            ),


            focusedErrorBorder:  OutlineInputBorder(
              borderSide:  BorderSide(
                  color: Colors.red),
            ),



            suffixIcon: focus.hasFocus ? IconButton(
              icon: Icon(suffixIcon),
              onPressed: (){
                controller.clear();
              },

              color: Colors.grey,

            ) : null
        ),
      ),
    );
  }
}