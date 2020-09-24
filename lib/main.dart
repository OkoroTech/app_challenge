import 'package:app_challenge/Screen/HelloWorld.dart';
import 'package:app_challenge/Screen/NavScreen.dart';
import 'package:app_challenge/Screen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:shared_preferences/shared_preferences.dart';


final FlutterAppAuth appAuth = FlutterAppAuth();


/// -----------------------------------
///           Auth0 Variables
/// -----------------------------------

const AUTH0_DOMAIN = 'dev-wpk2f04t.us.auth0.com';
const AUTH0_CLIENT_ID = '36rjh3CDN8Wrql2Fq5cXmcwZd0IXqoUY';

const AUTH_WEB_REDIRECT_URI = 'http://localhost:57700/callback';

const AUTH0_REDIRECT_URI = 'com.app.appchallenge://login-callback';
const AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState () => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  // This widget is the root of your application.
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;
  String nickName;

  Map<String, Object> parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }
  Future<void> logoutAction() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('key', 'null');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  void initAction() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final storageRefreshToken = '${prefs.getString('key')}';
    print('or $storageRefreshToken');
    if (storageRefreshToken == 'nul') return;
    setState(() {
      isBusy = true;
    });

    try {
      final response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: 'https://$AUTH0_ISSUER',
        refreshToken: storageRefreshToken,
      ));


      final Map<String, Object> idToken = parseIdToken(response.idToken);

      prefs.setString('key', '${response.refreshToken}');

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        nickName = idToken['nickname'] ;
      });
    } on Exception catch (e, s) {
      debugPrint('error on refresh token');
      await logoutAction();



    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAction();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: '',
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:Scaffold(
        body: isBusy ? SplashScreenPage()
            : isLoggedIn
            ? UserApp(nickname: nickName,) : HelloWorld()
      )
    );
  }
}

