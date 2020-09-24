import 'package:app_challenge/Screen/GitHubProfile.dart';
import 'package:app_challenge/Screen/HelloWorld.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget{
  final String nickname;
  HomeScreen({Key key, @required this.nickname}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  final LocalStorage storage = new LocalStorage('app');
  AnimationController _controller;
  Animation<double> _animation;
  double long = 0.000;
  double lat = 0.000;

  void deleteStorageKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('key', 'null');
  }
  void printStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    print("key: " + prefs.getString("key"));
  }

  @override
  void initState() {
    // TODO: implement initState
    printStorage();


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topLeft,
                child: Text('Hola!,', style: TextStyle(color: Colors.grey, fontSize: 20))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Text('${widget.nickname}', style: TextStyle(color: Colors.black,fontSize: 30, fontWeight: FontWeight.w600),)
                ),
                FlatButton(
                  onPressed: () async{
                    deleteStorageKey();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        HelloWorld()), (Route<dynamic> route) => false);
                  },
                  child: Text('signout', style: TextStyle(color: Colors.blueAccent),
                    textAlign: TextAlign.center,
                  ),
                ),

              ],
            ),
            SizedBox(height: 30,),
            SizedBox(
                height: 200,
                child: Image.asset('assets/profile.png', )),
            FlatButton(
              child: Text('github.com/${widget.nickname}', style: TextStyle(color: Colors.blueAccent),
              textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                    GitHubProfile(
                      gitUrl: 'https://github.com/${widget.nickname}',
                    )));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${lat.toStringAsFixed(3)}',style: TextStyle(color: Colors.black, fontSize: 40),),
                    Text('LATITUDE',style: TextStyle(color: Colors.grey),),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  color: Colors.black,
                  width: .5,
                  height: 100,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${long.toStringAsFixed(3)}',style: TextStyle(color: Colors.black, fontSize: 40),),
                    Text('LONGITUDE',style: TextStyle(color: Colors.grey),),
                  ],
                )
              ],
            ),
            SizedBox(height: 30,),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.redAccent,
                onPressed: () async{
                 Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                  print(position);
                  setState(() {
                    lat = position.latitude;
                    long = position.longitude;
                  });

                },
                child: Text(
                  'Get Location', style: TextStyle(color:Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}