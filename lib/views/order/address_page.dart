

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_shop/constants/colors.dart';
import 'package:simple_shop/constants/font.dart';
import 'package:simple_shop/providers/common_provider.dart';
import 'package:simple_shop/providers/order_provider.dart';
import 'package:simple_shop/validation.dart';
import 'package:simple_shop/views/auth/signup_page.dart';

import '../../common/show_snack.dart';
import '../../providers/auth_provider.dart';
import '../../providers/form_validation_provider.dart';
import 'package:get/get.dart';


class AddressPage extends ConsumerStatefulWidget with Validation {
  AddressPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends ConsumerState<AddressPage> {
  final addressController = TextEditingController();

  final cityController = TextEditingController();


  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final deviceheight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final devicewidth = MediaQuery.of(context).size.width;

    final isVisible = ref.watch(validateProvider);
    final auth = ref.watch(authProvider);
    final mode = ref.watch(modeProvider);


    ref.listen(authProvider, (previous, next) {    //this is like stream. continuous watching. next is new state value
      if(next.isError){
        CommonSnack.errrorSnack(context: context, msg: next.errText);
      }else if(next.isSuccess){
        Get.back();
        CommonSnack.successSnack(context: context, msg: 'successfully added');
      }


    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Shipment form"),
        ),
          resizeToAvoidBottomInset: true,
          //  backgroundColor: Colors.white,
          body: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 10,
              child: SizedBox(
                //  color: Colors.red,
                height:  deviceheight * 0.48,
                child: (
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          //  color: Colors.red,
                          height:  deviceheight * 0.42,
                          child: Form(
                            key: _form,
                            autovalidateMode: mode,
                            child: Column(

                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 60.0),
                                  child: Text('Address Page',
                                    style: AppFont.loginSignupText,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),


                                _buildTextFormField(
                                    obscureText: false,
                                    controller: addressController,
                                    hintText: 'address',
                                    validator: widget.validateUserName,
                                    prefixIcon: CupertinoIcons.mail),

                                _buildTextFormField(
                                    controller:  cityController,
                                    hintText: "city",
                                    validator: widget.validateUserName,
                                    obscureText: isVisible,
                                    prefixIcon: CupertinoIcons.padlock,
                                ),
                              ],
                            ),
                          ),
                        ),



                        Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(
                                            15)), // <-- Radius
                                  ),
                                  backgroundColor: const Color(0xff4252B5),
                                  minimumSize: const Size(double.infinity, 0),
                                ),
                                onPressed:  auth.isLoad ? null : ()  {
                                  _form.currentState!.save();
                                  if(_form.currentState!.validate()){
                                    ref.read(authProvider.notifier).userUpdate(
                                      shippingAddress: {
                                        'address': addressController.text.trim(),
                                        'city': cityController.text.trim(),
                                        'isEmpty': false
                                      },
                                      token: auth.user!.token
                                    );
                                  }
                                  else{
                                    ref.read(modeProvider.notifier).changeMode();
                                  }
                                },

                                child: auth.isLoad ? CircularProgressIndicator() : const Text("Submit")))
                      ],
                    )
                ),
              ),
            ),
          )
      ),
    );
  }

  Widget _buildTextFormField({required IconData prefixIcon, required bool obscureText,  VoidCallback? onTap, String? Function(String?)? validator, IconData? suffixIcon,  required String hintText, required TextEditingController controller}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            validator: validator,
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintText: hintText,
                prefixIcon: Icon(
                  prefixIcon,
                  color: Colors.black,
                ),
                suffixIcon: IconButton(
                  icon: Icon(suffixIcon),
                  onPressed: onTap,
                  color: Colors.black,
                )
            ),
          ),
        ),

        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
