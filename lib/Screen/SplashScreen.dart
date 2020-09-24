import 'dart:async';
import 'package:app_challenge/Screen/HelloWorld.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:app_challenge/main.dart';


class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenState createState() =>  _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new
    SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new HelloWorld(),
        title: new Text('Welcome',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0, color: Colors.white
          ),),
        image: new Image.asset('assets/image1.png'),
        backgroundColor: Colors.black,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 150.0,
        onClick: ()=>print("Flutter Egypt"),
        loaderColor: Colors.white
    );

  }


}