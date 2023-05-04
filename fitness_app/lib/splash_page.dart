import 'dart:async';

import 'package:fitness_app/main.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPage();

}

class _SplashPage extends State<SplashPage>{
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), (() => Navigator.pushReplacement(context,
     MaterialPageRoute(builder: ((context) => MyHomePage())))));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: CircularProgressIndicator()
    )
  );
}