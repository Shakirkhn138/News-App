import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app1/screens/news_channel/al_jazeera_news.dart';
import 'package:news_app1/screens/news_channel/bbc_news.dart';
import 'package:news_app1/screens/news_channel/cnn_news.dart';
import 'package:news_app1/screens/news_channel/espn_news.dart';
import 'package:news_app1/screens/news_channel/nbc_news.dart';
import 'package:news_app1/screens/other_news/other_news.dart';
import 'package:news_app1/screens/splash_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Widget currentScreen = const BBCNewsScreen();
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('News', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: IconButton(icon: Icon(CupertinoIcons.circle_grid_3x3_fill),onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtherNews()));
        },),
        actions: [

          PopupMenuButton(
              onSelected: (value){

               setState(() {
                 if ( value == 'bbc'){
                   currentScreen = const BBCNewsScreen();
                 }
                 else if ( value == 'jazeera'){
                   currentScreen = const AlJazeeraNews();
                 }
                 else if ( value == 'espn') {
                   currentScreen = const EspnNews();
                 }
                 else if ( value == 'cnn') {
                   currentScreen =  const CnnNews();
                 }
                 else if ( value == 'nbc') {
                   currentScreen = const NbcNews();
                 }
               });
              },
              itemBuilder: (context){
            return [
              const PopupMenuItem(value: 'bbc',child: Text('BBC News'),),
              const PopupMenuItem(value: 'jazeera',child: Text('Al Jazeera news')),
              const PopupMenuItem(value: 'espn',child: Text('ESPN news')),
              const PopupMenuItem(value: 'cnn',child: Text('CNN News')),
              const PopupMenuItem(value: 'nbc',child: Text('NBC News'))
            ];
          })


        ],
      ),
      body: currentScreen
    );
  }
}
