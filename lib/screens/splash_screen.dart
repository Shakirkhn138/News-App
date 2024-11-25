import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app1/screens/news_channel/bbc_news.dart';
import 'package:news_app1/screens/news_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer( const Duration(seconds: 6), (){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewsScreen()));
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Top Headlines', style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
            const SpinKitChasingDots(
              color: Colors.deepPurple,
              duration: Duration(seconds: 5),

            )
          ],
        ),
      ),
    );
  }
}
