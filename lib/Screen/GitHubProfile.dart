
import 'dart:async';
import 'dart:convert';

import 'package:app_challenge/Screen/NavScreen.dart';
import 'package:app_challenge/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart';

class GitHubProfile extends StatefulWidget{
  final String gitUrl;
  GitHubProfile({Key key, @required this.gitUrl}) : super(key: key);
  @override
  GitHubProfileState createState() => GitHubProfileState();
}

class GitHubProfileState extends State<GitHubProfile> {
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

    });

    super.initState();
  }
  @override
  Widget build(BuildContext context){
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('My Github'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async{
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
          url: widget.gitUrl,
          clearCache: true,
          clearCookies: true,
        ),
      ),
    );
  }
}