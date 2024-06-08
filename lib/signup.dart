import 'package:cornfield/login.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:cornfield/components/my_textfield.dart';
import 'package:cornfield/components/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatelessWidget {
 SignUpPage({Key? key}) : super(key: key);

 // SignUp controllers
 final emailController = TextEditingController();
 final usernameController = TextEditingController();
 final passwordController = TextEditingController();
 final confirmController = TextEditingController();
 final contactController = TextEditingController();
 final farmSizeController = TextEditingController();
 final farmLocationController = TextEditingController();

 void userSignUp(BuildContext context) async {
   // Check if passwords match
   if (passwordController.text!= confirmController.text) {
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Passwords do not match')),
     );
     return;
   }

   try {
     // Create a new user with username (used as email) and password
     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
       email: emailController.text,
       password: passwordController.text,
     );

     // Store additional user information in Firestore
     await FirebaseFirestore.instance.collection('farmers').doc(userCredential.user!.uid).set({
       //'email': emailController.text,
       'username': usernameController.text,
       'contact': contactController.text,
       'farmSize': farmSizeController.text,
       'farmLocation': farmLocationController.text,
       'createdAt': DateTime.now(), // Optional: Timestamp for when the account was created
     });

     // Navigate to another page or show a success message
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Account created successfully')),
     );

   } on FirebaseAuthException catch (e) {
     if (e.code == 'weak-password') {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('The password provided is too weak.')),
       );
     } else if (e.code == 'email-already-in-use') {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('The username is already taken.')),
       );
     }
   } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('An error occurred. Please try again.')),
     );
   }
 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      body: SafeArea(
        child: SingleChildScrollView( // Makes the content scrollable
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adds padding for better spacing
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Image.asset(
                 'assets/images/MSBDSLogo.png', // Your image path
                 width: 100,
                 height: 100,
                ),
                const SizedBox(height: 10),
                const Text(
                 'Create Account',
                 style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                const SizedBox(height: 10),
                // Email TextField
                MyTextField(
                 controller: emailController,
                 hintText: 'Enter Email',
                 obscureText: false,
                 icon: Icons.person,
                ),
                // Username
                const SizedBox(height: 10),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Create username',
                  obscureText: false,
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),
                // Password TextField
                MyTextField(
                 controller: passwordController,
                 hintText: 'Create Password',
                 obscureText: true,
                 icon: Icons.key,
                ),
                const SizedBox(height: 10),
                // Confirm Password TextField
                MyTextField(
                 controller: confirmController,
                 hintText: 'Confirm Password',
                 obscureText: true,
                 icon: Icons.key,
                ),
                const SizedBox(height: 10),
                // Farm Size TextField
                MyTextField(
                 controller: farmSizeController,
                 hintText: 'Farm Size in acres',
                 obscureText: false,
                 icon: (EvaIcons.crop),
                ),
                const SizedBox(height: 10),

                // Phone number
                MyTextField(
                  controller: contactController,
                  hintText: 'Enter phone number',
                  obscureText: false,
                  icon: (EvaIcons.crop),
                ),
                const SizedBox(height: 10),

                // Farm Location TextField
                MyTextField(
                 controller: farmLocationController,
                 hintText: 'Farm Location',
                 obscureText: false,
                 icon: Icons.map,
                ),
                const SizedBox(height: 10),

                // SignUp Button
                MyButton(
                    onTap: () => userSignUp(context),
                    label: "SignUp",
                ),
               // ),
                const SizedBox(height: 15),
                // Sign up link
                Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Color.fromARGB(255, 2, 122, 6)),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()), 
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                      ),
                    ),
                 ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
 }
}
