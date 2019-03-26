import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import "flare_progress_indicator.dart";

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading;
  @override
  void initState() {
    // Start loading...
    _isLoading = true;

    // This would be based off of some async action, for now just complete
    // loading after some random time between 1 and 3 seconds.
	// We use a random time to show that the animation will wait for the loop
	// to complete properly.
    Timer(Duration(milliseconds: 1000+Random().nextInt(2000)), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
          child: Container(
              width: 200,
              height: 200,
              child:
                  FlareProgressIndicator(_isLoading, indicatedCompletion: () {
                Navigator.of(context).pushNamed('/home');
              }))),
    );
  }
}
//Navigator.of(context).pushNamed('/settings');
