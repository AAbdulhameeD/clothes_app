import 'package:clothes_app/layout/home_cubit/home_cubit.dart';
import 'package:clothes_app/layout/home_cubit/home_cubit_states.dart';
import 'package:clothes_app/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeLayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          List<ProductModel> cartProductsList =
              HomeCubit.get(context).cartProductsList;

          if (
              state is GetCartProductsLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (cartProductsList.length == 0){
            return Center(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_objects_outlined,size: 150,color: Colors.amber.withOpacity(.6),),
                  SizedBox(height: 20.0,),
                  Text('Oops! you don\'t have any product in your cart yet.',style: Theme.of(context).textTheme.caption!.copyWith(fontSize:22 ,fontWeight: FontWeight.bold),),
                ],
              ),
            )

              ,);
          } else {
            return ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return productCard(context, cartProductsList[index], index);
                },
                separatorBuilder: (context, index) => SizedBox(
                      height: 10.0,
                    ),
                itemCount: cartProductsList.length);
          }
        });
  }

  Widget productCard(context, ProductModel productModel, index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: 270.0,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5.0,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            width: double.infinity,
            color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Colors.purple.withOpacity(0.3),
                      //     Colors.grey.withOpacity(0.5),
                      //     Colors.grey.withOpacity(0.9),
                      //     Colors.black,
                      //     Colors.black,
                      //   ],
                      //   begin: FractionalOffset.topCenter,
                      //   end: FractionalOffset.bottomCenter,
                      //   stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                      // ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Image(
                            image: NetworkImage('${productModel.productImage}'),
                            height: 190.0,
                            width: double.infinity,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Text(
                          ' ${productModel.productName} ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            backgroundColor: Colors.black.withOpacity(0.2),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0,right: 4.0 ,top: 2.0),
                  child: Container(width: double.infinity,height: 1.0,color: Colors.white,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Row(
                            children: [
                              Text(
                                '${productModel.productRate!.toStringAsFixed(1)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        fontSize: 20.0, color: Colors.black),
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        '${(productModel.productPrice)}',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: 20.0, color: Colors.white),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'CONFIRM',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ),
                      IconButton(
                          onPressed: () {
                            HomeCubit.get(context).deleteCartProduct(productModel);
                          },
                          icon: Icon(
                            Icons.delete_outline_sharp,
                            color: Colors.white,
                            size: 30.0,
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
