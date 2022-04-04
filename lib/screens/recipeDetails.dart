import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class recipeDetails extends StatefulWidget {
  const recipeDetails({Key? key}) : super(key: key);

  @override
  State<recipeDetails> createState() => _recipeDetailsState();
}

class _recipeDetailsState extends State<recipeDetails> {

  final _user = FirebaseAuth.instance.currentUser!; // Current user instance
  final _database = FirebaseDatabase.instance.reference(); // Firebase database instance

  List apiOutput = [];
  bool isEmpty = true;

  Map args = {};


  Future<void> getItemDetail(String foodID) async {

    Response response;
    var queryParameters = {
      'i': foodID
    };

    response = await get(Uri.http('themealdb.com', 'api/json/v1/1/lookup.php', queryParameters));
    Map jsonOutput = jsonDecode(response.body);
    apiOutput = jsonOutput["meals"];
    isEmpty = false;

    setState(() {});
  }

  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    args = ModalRoute.of(context)!.settings.arguments as Map;

    getItemDetail(args["foodID"]);

    return Scaffold(
      body: SafeArea( //Prevent the screen from occupying the notifications bar at the top
        child: SingleChildScrollView( // Allow the page to be scrollable
            child: Container(
                width: MediaQuery.of(context).size.width, //Set container size with screen size (width)
                margin: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align contents to the left
                  children: [
                    const SizedBox( //Spacing vertically
                        height: 30
                    ),

                    Text(apiOutput[0]["strMeal"], style: const TextStyle( // Style Text
                        fontSize: 30,
                        letterSpacing: -2,
                        fontWeight: FontWeight.w500
                      ),
                    ),

                    const SizedBox( //Spacing vertically
                        height: 30
                    ),

                    const Text("Ingredients", style: TextStyle( // Style Text
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                      ),
                    ),

                    const SizedBox( //Spacing vertically
                        height: 15
                    ),

                    //Ingredients

                    apiOutput[0]["strIngredient1"] != null ? Text(apiOutput[0]["strMeasure1"] + " " + apiOutput[0]["strIngredient1"] , style: const TextStyle( // Style Text
                        fontSize: 18,
                      ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient2"] != null ? Text(apiOutput[0]["strMeasure2"] + " " + apiOutput[0]["strIngredient2"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox (),

                    apiOutput[0]["strIngredient3"] != null ? Text(apiOutput[0]["strMeasure3"] + " " + apiOutput[0]["strIngredient3"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient4"] != null ? Text(apiOutput[0]["strMeasure4"] + " " + apiOutput[0]["strIngredient4"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient5"] != null ? Text(apiOutput[0]["strMeasure5"] + " " + apiOutput[0]["strIngredient5"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient6"] != null ? Text(apiOutput[0]["strMeasure6"] + " " + apiOutput[0]["strIngredient6"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient7"] != null ? Text(apiOutput[0]["strMeasure7"] + " " + apiOutput[0]["strIngredient7"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient8"] != null ? Text(apiOutput[0]["strMeasure8"] + " " + apiOutput[0]["strIngredient8"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient9"] != null ? Text(apiOutput[0]["strMeasure9"] + " " + apiOutput[0]["strIngredient9"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient10"] != null ? Text(apiOutput[0]["strMeasure10"] + " " + apiOutput[0]["strIngredient10"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient11"] != null ? Text(apiOutput[0]["strMeasure11"] + " " + apiOutput[0]["strIngredient11"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient12"] != null ? Text(apiOutput[0]["strMeasure12"] + " " + apiOutput[0]["strIngredient12"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient13"] != null ? Text(apiOutput[0]["strMeasure13"] + " " + apiOutput[0]["strIngredient13"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient14"] != null ? Text(apiOutput[0]["strMeasure14"] + " " + apiOutput[0]["strIngredient14"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient15"] != null ? Text(apiOutput[0]["strMeasure15"] + " " + apiOutput[0]["strIngredient15"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient16"] != null ? Text(apiOutput[0]["strMeasure16"] + " " + apiOutput[0]["strIngredient16"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient17"] != null ? Text(apiOutput[0]["strMeasure17"] + " " + apiOutput[0]["strIngredient17"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient18"] != null ? Text(apiOutput[0]["strMeasure18"] + " " + apiOutput[0]["strIngredient18"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient19"] != null ? Text(apiOutput[0]["strMeasure19"] + " " + apiOutput[0]["strIngredient19"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    apiOutput[0]["strIngredient20"] != null ? Text(apiOutput[0]["strMeasure20"] + " " + apiOutput[0]["strIngredient20"] , style: const TextStyle( // Style Text
                      fontSize: 18,
                    ),
                    ) : SizedBox(),

                    const SizedBox( //Spacing vertically
                        height: 30
                    ),

                    const Text("Instructions", style: TextStyle( // Style Text
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                      ),
                    ),

                    const SizedBox( //Spacing vertically
                        height: 15
                    ),

                    Text(apiOutput[0]["strInstructions"], style: TextStyle(
                        fontSize: 18
                    )
                    )

                  ],
                )
            )
        ),
      ),
    );
  }

}
