import 'package:cornfield/home.dart';
import 'package:cornfield/signup.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:cornfield/components/my_textfield.dart';
import 'package:cornfield/components/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  // Logic for user Authentication
  void userLogin(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      // User logged in successfully, navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      // Handle errors, such as invalid email or password
      print(e); // Consider showing an error message to the user
    }
  }

  // Email controller
  final emailController = TextEditingController();
  // Password controller
  final passwordController = TextEditingController();

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
                  'Welcome Back!',
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
                const SizedBox(height: 10),
                // Password TextField
                MyTextField(
                  controller: passwordController,
                  hintText: 'Enter Password',
                  obscureText: true,
                  icon: Icons.lock,
                ),
                const SizedBox(height: 10),
                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color.fromARGB(255, 2, 122, 6)),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Login Button
                MyButton(
                  onTap: () => userLogin(context),
                  label: "Login",
                ),
                const SizedBox(height: 15),
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Color.fromARGB(255, 2, 122, 6)),
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
