import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homeScreenState();
}

class _homeScreenState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.red,
            child: Column(
              children: [
                Text("Hehe")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
