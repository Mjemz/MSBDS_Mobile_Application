import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget{
  final controller;
  final String hintText;
  final bool obscureText;
  final IconData? icon;
  final Color iconColor;
  
  const MyTextField({
    Key? key,
    required this.controller, 
    required this.hintText,
    required this. obscureText,
    this.icon,// Accepts an icon for the textfield
    this.iconColor = const Color.fromARGB(255, 2, 122, 6), 
  }): super(key: key);

  Widget build(BuildContext context) 
  {
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: TextField(
          controller: controller,    // for retrieving input data by the user
          obscureText: obscureText, // for Hiding password characters
          decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 2, 122, 6)),
            borderRadius: BorderRadius.circular(10), // Add this line for rounded corners
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 2, 122, 6)),
            borderRadius: BorderRadius.circular(10), // Add this line for rounded corners
          ), 
          //state when a user is interacting with a textfield
              fillColor: Colors.white,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: icon != null ? Icon(icon, color: iconColor) : null,
            ),
          ),
        );
  }  
}