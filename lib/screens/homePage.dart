import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../userAuthentication/AuthService.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {

  final _user = FirebaseAuth.instance.currentUser!;
  final _database = FirebaseDatabase.instance.reference(); // Firebase database instance


  String userFirstName = "";
  String userLastName = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffFF971D),
      body: SafeArea( //Prevent the screen from occupying the notifications bar at the top
        child: SingleChildScrollView( // Allow the page to be scrollable
          child: Container(
            width: MediaQuery.of(context).size.width, //Set container size with screen size (width)
            height: MediaQuery.of(context).size.height, //Set container size with screen size (height)
            margin: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align contents to the left
              children: [

                StreamBuilder( // Get realtime data from database
                    stream: _database.child("userData").child(_user.uid).onValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      } else {
                        var userData = (snapshot.data! as Event).snapshot.value;

                        return Row(
                          children: [
                            Column(
                              children: [
                                Material(
                                  elevation: 1,
                                  borderRadius: BorderRadius.circular(28),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Ink(
                                    height: 30 ,
                                    width: 30,
                                    child: InkWell(
                                      splashColor: const Color(0xfffcb631),
                                      onTap: (){
                                        showDialog(context: context, builder: (context) => showProfile());
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                const SizedBox(width: 8,),
                                Text(userData["firstName"] + " " + userData["lastName"], style:
                                const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Colors.white
                                ),
                                ),
                              ],
                            )
                          ],
                        );
                      }
                    }
                ),

                const SizedBox( //Spacing vertically
                    height: 30
                ),

                const Text("Yuhmee!", style: TextStyle( // Style Text
                    fontSize: 70,
                    color: Colors.white,
                    letterSpacing: -2
                  ),
                ),

                const Text("Count memories, not calories", style: TextStyle( // Style Text
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),

                const SizedBox( //Spacing vertically
                    height: 30
                ),

                StreamBuilder( // Get realtime data from database
                stream: _database.child("Recipe").onValue,
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
                                      primary: Colors.white,
                                    ), onPressed: () {
                                    Navigator.pushNamed(context, '/recipeDetails', arguments: {
                                          'foodName': usersList[index].key
                                        });
                                    },
                                    child: Column(
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
                                  SizedBox(
                                    height: 10,
                                  )
                                ]
                            );
                          });
                    }
                    return SizedBox();
                  }
                }
                )
              ],//Add margin to the container
            ),
          ),
        ),
      ),
    );
  }
}

class showProfile extends StatelessWidget {

  final _user = FirebaseAuth.instance.currentUser!;
  final _database = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context){

    final authService = Provider.of<AuthService>(context);

    return StreamBuilder( // Get realtime data from database
        stream: _database.child("userData").child(_user.uid).onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else {
            var userData = (snapshot.data! as Event).snapshot.value;

            return Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      top: 80,
                      bottom: 16,
                      left: 50,
                      right: 50
                  ),
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(17),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 10.0)
                        )
                      ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        userData["firstName"],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(height: 1,),
                      Text(
                        userData["lastName"],
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Text(
                        userData["userEmail"],
                        style: const TextStyle(
                            fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 40,),

                      ElevatedButton( //View Own Recipes
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          primary: Color(0xffFFE8D6),
                          onPrimary: Colors.black,
                          minimumSize: Size(MediaQuery.of(context).size.width-150, 40),
                        ),
                        child: const Text('View Own Recipes'),
                        onPressed: () {
                          Navigator.popAndPushNamed(context, '/ownRecipes');
                        },
                      ),

                      ElevatedButton( //Logout Button
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          primary: Color(0xffFFE8D6),
                          onPrimary: Colors.black,
                          minimumSize: Size(MediaQuery.of(context).size.width-150, 40),
                        ),
                        child: const Text('Logout'),
                        onPressed: () async {
                          await authService.signOut();
                          Navigator.pop(context);
                        },
                      ),

                      const SizedBox(height: 30,),
                    ],
                  ),
                ),
              ],
            );
          }
        }
    );
  }
}
