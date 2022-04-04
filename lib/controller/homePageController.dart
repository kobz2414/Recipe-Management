import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_db/screens/signIn.dart';
import 'package:recipe_db/screens/welcomePage.dart';
import 'package:recipe_db/userAuthentication/AuthService.dart';
import 'package:recipe_db/userAuthentication/user_model.dart';

class homePageController extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot){
        if (snapshot.connectionState == ConnectionState.active){
          final User? user = snapshot.data;
          return user == null ? signIn() : welcomePage();
        }else{
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
