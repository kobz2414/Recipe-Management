import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class recipeDetails extends StatefulWidget {
  const recipeDetails({Key? key}) : super(key: key);

  @override
  State<recipeDetails> createState() => _recipeDetailsState();
}

class _recipeDetailsState extends State<recipeDetails> {

  final _database = FirebaseDatabase.instance.reference(); // Firebase database instance

  Map args = {};

  @override
  Widget build(BuildContext context) {

    args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      body: SafeArea( //Prevent the screen from occupying the notifications bar at the top
        child: SingleChildScrollView( // Allow the page to be scrollable
            child: Container(
                width: MediaQuery.of(context).size.width, //Set container size with screen size (width)
                height: MediaQuery.of(context).size.height, //Set container size with screen size (height)
                margin: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align contents to the left
                  children: [
                    const SizedBox( //Spacing vertically
                        height: 30
                    ),

                    Text(args["foodName"], style: const TextStyle( // Style Text
                        fontSize: 70,
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

                    StreamBuilder( // Get realtime data from database
                        stream: _database.child("Recipe").child(args["foodName"]).child("Ingredients").onValue,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                              return const Text("Something went wrong");
                          } else {
                            var recipeData = (snapshot.data! as Event).snapshot.value;

                            if (recipeData != null) {
                              return ListView.builder( // Builds a list based on the data from the database
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: recipeData.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(recipeData[index], style: const TextStyle( // Style Text
                                            fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          )
                                        ]
                                    );
                                  });
                            }
                            return const SizedBox();
                          }
                        }
                    ),

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

                    StreamBuilder( // Get realtime data from database
                        stream: _database.child("Recipe").child(args["foodName"]).child("Instructions").onValue,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return const Text("Something went wrong");
                          } else {
                            var recipeData = (snapshot.data! as Event).snapshot.value;

                            if (recipeData != null) {
                              return Text(recipeData);
                            }
                            return const SizedBox();
                          }
                        }
                    ),
                  ],
                )
            )
        ),
      ),
    );
  }
}
