import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_db/screens/recipeDetails.dart';
import 'package:recipe_db/screens/signUp.dart';
import 'package:recipe_db/userAuthentication/AuthService.dart';
import '../controller/homePageController.dart';
import 'addRecipe.dart';
import 'editRecipe.dart';
import 'ownRecipe.dart';
import 'ownRecipeDetails.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(homeScreen());
}

class homeScreen extends StatelessWidget {
  static const String title = "Home Page";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        Provider<AuthService>(create: (_) => AuthService(),)
      ],
      child: MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Metropolis',
        ),
        home: homePageController(),
        routes: {
          '/signUp': (context) => signUp(),
          '/ownRecipes': (context) => ownRecipe(),
          '/recipeDetails': (context) => recipeDetails(),
          '/ownRecipeDetails': (context) => ownRecipeDetails(),
          '/addRecipe': (context) => addRecipe(),
          '/editRecipe': (context) => editRecipe()
        },
      )
    );
  }
}