class UserModel {
  String? name;
  String? email;
  String? image;
  String? uId;
  bool? isAnonymously ;
  UserModel({required this.name,this.email,required this.uId,this.image,this.isAnonymously});
  UserModel.fromJson(dynamic json){
    name=json['name'];
    isAnonymously=json['is_anonymously'];
    image=json['image'];
    email=json['email'];
    uId=json['uId'];
  }
  Map<String,dynamic> toMap(UserModel userModel){
    return {
      'name':userModel.name,
      'image':userModel.image,
      'email':userModel.email,
      'uId':userModel.uId,
      'is_anonymously':userModel.isAnonymously,
    };
  }

}