import 'package:clothes_app/layout/home_cubit/home_cubit.dart';
import 'package:clothes_app/layout/home_cubit/products/products.dart';
import 'package:clothes_app/modules/login/login_cubit/login_cubit.dart';
import 'package:clothes_app/shared/components/constants.dart';
import 'package:clothes_app/shared/styles/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/home_cubit/home_cubit_states.dart';
import 'layout/home_layout.dart';
import 'modules/login/login_screen.dart';
import 'network/local/bloc_observer.dart';
import 'network/local/cache_helper.dart';
Widget? widget;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId')??'';
  print('$uId this is uId');
  if (uId != '') {
    widget = HomeLayout(uId);
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          return HomeCubit()..displaySpecifiedCategory()..getUserData();
        }), BlocProvider(create: (context) {
          return LoginCubit();
        })
      ],
      child: BlocConsumer<HomeCubit, HomeLayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return FutureBuilder(
            //future: Firebase.initializeApp(),
            builder: (context, snapshot) {

              return MaterialApp(
                title: 'Flutter Demo',
                theme: lightTheme,
                home: widget,
              );
            },
          );
        },
      ),
    );
  }
}
