import 'package:clothes_app/shared/components/components.dart';
import 'package:clothes_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class NewProductScreen extends StatelessWidget {
  var productNameController = TextEditingController();
  var productPriceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String category = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewProductCubit(),
      child: BlocConsumer<NewProductCubit, NewProductStates>(
        listener: (context, state) {
          if (state is CreateProductSuccessState)
            {

              showToast(context: context, message: 'Product added successfully',color: Colors.green);
              formKey.currentState!.reset();
              productPriceController.clear();
              productNameController.clear();
              NewProductCubit.get(context).productImageFile=null;

            }
          if (state is CreateProductErrorState)
            showToast(context: context, message: 'Failed ,please try again',color: Colors.red);

        },
        builder: (context, state) {
          return Scaffold(
              body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Prepare Your new Product please:'.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 2),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Select Category:'.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              wordSpacing: 2),
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          validator: (value) {
                            if (value == '' || value == null)
                              return 'please select a category';
                            else
                              return null;
                          },
                          iconSize: 30.0,
                          items: <String>['children', 'men', 'women']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            category = value!;
                            print(value);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextFormField(
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        controller: productNameController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter the product Name';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              letterSpacing: 1.0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          prefixIcon: Icon(
                            Icons.drive_file_rename_outline,
                            color: Colors.grey,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      controller: productPriceController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter the product Price';
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Product Price',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            letterSpacing: 1.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        prefixIcon: Icon(
                          Icons.price_check,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Select Product Image:'.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              wordSpacing: 2),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            NewProductCubit.get(context).getProductImage();
                          },
                          icon: Icon(
                            Icons.image,
                            color: Colors.red.withOpacity(.5),
                            size: 30.0,
                          ))
                    ],
                  ),
                  if (NewProductCubit.get(context).productImageFile != null)
                    Container(
                      height: 400.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.4),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                        image: DecorationImage(
                          image: FileImage(
                              NewProductCubit.get(context).productImageFile!),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: defaultButton(
                        buttonFunction: () {
                          if (formKey.currentState!.validate()) {
                            if (NewProductCubit.get(context).productImageFile !=
                                null){
                              NewProductCubit.get(context).createProduct(
                                productCategory: category,
                                productPrice: productPriceController.text + ' EGP',
                                productName: productNameController.text,
                              );


                            }else{
                              showToast(context: context, message: 'please select an image',color: Colors.red);
                            }
                          }
                        },
                        buttonWidget:
                        ( state is CreateProductLoadingState)? Center(child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: CircularProgressIndicator(color: Colors.white,strokeWidth: 15,),
                        )): Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            'Upload Now'.toUpperCase(),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 22.0),
                          ),
                        ),
                        color: Colors.red)
                    ,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}
