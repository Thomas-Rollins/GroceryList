import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocery_list/app_localizations.dart';
import 'package:grocery_list/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                    child: Text(
                      AppLocalizations.of(context).translate("splashTitle"),
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.headline1!.fontSize,
                      ),
                    )),
                const FlutterLogo(
                  size: 128,
                ),
              ],
            )));
  }

  startTimer() {
    var duration = const Duration(milliseconds: 3000);
    return Timer(duration, redirect);
  }

  redirect() async {
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }
}