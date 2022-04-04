import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class addRecipe extends StatefulWidget {
  const addRecipe({Key? key}) : super(key: key);

  @override
  State<addRecipe> createState() => _addRecipeState();
}

class _addRecipeState extends State<addRecipe> {

  final _user = FirebaseAuth.instance.currentUser!;
  final _database = FirebaseDatabase.instance.reference(); // Firebase database instance

  //Controllers for Text Fields
  TextEditingController foodNameController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  List<TextEditingController> _controllers = [];
  List<TextField> _fields = [];

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

        _database.child("userData").child(_user.uid).child("ownRecipe").child(foodNameController.text).set({
          "Instructions": instructionsController.text
        });

        for(int x = 0; x < _controllers.length; x++){
          _database.child("userData").child(_user.uid).child("ownRecipe").child(foodNameController.text).child("Ingredients").update({
            x.toString(): _controllers[x].text
          });
        }

        Navigator.pop(context);
      },

      child: const Text("Add"),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  children: const [
                    Text("Add a Recipe",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),

                const SizedBox( //Spacing vertically
                  height: 40,
                ),

                TextField( //Input for user email
                  controller: foodNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Name of Food',
                  ),
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
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),

                _addTile(),
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
