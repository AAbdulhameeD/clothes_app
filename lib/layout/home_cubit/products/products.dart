import 'package:clothes_app/layout/home_cubit/home_cubit.dart';
import 'package:clothes_app/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_cubit_states.dart';

class Products extends HomeCubit{
  static Products get (context)=>BlocProvider.of(context);
   void displayCategory({String? category}) {

  }



}