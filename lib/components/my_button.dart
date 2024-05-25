import 'package:flutter/material.dart';
class MyButton extends StatelessWidget{
  final Function()? onTap; 
  final String label;
  const MyButton({Key? key, 
  required this.onTap,
  required this.label}) 
  : super(key: key);
  @override
  Widget build (BuildContext context){
    return GestureDetector(
      onTap: onTap,
    child: Container(
        padding: EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration:BoxDecoration(color: Color.fromARGB(255, 2, 122, 6), 
        borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(label, style: TextStyle(color: Colors.white,
          fontWeight:FontWeight.bold,
          fontSize:16,)
          ),
        ),
      ),
    );
  }
}