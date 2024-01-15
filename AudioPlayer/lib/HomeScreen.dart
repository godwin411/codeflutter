
import 'package:audioplayer/DemoScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: GestureDetector(
              child: Container(
                color: Colors.green,
                height: 50,
                width: 70,
                child: Center(child: Text ('Play',style: TextStyle(fontSize: 30))),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> DemoScreen()));
              },
            ),
          ),
        ),
      ),
    );
  }
}
