import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_challenge/Screen/GitHubLoginAndroid.dart';
import 'package:app_challenge/Screen/GitHubProfile.dart';
import 'package:app_challenge/Screen/Home.dart';
import 'package:app_challenge/Screen/NavScreen.dart';
import 'package:app_challenge/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HelloWorld extends StatefulWidget{


  @override
  _HelloWorldState createState() => _HelloWorldState();
}

class _HelloWorldState extends State<HelloWorld> {
String key;
  Future<Null> savekey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('key', key);
    print(prefs.get('key'));
  }
void printStorage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  print("key: " + prefs.getString("key"));
}
login () async{
  Response response = await get('https://dev-wpk2f04t.us.auth0.com/authorize?client_id=36rjh3CDN8Wrql2Fq5cXmcwZd0IXqoUY&response_type=code&connection=github&prompt=login&scope=openid%20profile&redirect_uri=https://manage.auth0.com/tester/callback?connection=github');
  print(jsonDecode(response.body));
}

Map<String, Object> parseIdToken(String idToken) {
  final List<String> parts = idToken.split('.');
  assert(parts.length == 3);

  return jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
}
@override
void initState() {
    // TODO: implement initState
  print(AUTH0_DOMAIN);
  login();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .20),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 250,
                  child: Image.asset('assets/image1.png', )),
              Text('Hello World', style: TextStyle(fontSize: 35),),
              SizedBox(height: 30,),
              RaisedButton(
                padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FontAwesomeIcons.github ,color: Colors.white,),
                    SizedBox(width: 10,),
                    Text('Login with GitHub', style: TextStyle(color: Colors.white, fontSize: 20),)
                  ],
                ),
              color: Colors.redAccent,
                onPressed: () async{
                  String ur1 = 'https://dev-wpk2rf04t.us.auth0.com/authorize?response_type=token&client_id=$AUTH0_CLIENT_ID&connection=github&redirect_uri=false&access_type=offline&scope=openid%20profile';
                  if(Platform.isAndroid){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        GitHubLogin()));
                  }
                  else{
                    final AuthorizationTokenResponse result =
                    await appAuth.authorizeAndExchangeCode(
                      AuthorizationTokenRequest(
                        AUTH0_CLIENT_ID,
                        AUTH0_REDIRECT_URI,
                        issuer: 'https://$AUTH0_DOMAIN',
                        scopes: <String>['openid', 'profile', 'offline_access'],
                        // promptValues: ['login']
                      ),
                    );
                     print('result ${result.idToken}');
                    key = result.refreshToken;
                    savekey();

                    final Map<String, Object> idToken = parseIdToken(result.idToken);

                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        UserApp(nickname: idToken['nickname'],)), (Route<dynamic> route) => false);



                  }

                },
              ),

            ],
          )
        ),
      ),

    );

  }
}