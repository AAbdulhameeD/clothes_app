import 'package:clothes_app/shared/components/constants.dart';
import 'package:clothes_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_cubit/home_cubit.dart';
import 'home_cubit/home_cubit_states.dart';

class HomeLayout extends StatelessWidget {
  String uId;

  HomeLayout(this.uId);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return DefaultTabController(
          length: 1,
          child: Scaffold(

             appBar: AppBar(
            leading: IconButton(
              icon: Icon(IconBroken.Arrow___Left), onPressed: () {
              // HomeCubit.get(context).signOut();
              // Navigator.pop(context);
              signOut(context);
            },),


            title: Text(
                '${HomeCubit
                    .get(context)
                    .titles[HomeCubit
                    .get(context)
                    .currentIndex]}'),
            // gradient: LinearGradient(
            //     colors: [Colors.blue, Colors.purple, Colors.red]),

          ),
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                bottomNavigationBarTheme: BottomNavigationBarThemeData(

                  backgroundColor: Colors.red,
                  showSelectedLabels: false,
                  selectedIconTheme: IconThemeData(
                      size: 20.0,
                      color: Colors.amber
                  ),
                  unselectedIconTheme: IconThemeData(
                    size: 28.0,
                    color: Colors.white,
                  ),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 18.0, color: Colors.white),
                  unselectedItemColor: Colors.white,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.amber,
                  elevation: 60.0,
                ),),
              child: BottomNavigationBar(
                selectedIconTheme: IconThemeData(color: Colors.amber),
                items: [
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(IconBroken.Home),
                  ),
                  BottomNavigationBarItem(
                    label: 'Cart',
                    icon: Icon(IconBroken.Wallet),
                  ),
                  BottomNavigationBarItem(
                    label: 'Settings',

                    icon: Icon(IconBroken.Setting),
                  ),
                ],
                currentIndex: HomeCubit
                    .get(context)
                    .currentIndex,
                onTap: (index) {
                  HomeCubit.get(context).changeNavBarItem(index);
                },
              ),
            ),

            body: HomeCubit
                .get(context)
                .screens[HomeCubit
                .get(context)
                .currentIndex],

          ),
        );
      },
    );
  }
}
