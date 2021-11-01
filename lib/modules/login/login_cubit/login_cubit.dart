import 'package:bloc/bloc.dart';
import 'package:clothes_app/models/user_model.dart';
import 'package:clothes_app/modules/login/login_cubit/login_states.dart';
import 'package:clothes_app/shared/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates>{
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context)=>BlocProvider.of(context);
  void loginAnonymously() {
    FirebaseAuth.instance.signInAnonymously().then((value) {
      uId = value.user!.uid;
      print('$uId uId');
      userCreate(
          uId: '${value.user!.uid}',
          name: 'Anon-${value.user!.uid}',
          image: value.user!.photoURL ?? '',
          email: value.user!.email ?? '',
          isAnonymously: value.user!.isAnonymous);
      emit(LoginAnonymouslySuccessState(uId));
    }).catchError((onError) {
      print('${onError.toString()}');
      emit(LoginAnonymouslyErrorState());
    });
  }

  void googleLogin() async {
    emit(GoogleLoginLoadingState());
    final user = await googleSignIn.signIn();
    if (user == null) {
      print('user is not found');
      return;
    } else {
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      FirebaseAuth.instance.signInWithCredential(credential).then((value) {
        userCreate(
            name: value.user!.displayName??'',
            uId: value.user!.uid,
            email: value.user!.email??'',
            image: value.user!.photoURL??'',
            isAnonymously: value.user!.isAnonymous
        );

      }).catchError((error) {
        print(error.toString());
        emit(GoogleLoginErrorState());
      });
    }
  }

  void userCreate({
    String? name,
    required String uId,
    String? email,
    String? image,
    bool? isAnonymously,
  }) {
    UserModel model = UserModel(
      name: name,
      email: email,
      image: image,
      uId: uId,
      isAnonymously: isAnonymously,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap(model))
        .then((value) {
      emit(CreateUserSuccessState(uId));
    }).catchError((error) {
      print(error.toString());
      emit(CreateUserErrorState());
    });
  }
  void getUserData() {
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value)  {
      userModel =  UserModel.fromJson(value.data());
      // image=model.image;

      emit(GetUserDataSuccessState());
    }).catchError((error) {

      emit(GetUserDataErrorState());
    });
  }

}