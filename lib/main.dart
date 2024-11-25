import 'package:flutter/material.dart';
import 'package:news_app1/screens/news_channel/bbc_news.dart';
import 'package:news_app1/screens/news_screen.dart';
import 'package:news_app1/screens/splash_screen.dart';

void main(){
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
