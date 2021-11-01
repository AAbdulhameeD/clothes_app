import 'package:clothes_app/layout/home_cubit/home_cubit.dart';
import 'package:clothes_app/layout/home_cubit/home_cubit_states.dart';
import 'package:clothes_app/layout/home_cubit/products/products.dart';
import 'package:clothes_app/layout/home_layout.dart';
import 'package:clothes_app/modules/login/login_cubit/login_cubit.dart';
import 'package:clothes_app/network/local/cache_helper.dart';
import 'package:clothes_app/shared/components/components.dart';
import 'package:clothes_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_cubit/login_states.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is CreateUserSuccessState) {
          navigateTo(context, HomeLayout(state.uId));
          CacheHelper.putData(key: 'uId', value: state.uId.toString());
          HomeCubit.get(context).displaySpecifiedCategory();
          LoginCubit.get(context).getUserData();
        }
        if (state is GoogleLoginSuccessState) {
          navigateTo(context, HomeLayout(state.uId));
          CacheHelper.putData(key: 'uId', value: state.uId.toString());
          LoginCubit.get(context).getUserData();


        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.amber,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Log-in',
                  style: TextStyle(
                      backgroundColor: Colors.grey.withOpacity(.05),
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: TextButton(
                        onPressed: () {
                          LoginCubit.get(context).googleLogin();
                          // LoginCubit.get(context).updateProductRate();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(150.0)),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/icons_google.png'),
                                  )),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Log-in with Google',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24.0),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: TextButton(
                        onPressed: () {
                          LoginCubit.get(context).loginAnonymously();
                          // LoginCubit.get(context).updateProductRate();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconBroken.User,
                                color: Colors.white,
                                size: 40,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'log-in Anonymously',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24.0),
                              ),
                            ],
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
