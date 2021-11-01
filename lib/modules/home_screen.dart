import 'dart:ui';

import 'package:clothes_app/layout/home_cubit/home_cubit.dart';
import 'package:clothes_app/layout/home_cubit/home_cubit_states.dart';
import 'package:clothes_app/models/product_model.dart';
import 'package:clothes_app/shared/components/components.dart';
import 'package:clothes_app/shared/components/constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:clothes_app/shared/components/constants.dart';

import 'new_product/new_product_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String categoryName = '';
    return BlocConsumer<HomeCubit, HomeLayoutStates>(
      listener: (context, state) {
        if (state is HomeLayoutInitialState) print('HomeLayoutInitialState');
        if (state is ToastMessageState) {
          showToast(
              context: context,
              message: 'you are already rated this product',
              color: Colors.green);
        }
      },
      builder: (context, state) {
        List<ProductModel> topRatedProductsList = [];
        List<ProductModel> productModelList =
            HomeCubit.get(context).productModelList;
        productModelList.forEach((element) {
          if (element.productRate != null) if (element.productRate! >= 3.9)
            topRatedProductsList.add(element);
        });
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userModel.uId == ADMIN_ID)
                Container(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Welcome MR ${userModel.name!.toUpperCase()}',overflow: TextOverflow.ellipsis,maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              navigateTo(context, NewProductScreen());
                            },
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.red.withOpacity(0.4))),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.red,
                                  size: 30.0,
                                ),
                                Text(
                                  'Add a new Product!',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              Container(
                width: double.infinity,
                height: 30.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            categoryName = HomeCubit.get(context)
                                .selectCategoryName(index);
                            HomeCubit.get(context)
                                .selectCategoryColor(index);
                            print('$categoryName');
                            HomeCubit.get(context).displaySpecifiedCategory(
                                category: categoryName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70.0),
                              color: HomeCubit.get(context)
                                  .categoriesColors[index],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                '${HomeCubit.get(context).categories[index]}',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 24.0,
                                ),
                              ),
                            ),
                          )),
                      separatorBuilder: (context, index) => SizedBox(
                            width: 18.0,
                          ),
                      itemCount: 4),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              if (topRatedProductsList.length != 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Top Rated',
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 25.0),
                  ),
                ),
              if (topRatedProductsList.length != 0)
                Container(
                  height: 300.0,
                  color: Colors.white,
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) =>
                        topRatedProducts(context, topRatedProductsList[index]),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10.0,
                    ),
                    itemCount: topRatedProductsList.length,
                  ),
                ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Popular Products ',
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 25.0),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              state is RatingItemLoadingState
                  ? Center(
                      child: Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            Text(
                              'Thank You for Your rate',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => FutureBuilder(
                        future: HomeCubit.get(context).getBuyersMap(
                            productModel: productModelList[index]),
                        builder: (context, snapshot) => productCard(
                            context, productModelList[index], index),
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 10.0,
                      ),
                      itemCount: HomeCubit.get(context).productModelList.length,
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget productCard(context, ProductModel productModel, index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: 270.0,
        child: Stack(
          children: [
            Card(
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
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Image(
                                image: NetworkImage(
                                    '${productModel.productImage}'),
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
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 4.0, top: 2.0),
                      child: Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          RatingBar.builder(
                            initialRating: productModel.productRate!,
                            minRating: 1,
                            itemSize: 25,
                            direction: Axis.horizontal,
                            ignoreGestures: HomeCubit.get(context).isUserFound(
                                mapName: 'ratersMap',
                                productModel: productModel,
                                uId:
                                    userModel.uId ?? ''),
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) async {
                              Map<String, List<String>> map =
                                  await HomeCubit.get(context).getUsersRatedMap(
                                productModel: productModel,
                              );

                              await HomeCubit.get(context)
                                  .getRateCollectionLength(
                                productModel,
                              );
                              await HomeCubit.get(context).ratingItemUpdate(context,
                                rating,
                                productModel
                              );
                            },
                          ),
                          Text(
                            '${productModel.productRate!.toStringAsFixed(1)}',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontSize: 20.0, color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            '${(productModel.productPrice)}',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontSize: 20.0, color: Colors.white),
                          ),
                          IconButton(
                              onPressed: () {
                                HomeCubit.get(context)
                                    .addProductToCart(productModel);
                              },
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                color: HomeCubit.get(context).isBuyerFound(
                                        productModel: productModel,
                                        uId: userModel
                                                .uId ??
                                            '')
                                    ? Colors.amber
                                    : Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (userModel.uId == ADMIN_ID)
              Padding(
                padding: const EdgeInsets.only(top: 7.0,right: 7.0),
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Container(
                    width: 150,
                    height: 50,
                    child: DropdownButton<String>(
                      icon: Icon(Icons.view_headline_rounded,color: Colors.white,),
                      underline: Container(
                      ),

                      // validator: (value) {
                      //   if (value == '' || value == null)
                      //     return 'please select a category';
                      //   else
                      //     return null;
                      // },
                      iconSize: 30.0,
                      items: <String>['Update', 'Delete']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Icon((value=='Update') ?Icons.upload_outlined:Icons.delete_outline_sharp),
                              SizedBox(width: 5.0,),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget topRatedProducts(
    context,
    ProductModel productModel,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        elevation: 15.0,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Image(
                  image: NetworkImage('${productModel.productImage}'),
                  height: 280.0,
                  width: double.infinity,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.5),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ' ${productModel.productName} ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 24.0,
                        ),
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: productModel.productRate!,
                            minRating: 1,
                            itemSize: 22,
                            direction: Axis.horizontal,
                            ignoreGestures: HomeCubit.get(context).isUserFound(
                                mapName: 'ratersMap',
                                productModel: productModel,
                                uId:
                                    userModel.uId ?? ''),
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) async {
                              Map<String, List<String>> map =
                                  await HomeCubit.get(context).getUsersRatedMap(
                                productModel: productModel,
                              );

                              await HomeCubit.get(context)
                                  .getRateCollectionLength(
                                productModel,
                              );
                              await HomeCubit.get(context).ratingItemUpdate(context,
                                rating,
                                productModel,
                              );
                              print(
                                  '${productModel.usersRatedIds} user rated ids');
                            },
                          ),
                          Text(
                            '${productModel.productRate!.toStringAsFixed(1)}',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontSize: 20.0, color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            '${(productModel.productPrice)}',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontSize: 20.0, color: Colors.white),
                          ),
                          IconButton(
                              onPressed: () {
                                HomeCubit.get(context)
                                    .addProductToCart(productModel);
                                print('${productModel.productId}prod idddddd');
                              },
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                color: HomeCubit.get(context).isBuyerFound(
                                        productModel: productModel,
                                        uId: userModel
                                                .uId ??
                                            '')
                                    ? Colors.amber
                                    : Colors.white,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
