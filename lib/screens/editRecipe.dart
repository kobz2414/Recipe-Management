import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class editRecipe extends StatefulWidget {
  const editRecipe({Key? key}) : super(key: key);

  @override
  State<editRecipe> createState() => _editRecipeState();
}

class _editRecipeState extends State<editRecipe> {

  final _user = FirebaseAuth.instance.currentUser!;
  final _database = FirebaseDatabase.instance.reference(); // Firebase database instance

  //Controllers for Text Fields
  TextEditingController foodNameController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  List<TextEditingController> _controllers = [];
  List<TextField> _fields = [];

  var ingredientsData;

  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    foodNameController.dispose();
    instructionsController.dispose();
    super.dispose();
  }

  Widget _addTile() {
    return ListTile(
      title: const Icon(Icons.add),
      onTap: () {
        final controller = TextEditingController();
        final field = TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelText: "Ingredient ${_controllers.length + 1}",
          ),
        );

        setState(() {
          _controllers.add(controller);
          _fields.add(field);
        });
      },
    );
  }

  Widget _listView() {
    return ListView.builder(
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(5),
          child: _fields[index],
        );
      },
    );
  }

  Widget _okButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        primary: const Color(0xffFF971D),
        onPrimary: Colors.black,
        minimumSize: Size(MediaQuery.of(context).size.width-150, 40),
      ),
      onPressed: () {

        _database.child("userData").child(_user.uid).child("ownRecipe").child(args["foodName"]).update({
          "Instructions": instructionsController.text
        });

        for(int x = 0; x < _controllers.length; x++){
          _database.child("userData").child(_user.uid).child("ownRecipe").child(args["foodName"]).child("Ingredients").update({
            x.toString(): _controllers[x].text
          });
        }

        Navigator.pop(context);
      },

      child: const Text("Save"),
    );
  }

  void _readdb(){
    _database.child("userData").child(_user.uid).child("ownRecipe").child(args["foodName"]).child("Ingredients").once().then((DataSnapshot dataSnapshot){
      _controllers.clear();
      _fields.clear();

      var data = dataSnapshot.value.toList();

      for(int x = 0; x < data.length; x++) {
        final controller = TextEditingController();
        final field = TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelText: data[x],
          ),
        );

        controller.text = data[x];

        _controllers.add(controller);
        _fields.add(field);
      }
      setState(() {
      });
    });
  }

  Map args = {};

  @override
  Widget build(BuildContext context) {

    args = ModalRoute.of(context)!.settings.arguments as Map;

    instructionsController.text = args["foodInstuctions"];

    return Scaffold(
      body: SafeArea( //Prevent the screen from occupying the notifications bar at the top
        child: SingleChildScrollView( // Allow the page to be scrollable
            child: Container(
              width: MediaQuery.of(context).size.width, //Set container size with screen size (width)
              height: MediaQuery.of(context).size.height, //Set container size with screen size (height)
              margin: const EdgeInsets.all(30),
              child: Column(
                children: [

                  const SizedBox( //Spacing vertically
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(args["foodName"],
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox( //Spacing vertically
                    height: 20,
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Instructions",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox( //Spacing vertically
                    height: 20,
                  ),

                  TextField( //Input for user email
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: instructionsController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Instructions',
                    ),
                  ),

                  const SizedBox( //Spacing vertically
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Ingredients",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  TextButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black,
                    ),
                    child: const Text('Refresh',
                      style: TextStyle(
                        fontSize: 12,
                      ),),
                    onPressed: (){
                      _readdb();
                    },
                  ),

                  _addTile(),

                  /*StreamBuilder(
                    stream: _database.child("userData").child(_user.uid).child("ownRecipe").child(args["foodName"]).child("Ingredients").onValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const Text("Something went wrong");
                        } else {
                          ingredientsData = (snapshot.data! as Event).snapshot.value;

                          _controllers.clear();
                          _fields.clear();

                          for(int x = 0; x < ingredientsData.length; x++){
                            final controller = TextEditingController();
                            final field = TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: ingredientsData[x],
                              ),
                            );

                            controller.text = ingredientsData[x];

                            _controllers.add(controller);
                            _fields.add(field);

                          }
                          return const SizedBox();

                        }
                      }

                  ),*/

                  Expanded(child: _listView()),
                  _okButton(),

                ],
              ),
            )
        ),
      ),
    );
  }
}
