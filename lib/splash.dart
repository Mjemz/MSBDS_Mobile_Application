import 'package:cornfield/home.dart';
import 'package:cornfield/login.dart';
import 'package:cornfield/signUp.dart';
import 'package:flutter/material.dart';
class Splash extends StatefulWidget{
  const Splash({Key? key}) : super (key:key);
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
// the init state function is only called the first time when an app is running.
  @override
  void initState(){
    super.initState();
    _navigationToLogin();
  } 
  _navigationToLogin()async{
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,  // To Adjust height as needed
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background_splash.png'),// Your background image path
              fit: BoxFit.cover, // Cover the entire container
            ),
          ),
        child: Center(
            child: Image.asset(
              'assets/images/MSBDSLogo.png', // Your image path
              fit: BoxFit.contain, // To ensure the image fits inside the container
              width: 300,
              height:300, 
            ),
          ),
        ),
      ),
    );
  }
}
