import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_db/userAuthentication/AuthService.dart';

class signIn extends StatefulWidget {
  const signIn({Key? key}) : super(key: key);

  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {

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

    // Authentication Service
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea( //Prevent the screen from occupying the notifications bar at the top
        child: SingleChildScrollView( // Allow the page to be scrollable
          child: Container(
            width: MediaQuery.of(context).size.width, //Set container size with screen size (width)
            margin: const EdgeInsets.only(left: 50, right: 50), //Add margin to the container
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, //Align items to the left
              children: [

                const SizedBox( //Spacing vertically
                  height: 100,
                ),

                Row(
                  children: const [
                    Text("Hello",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Text("Login to your account to continue")
                  ],
                ),

                const SizedBox( //Spacing vertically
                  height: 40,
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
                    shape: StadiumBorder(),
                    primary: Color(0xffFF971D),
                    onPrimary: Colors.black,
                    minimumSize: Size(MediaQuery.of(context).size.width-150, 40),
                  ),
                  child: const Text('Sign In'),
                  onPressed: (){
                    authService.signIn(emailController.text, passwordController.text);
                  },
                ),

                Row( //Sign Up
                  children: [
                    const Text("Don't have an account yet? "),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                      ),
                      child: const Text('Sign Up'),
                      onPressed: (){
                        Navigator.pushNamed(context, '/signUp');
                      },
                    ),
                  ],
                ),

                const SizedBox( //Spacing vertically
                  height: 20,
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
