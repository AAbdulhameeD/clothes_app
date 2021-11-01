import 'package:clothes_app/layout/home_cubit/categories/categories.dart';
import 'package:clothes_app/layout/home_cubit/products/products.dart';
import 'package:clothes_app/models/product_model.dart';
import 'package:clothes_app/models/user_model.dart';
import 'package:clothes_app/modules/cart_screen.dart';
import 'package:clothes_app/modules/home_screen.dart';
import 'package:clothes_app/modules/settings_screen.dart';
import 'package:clothes_app/shared/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_cubit_states.dart';

class HomeCubit extends Cubit<HomeLayoutStates> {
  HomeCubit() : super(HomeLayoutInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    CartScreen(),
    SettingsScreen(),
  ];
  List<String> titles = [
    'Home Screen',
    'Cart Screen',
    'Settings Screen',
  ];
  List<String> categories = [
    'All',
    'Children',
    'Men',
    'Women',
  ];
  final _userCartInstance = FirebaseFirestore.instance
      .collection('users')
      .doc(uId)
      .collection('cart');
  final _userInstance = FirebaseFirestore.instance.collection('users').doc(uId);
   final categoriesReference =
      FirebaseFirestore.instance.collection('categories').doc('$CATEGORIES_ID');

  void changeNavBarItem(int index) {
    currentIndex = index;
    if (index == 1) getCartProducts();
    emit(HomeLayoutChangeNavBarState());
  }

  ProductModel productModel = ProductModel();
  List<ProductModel> productModelList = [];

  void displaySpecifiedCategory( {String? category}) {
    switch (category) {
      case 'children':
        productModelList.clear();

        getProductData('children');
        break;
      case 'women':
        productModelList.clear();

        getProductData('women');
        break;
      case 'men':
        productModelList.clear();

        getProductData('men');
        break;
      case 'all':
        productModelList.clear();

        getProductData('men');
        getProductData('women');
        getProductData('children');
        break;
      default:
        productModelList.clear();
        getProductData('men');
        getProductData('women');
        getProductData('children');
        break;
    }
    emit(DisplaySpecifiedCategoryState());  }


  String categoryName = '';
  List<Color> categoriesColors = [
    Colors.red,
    Colors.amber,
    Colors.amber,
    Colors.amber,
  ];
  int previousIndex = 0;

  String selectCategoryName(int index) {
    categoryName = Categories.getCategoryName(index);
    return categoryName;
  }

  void selectCategoryColor(index) {
    Categories.selectCategoryColor(categoriesColors, index);
    emit(SelectCategoryState());
  }

  void getUserData() {
    emit(HomeGetUserDataLoadingState());

    if (uId != '') {
      _userInstance.get().then((value) {
        userModel = UserModel.fromJson(value.data());
        emit(HomeGetUserDataSuccessState());
      }).catchError((error) {
        emit(HomeGetUserDataErrorState());
      });
    }
  }

  void getProductData(String category) {
    categoriesReference.collection('$category').get().then((value) {
      _fillProductList(value);
      emit(GetProductsSuccessState());
    }).catchError((error) {
      print('$error  col error');
      emit(GetProductsErrorState());
    });
  }

  void _fillProductList(QuerySnapshot value) {
    value.docs.forEach((element) {
      element.reference.get().then((value) {
        productModelList.add(ProductModel.fromJson(value));
        emit(GetProductsSuccessState());
      }).catchError((error) {
        print('$error  col error');
        emit(GetProductsErrorState());
      });
    });
  }

  void addProductToCart(ProductModel productModel) {
    _userCartInstance
        .doc(productModel.productId)
        .set(productModel.toMap(productModel))
        .then((value) async {
      addUserToRateCollection(
          setMap: {'inCart': true},
          productModel: productModel,
          collectionName: 'buyers');
      Map<String, List<String>> map =
          await getBuyersMap(productModel: productModel);
      print('$map the map');
      emit(AddProductToCartSuccessState());
    }).catchError((error) {
      print('$error addProductToCart ');
      emit(AddProductToCartErrorState());
    });
  }

  List<ProductModel> cartProductsList = [];

  void getCartProducts() {
    emit(GetCartProductsLoadingState());
    _userCartInstance.get().then((value) {
      cartProductsList.clear();
      value.docs.forEach((element) {
        cartProductsList.add(ProductModel.fromJson(element));
      });
      emit(GetCartProductsSuccessState());
    }).catchError((error) {
      emit(GetCartProductsErrorState());
    });
  }

  void deleteCartProduct(ProductModel productModel) {
    emit(DeleteCartItemLoadingState());
    print('${productModel.productId} product id');

    _userCartInstance.doc('${productModel.productId}').delete().then((value) {
      deleteUserFromBuyersList(productModel: productModel);
      getUsersList(productModel: productModel, collectionName: 'buyers');
      getCartProducts();
      emit(DeleteCartItemSuccessState());
    }).catchError((error) {
      emit(DeleteCartItemErrorState());
    });
  }

  double itemRating = 1;
  int? length;
  List<String> usersList = [];
  List<String> buyersList = [];
  List<Map<String, dynamic>> listOfRatedUsers = [];
  Map<String, dynamic> usersRateMap = {};
  Map<String, List<String>> ratersMap = {};
  Map<String, List<String>> buyersMap = {};

  Future<List<String>> getUsersList(
          {required ProductModel productModel,
          required collectionName}) async =>
      categoriesReference
          .collection('${productModel.category}')
          .doc(productModel.productId)
          .collection('$collectionName')
          .get()
          .then((value) => value.docs.map((doc) => doc.id).toList());

  void deleteUserFromBuyersList({
    required ProductModel productModel,
  }) async =>
      categoriesReference
          .collection('${productModel.category}')
          .doc(productModel.productId)
          .collection('buyers')
          .doc(uId)
          .delete();

  Future<Map<String, List<String>>> getUsersRatedMap({
    required ProductModel productModel,
  }) async {
    usersList = await getUsersList(
        productModel: productModel, collectionName: 'rate_map_col');
    ratersMap.addAll({'${productModel.productId}': usersList});
    return ratersMap;
  }

  bool isUserFound(
      {required ProductModel productModel,
      required String uId,
      required String mapName}) {
    List<String>? list = ratersMap[productModel.productId];
    if (list != null)
      return list.contains(uId);
    else
      return false;
  }

  Future<Map<String, List<String>>> getBuyersMap({
    required ProductModel productModel,
  }) async {
    buyersList = await getUsersList(
        productModel: productModel, collectionName: 'buyers');
    if (buyersList.isNotEmpty) {
      buyersMap.addAll({'${productModel.productId}': buyersList});
    } else {
      print('the buyers list is empty');
    }
    return buyersMap;
  }

  bool isBuyerFound({required ProductModel productModel, required String uId}) {
    List<String>? list = buyersMap[productModel.productId];
    if (list != null)
      return list.contains(uId);
    else
      return false;
  }

  bool isProductInCart({
    required ProductModel productModel,
    required String uId,
  }) {
    List<String>? list = ratersMap[productModel.productId];
    if (list != null)
      return list.contains(uId);
    else
      return false;
  }

  double? userRate;

  Future<void> ratingItemUpdate(context,
      double rating, ProductModel productModel) async {
    userRate = rating;
    //getUserRatedList(productModel);
    emit(RatingItemLoadingState());
    if (uId != '') if (isUserFound(
        productModel: productModel, uId: uId, mapName: 'ratersMap')) {
      HomeCubit.get(context).displaySpecifiedCategory();
      emit(ToastMessageState());
    } else {
      print('usersRated is ${productModel.usersRated} ');
      categoriesReference
          .collection('${productModel.category}')
          .doc('${productModel.productId}')
          .get()
          .then((value) {
        if (productModel.usersRated == 0) {
          rating = rating;
          productModel.productRate = rating;
        } else {
          rating = (productModel.productRate! + rating) / 2;
          productModel.productRate = rating;
        }
        print('${productModel.productRate} rating');
        print('$rating rating');

        updateProductRateValue(rate: rating, productModel: productModel);
        addUserToRateCollection(
            productModel: productModel,
            collectionName: 'rate_map_col',
            setMap: {'rated': true, 'rating': userRate});
      }).catchError((error) {
        emit(RatingItemErrorState());
      });
    }

    emit(ChangeRatingState());
  }

  Future<void> getRateCollectionLength(ProductModel productModel) async {
    emit(GetRateCollectionLengthLoadingState());
    categoriesReference
        .collection('${productModel.category}')
        .doc('${productModel.productId}')
        .collection('rate_map_col')
        .get()
        .then((value) {
      length = value.docs.length;
      emit(GetRateCollectionLengthSuccessState());
    }).catchError((error) {
      print('$onError');
      emit(GetRateCollectionLengthErrorState());
    });
  }

  void addUserToRateCollection(
      {/*required bool isUserRated,*/ required ProductModel productModel,
      required collectionName,
      required Map<String, dynamic> setMap}) {
    categoriesReference
        .collection('${productModel.category}')
        .doc('${productModel.productId}')
        .collection('$collectionName')
        .doc('$uId')
        .set(setMap)
        .then((value) {
      print('product added to $categoryName ');
      emit(AddUserToCollectionSuccessState());
    }).catchError((error) {
      print('$onError categories col error');
      emit(AddUserToCollectionErrorState());
    });
  }

  //productRate+userRate /rate_col.length
  void updateProductRateValue(
      {/*required bool isUserRated,*/ required ProductModel productModel,
      required double rate}) {
    emit(RatingItemLoadingState());
    categoriesReference
        .collection('${productModel.category}')
        .doc('${productModel.productId}')
        .update({'rate': rate, 'users_rated': length}).then((value) {
      emit(UpdateProductRateValueSuccessState());
    }).catchError((onError) {
      print('$onError ');
      emit(UpdateProductRateValueErrorState());
    });
  }
}
