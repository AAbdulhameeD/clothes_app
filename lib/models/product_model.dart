import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? productId;
  String? productName;
  String? productImage;
  String? productPrice;
  String? category;
  int? usersRated;
  double? productRate;
  List<QueryDocumentSnapshot>? docs;
  List<String> usersRatedIds = [];
  CollectionReference? collectionReference;
  DocumentReference? documentReference;

  Map<String, dynamic>? rateMap;

  ProductModel(
      {
        //this.productId,
      this.docs,
        this.productId,
      this.usersRated,
      this.productName,
      this.productImage,
      this.category,
      this.productPrice,
      this.productRate,
      this.rateMap});

  ProductModel.fromJson(DocumentSnapshot snapshot) {
    productId = (snapshot.data()! as Map)['id'];
    productName = (snapshot.data()! as Map)['product_name'];
    usersRated = (snapshot.data()! as Map)['users_rated'];
    productImage = (snapshot.data()! as Map)['image'];
    category = (snapshot.data()! as Map)['category'];
    productPrice = (snapshot.data()! as Map)['price'];
    productRate = (snapshot.data()! as Map)['rate'];
    documentReference = snapshot.reference;
    // ProductModel.fromSnapshot(documentReference!.collection('rate_map'));
    snapshot.reference.collection('rate_map').get().then((value)async {

    });
  }
  //
  // ProductModel.fromSnapshot(CollectionReference collectionReference) {
  //   // print('${} collection ref id');
  //   collectionReference.get().then((value)async{
  //     usersRatedIds = (await ratedUserList(value))!;
  //     print('$usersRatedIds it is a list');
  //
  //   });
  // }
  // Future<List<String>?> ratedUserList( QuerySnapshot querySnapshot ) async {
  //   List<String> list=[];
  //  list= querySnapshot.docs.map((doc) => doc.reference.id).toList();
  //  var list2 =querySnapshot.docs.map((e) => e.data().toString());
  //   print('$list2 it is a list');
  //  return list;
  //
  // }

  Map<String, dynamic> toMap(ProductModel productModel) {
    return {
      'users_rated': productModel.usersRated,
      'product_name': productModel.productName,
      'image': productModel.productImage,
      'price': productModel.productPrice,
      'rate': productModel.productRate,
      'category': productModel.category,
      'id': productModel.productId,
    };
  }
}
