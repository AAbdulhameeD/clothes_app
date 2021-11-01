import 'package:clothes_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../modules/login/login_screen.dart';
import 'package:clothes_app/network/local/cache_helper.dart';
import 'package:clothes_app/shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

String uId='';
const String CATEGORIES_ID='aIyhCRlg8uxmWOjxWwYt';
const String ADMIN_ID='mRruVhhFbROBe7pMDNzn3b8uR7K2';
UserModel userModel=UserModel(name: '', uId: 'no id');

final googleSignIn = GoogleSignIn();
void signOut(context) {
  CacheHelper.removeToken(key: 'uId').then((value) {
    if (value) {
      navigateAndFinish(context, LoginScreen());
    }
    googleSignIn.isSignedIn().then((value) {
      if (value) googleSignIn.disconnect();
    }).catchError((error) {
      print(error.toString());
    });

  });
  FirebaseAuth.instance.signOut();
}


