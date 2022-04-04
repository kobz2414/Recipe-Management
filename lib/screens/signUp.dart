import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_db/userAuthentication/AuthService.dart';
import 'package:firebase_database/firebase_database.dart';

class signUp extends StatefulWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {

  //Controllers for Text Fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context); // Authentication Service

    return Scaffold(
      body: SafeArea( //Prevent the screen from occupying the notifications bar at the top
          child: SingleChildScrollView( // Allow the page to be scrollable
            child: Container(
              width: MediaQuery.of(context).size.width, //Set container size with screen size (width)
              height: MediaQuery.of(context).size.height, //Set container size with screen size (height)
              margin: const EdgeInsets.all(30), //Add margin to the container
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Align contents to the center
                children: [
                  const SizedBox( //Spacing vertically
                    height: 20
                  ),
                  const Text("Sign Up", style: TextStyle( // Style Text
                      fontSize: 50
                  ),),
                  const SizedBox( //Spacing vertically
                      height: 7
                  ),

                  const Text("Input the required details below", style: TextStyle( // Style Text
                      fontSize: 12
                  ),),

                  const SizedBox( //Spacing vertically
                      height: 30
                  ),

                  TextField( //Input for user email
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Email',
                    ),
                  ),

                  const SizedBox( //Spacing vertically
                    height: 5,
                  ),

                  TextField( //Input for user password
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),

                  ElevatedButton( //Login Button
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(MediaQuery.of(context).size.width-150, 35),
                    ),
                    child: const Text('Sign Up'),
                    onPressed: () async{
                      await authService.createUser(emailController.text, passwordController.text);

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
