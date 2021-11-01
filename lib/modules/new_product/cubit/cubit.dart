import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:clothes_app/models/product_model.dart';
import 'package:clothes_app/modules/new_product/cubit/states.dart';
import 'package:clothes_app/shared/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class NewProductCubit extends Cubit<NewProductStates> {
  NewProductCubit() : super(NewProductInitialState());

  static NewProductCubit get(context) => BlocProvider.of(context);

  File? productImageFile;
  var picker = ImagePicker();

  Future getProductImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      productImageFile = File(pickedFile.path);
      emit(ProductImagePickedSuccessState());
    } else {
      emit(ProductImagePickedErrorState());
    }
  }

  void createProduct({
    required String productName,
    required String productPrice,
    required String productCategory,
  }) {
    emit(CreateProductLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            '$productCategory/${Uri.file(productImageFile!.path).pathSegments.last}')
        .putFile(productImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        newProduct(
            productImage: value,
            productPrice: productPrice,
            productName: productName,
            productCategory: productCategory);
        emit(CreateProductSuccessState());

      }).catchError((error) {
        emit(CreateProductErrorState());

      });
    }).catchError((error) {
      emit(CreateProductErrorState());
    });
  }

  void newProduct({
    required String productName,
    required String productImage,
    required String productPrice,
    required String productCategory,
  }) {
    emit(NewProductProductLoadingState());
    ProductModel productModel = ProductModel(
      productName: productName,
      category: productCategory,
      productPrice: productPrice,
      productImage: productImage,
      productRate: 3.5,
      usersRated: 0,
      productId: '',
    );

    FirebaseFirestore.instance
        .collection('categories')
        .doc('$CATEGORIES_ID')
        .collection('$productCategory')
        .add(productModel.toMap(productModel))
        .then((value) {
      value.collection('rate_map_col').doc().set({});
      value.collection('buyers').doc().set({});
      value.update({'id': value.id});
      //no need to emit state
      emit(NewProductProductSuccessState());
    }).catchError((error) {
      emit(NewProductProductErrorState());
    });
  }

// void clearPostImage() {
//   productImageFile = null;
//   emit(ClosePostImageState());
// }

}
