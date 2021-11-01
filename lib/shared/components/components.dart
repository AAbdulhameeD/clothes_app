import 'package:clothes_app/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultAppBar(
    BuildContext context,
    {
      String? title,
      List<Widget>? actions,
    }
    ) =>
    AppBar(
      leading: IconButton(
        icon: Icon(
          IconBroken.Arrow___Left_2,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: actions,
      title: Text(title!,style: TextStyle(fontSize: 20.0),),
      titleSpacing: 2.0,
    );
Widget defaultTextButton(
    {
      required Function onPressed,
      required String text,
      required Color color,

    }
    )=>TextButton(onPressed: (){
      onPressed();
}, child: Text(text.toUpperCase(),style: TextStyle(
    color: color,
    fontWeight: FontWeight.bold

),));
void navigateTo(context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
          (Route<dynamic> route) => false);
}
Widget defaultButton({
  required Function buttonFunction,
  required Widget buttonWidget ,
  Color color = Colors.blue,
  double width = double.infinity,
  double radius = 5.0,
  double height = 20.0,
  bool isUpperCase = true,
}) =>
    Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      width: width,
      child: MaterialButton(
        height: height,
        onPressed: (){
          buttonFunction();
        },
        child: buttonWidget
      ),
    );

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType inputType,
  Function? fieldSubmitted,
  Function? validate,
  required String labelText,
  Function? onChanged,
  required IconData prefix,
  Function? onTappedTextForm,
  IconData? suffix,
  bool isPassword = false,
  Function? showPassword,
}) =>
    TextFormField(
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      keyboardType: inputType,
      controller: controller,

      validator: ( String? value){
        validate!(  value);
      },
      // onTap: onTappedTextForm,
      //     (value) {
      //   if (value.isEmpty) {
      //     return 'Email Address is required';
      //   }
      //   return null;
      // },
      obscureText: isPassword,
      decoration: InputDecoration(


        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0,letterSpacing: 1.0),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)

        ),
        prefixIcon: Icon(
          prefix,color:Colors.grey,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          icon: Icon(suffix,color: Colors.white,),
          onPressed: (){
            showPassword!();
          },
        )
            : null,
        //
        // suffix != null
        //     ? Icon(
        //         suffix,
        //       )
        //     : null,
      ),
    );
void showToast({required context ,Color color =Colors.grey, required String message, }) {
  final fToast = FToast().init(context);
  fToast.showToast(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: color.withOpacity(.8)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: (Text(
            '$message',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
      toastDuration: Duration(seconds: 5));

}