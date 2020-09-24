import 'dart:async';
import 'dart:io';
import 'package:app_challenge/Screen/Home.dart';
import 'package:app_challenge/Screen/Weather.dart';
import 'package:flutter/material.dart';
import 'dart:developer';



class UserApp extends StatefulWidget {
  UserApp({Key key, this.nickname}) : super(key: key);
  final String nickname;
  @override
  UserAppState createState() => UserAppState();
}
class UserAppState extends State<UserApp> {
  final GlobalKey<ScaffoldState> _scaffoldKEY = new GlobalKey<ScaffoldState>();
  int selectedbottomnav = 0;
  String nick;
  var pageoptions;
  @override
  void initState() {
    // TODO: implement initState
    nick = widget.nickname;
    pageoptions = [
      HomeScreen(nickname: nick,),
      WeatherScreen(),
    ];
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKEY,
        body: pageoptions[selectedbottomnav],

        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.redAccent,
          type : BottomNavigationBarType.fixed,
          currentIndex: selectedbottomnav,
          onTap: (int index) {
            setState(() {
              selectedbottomnav = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.wb_sunny),
              title: new Text('Weather'),
            ),
          ],
        ),
      ),
    );
  }
}



