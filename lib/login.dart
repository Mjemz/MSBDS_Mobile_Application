import 'package:cornfield/home.dart';
import 'package:cornfield/signup.dart';
import 'package:flutter/material.dart';
import 'package:cornfield/components/my_textfield.dart';
import 'package:cornfield/components/my_button.dart';
class LoginPage extends StatelessWidget{
  LoginPage({super.key});

  //logic for user Authentication
 void userLogin(BuildContext context) {
    // our user authentication logic here
   //We'll directly navigate to the HomePage for now
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
 }

    // username controller
  final usernameController= TextEditingController();
   // password contorller
  final passwordController= TextEditingController();
 
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      body: SafeArea(
      child: Center(  
        child: Column(
          children: [
            //logo
            const SizedBox(height: 25),
            Image.asset(
                'assets/images/MSBDSLogo.png', // Your image path
                width: 100,
                height: 100, 
              ),

            //welcome back
            const SizedBox(height: 25),
            const Text(
              'Welcome Back !', style: TextStyle( color: Colors.black, 
              fontSize:20 ),
            ),
            const SizedBox(height: 25),
            
        //username textfield
        MyTextField(
          controller: usernameController,
          hintText: 'Username',
          obscureText: false,
          icon: Icons.person,
        ),

        const SizedBox(height: 25),

        //password textfield
        MyTextField(
          controller: passwordController,
          hintText: 'Password',
          obscureText: true,
          icon: Icons.key,
        ),

        const SizedBox(height: 25),
        //forgot password\
        const Row(
          mainAxisAlignment: MainAxisAlignment.end, // pushes the text to the right end side of the page
          children:
      [ 
          Text('Forgot Password?',
          style: TextStyle(color: Color.fromARGB(255, 2, 122, 6))
        ),
      ]
    ),


    //need help?
    //     const SizedBox(height: 25),
    //     Row(
    //        mainAxisAlignment: MainAxisAlignment.end,
    //        children:
    //     [
    //        Text('Need help?',
    //       style: TextStyle(color: Color.fromARGB(255, 2, 122, 6))
    //       ),
    //     ]
    //     ),
        //login button
        const SizedBox(height: 15),
        MyButton(
          onTap: () => userLogin(context),
          label: "Login",
        ),

        //sign up link
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            const Text('Don\'t have an account?',
          style: TextStyle(color: Color.fromARGB(255, 2, 122, 6))
          ),
          const SizedBox(width: 4),
         InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()), 
                        );
                      },
                      child: const Text(
                        'SignUp',
                        style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                  ),
                ),
            ]
           ) 
          ],      
        ),
      ),
    ),
   );
  }
}