import 'dart:ui';

import 'package:flutter/material.dart';

class Categories{
  static String _categoryName='';
  static int previousIndex =0;
 static String getCategoryName(int index){
   switch (index) {
     case 0:
       _categoryName = 'all';

       break;
     case 1:
       _categoryName = 'children';
       break;
     case 2:
       _categoryName = 'men';
       break;
     case 3:
       _categoryName = 'women';
       break;
   }

   return _categoryName;
  }
  static void selectCategoryColor(List<Color> categoriesColors,index){

    categoriesColors[index] = Colors.red;
    categoriesColors[previousIndex] = Colors.amber;
    previousIndex = index;
    if (index == previousIndex) categoriesColors[index] = Colors.red;
  }
}