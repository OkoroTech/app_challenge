
import 'dart:async';
import 'dart:convert';

import 'package:app_challenge/Screen/NavScreen.dart';
import 'package:app_challenge/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart';

class GitHubLogin extends StatefulWidget{
  @override
  GitHubLoginState createState() => GitHubLoginState();
}

class GitHubLoginState extends State<GitHubLogin> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription _onDestroyed;

  @override
  void initState() {
    // TODO: implement initState
    flutterWebViewPlugin.close();

    _onDestroyed = flutterWebViewPlugin.onDestroy.listen((_) {
      print('destroy');
    });

    _onStateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      print("onStateChanged: ${state.type} ${state.url} ");
    });

    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      print(url);
      //Listens for access token in url and gets user info to show to login
      if (mounted) {
        setState(() {
          print("URL changed: $url");
          if (url.contains('access_token')) {
            const start = 'access_token=';
            const end = '&';
            final startIndex = url.indexOf(start);
            final endIndex = url.indexOf('&', startIndex + start.length);
            final String token = url.substring(startIndex + start.length, endIndex);
            void func() async{
              final Response response =  await get(
                'https://dev-wpk2f04t.us.auth0.com/userinfo',
                headers: <String, String>{'Authorization': 'Bearer $token'},
              );
              Map test = jsonDecode(response.body);
              String nickname = test['nickname'];
              print(test);
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  UserApp(nickname: nickname,)), (Route<dynamic> route) => false);
              }
              func();

              print(url.substring(startIndex + start.length, endIndex));
            }
          });
        }
            });

        super.initState();
      }
        @override
        Widget build(BuildContext context){
    // auth0 authentication url
      String url = 'https://dev-wpk2f04t.us.auth0.com/authorize?response_type=token&client_id=$AUTH0_CLIENT_ID&connection=github&redirect_uri=$AUTH0_REDIRECT_URI&access_type=offline&scope=openid%20profile&grant_type=refresh_token';

      // TODO: implement build
      return Scaffold(
        appBar: AppBar(
          title: Text('GitHub Login'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () async{
              flutterWebViewPlugin.clearCache();
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          child: WebviewScaffold(
            initialChild: Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            url: url,
            clearCache: true,
            clearCookies: true,
          ),
        ),
      );
    }
  }