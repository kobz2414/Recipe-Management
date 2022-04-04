import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../userAuthentication/AuthService.dart';
import '../screens/homePage.dart';

class welcomePage extends StatefulWidget {
  const welcomePage({Key? key}) : super(key: key);

  @override
  State<welcomePage> createState() => _homeScreenState();
}

class _homeScreenState extends State<welcomePage> {

  final _user = FirebaseAuth.instance.currentUser!; // Current user instance
  final _database = FirebaseDatabase.instance.reference(); // Firebase database instance

  //Controllers for Text Fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is disposed.
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return StreamBuilder(
        stream: _database.child("userData").onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else {
            var isPresent = (snapshot.data! as Event).snapshot.value;

            if(isPresent != null){
              var usersList = isPresent.entries.toList();

              for(int x = 0 ; x < isPresent.length; x++ ){
                if(usersList[x].key == _user.uid){
                  return homePage();
                }
              }
            }

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
                        const Text("Welcome!", style: TextStyle( // Style Text
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

                        TextField( //Input for user first name
                          controller: firstNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: 'First Name',
                          ),
                        ),

                        const SizedBox( //Spacing vertically
                          height: 5,
                        ),

                        TextField( //Input for user last name
                          controller: lastNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: 'Last Name',
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
                          child: const Text('Save'),
                          onPressed: () {

                            if(firstNameController.text == ""){ // Condition to check if user enter his/her first name
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Incomplete Details'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text('Please input first name'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }else if (lastNameController.text == ""){ // Condition to check if user enter his/her last name
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Incomplete Details'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: const <Widget>[
                                          Text('Please input last name'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }else{
                              createUserData(firstNameController.text, lastNameController.text); // Insert data onto database
                            }
                          },
                        ),

                        const SizedBox( //Spacing vertically
                          height: 5,
                        ),

                        ElevatedButton( //Logout Button
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            minimumSize: Size(MediaQuery.of(context).size.width-150, 40),
                          ),
                          child: const Text('Logout'),
                          onPressed: () async {
                            await authService.signOut();
                          },
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }
    );



  }

  void createUserData(String firstName, String lastName){ //Add user details after account creation
    _database.child("userData").child(_user.uid).set({
      "firstName": firstName,
      "lastName": lastName,
      "userEmail": _user.email
    });
  }
}
