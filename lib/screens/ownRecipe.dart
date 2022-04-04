import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ownRecipe extends StatefulWidget {
  const ownRecipe({Key? key}) : super(key: key);

  @override
  State<ownRecipe> createState() => _ownRecipeState();
}

class _ownRecipeState extends State<ownRecipe> {

  final _user = FirebaseAuth.instance.currentUser!;
  final _database = FirebaseDatabase.instance.reference(); // Firebase database instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( //Prevent the screen from occupying the notifications bar at the top
        child: SingleChildScrollView( // Allow the page to be scrollable
          child: Container(
            width: MediaQuery.of(context).size.width, //Set container size with screen size (width)
            height: MediaQuery.of(context).size.height, //Set container size with screen size (height)
            margin: const EdgeInsets.all(30), //Add margin to the container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align contents to the left
              children: [
                const SizedBox( //Spacing vertically
                    height: 30
                ),

                const Text("Own Recipes", style: TextStyle( // Style Text
                    fontSize: 70,
                    color: Colors.black,
                    letterSpacing: -2
                ),
                ),

                Row( //Sign Up
                  children: [
                    const Text("Want to add more recipes?"),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black,
                      ),
                      child: const Text('Add'),
                      onPressed: (){
                        Navigator.pushNamed(context, '/addRecipe');
                      },
                    ),
                  ],
                ),

                const SizedBox( //Spacing vertically
                    height: 30
                ),

                StreamBuilder( // Get realtime data from database
                    stream: _database.child("userData").child(_user.uid).child("ownRecipe").onValue,
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
                          var usersList = recipeData.entries.toList();

                          return ListView.builder( // Builds a list based on the data from the database
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: recipeData.length,
                              itemBuilder: (context, index) {

                              return Column(
                                    children: [
                                      ElevatedButton( //A Button
                                        style: ElevatedButton.styleFrom(
                                          shape: StadiumBorder(),
                                          primary: Color(0xffFF971D),
                                        ), onPressed: () {
                                        Navigator.pushNamed(context, '/ownRecipeDetails', arguments: {
                                          'foodName': usersList[index].key,
                                        });
                                      },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.all(20),
                                                    child: Text(usersList[index].key,
                                                      style: const TextStyle(
                                                          color: Color(0xff252626),
                                                          fontSize: 15
                                                      ),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ]
                                );
                              });
                        }
                        return const SizedBox();
                      }
                    }
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}
