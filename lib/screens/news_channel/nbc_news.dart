import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../detail_screen.dart';

class Article {
  
  Article({required this.title, required this.description, required this.urlToImage, required this.source, required this.publishedAt});
  
  final String title;
  final String description;
  final String urlToImage;
  final String source;
  final String publishedAt;
  
  String get formattedDate {
    try{
      DateTime date = DateTime.parse(publishedAt);

      return DateFormat('MM-DD-yyyy').format(date);
    } catch (e){
      return publishedAt;
    }
  }
  
  factory Article.fromJson(Map<String, dynamic> json){
    return Article(title: json['title'] ?? 'No title available', description: json['description'] ?? 'No description available', urlToImage: json['urlToImage'] ?? '', source: json['source'] != null ? json['source']['name'] ?? 'No source available' : 'No source available', publishedAt: json['publishedAt'] ?? '',);
  }
}

class NbcNews extends StatefulWidget {
  const NbcNews({super.key});

  @override
  State<NbcNews> createState() => _NbcNewsState();
}

class _NbcNewsState extends State<NbcNews> {
  
  Future<List<Article>> nbcNews () async {
    final response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?sources=nbc-news&apiKey=577e690eecc7494487f8d1ca921485c8'));
    final data = jsonDecode(response.body);
    if ( response.statusCode == 200) {
      List<Article> articles = [];
      for (Map<String, dynamic> i in data['articles']) {
        articles.add(Article.fromJson(i));
      }
      return articles;
    }
    else{
      throw Exception('Failed to fetch NBC news');
    }
  }

  Future<List<Article>> generalNews () async {
    final response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=48289674feef48bd8308c3cf656e44c3'));
    final data = jsonDecode(response.body);
    if ( response.statusCode == 200){
      List<Article> articles = [];
      for (Map<String, dynamic> i in data['articles']){
        articles.add(Article.fromJson(i));
      }
      return articles;
    }
    else {
      throw Exception('Failed to fetch general news');
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
              future: nbcNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitCircle(
                    color: Colors.deepPurple,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Al-Jazeera news is not available');
                } else {
                  final articles = snapshot.data!;
                  return Container(
                    padding: EdgeInsets.only(left: 10, right: 6),
                    height: 370,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: articles.length,
                        itemBuilder: (ctx, index) {
                          final article = articles[index];
                          return GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                builder:  (context) => DetailScreen(
                                  title: article.title,
                                  description: article.description,
                                  urlImage: article.urlToImage,
                                  source: article.source,
                                  publishedDate: article.formattedDate,
                                ),
                              ));
                            },
                            child: Card(
                              margin: EdgeInsets.all(8),
                              child: Container(
                                height: 320,
                                // width: 330,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Stack(
                                    children: [
                                      article.urlToImage.isNotEmpty
                                          ? Image.network(
                                        article.urlToImage,
                                        height: 355,
                                        width: 330,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context , Widget child, ImageChunkEvent? loadingProgress){
                                          if ( loadingProgress == null ){
                                            return child;
                                          }
                                          else {
                                            return const Padding(
                                              padding: EdgeInsets.only(left: 145),
                                              child: SpinKitFadingCube(color: Colors.blue,),
                                            );
                                          }
                                        },
                                      )
                                          : Container(
                                        height: 200,
                                        color: Colors.grey,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 220),
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          padding: const EdgeInsets.only(top: 15),
                                          height: 120,
                                          width: 310,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                article.title,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(article.source),
                                                    Text(article.formattedDate)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }
              }),
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: generalNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const SpinKitCircle(
                      color: Colors.deepPurple,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No data available');
                } else {
                  final articles = snapshot.data!;
                  return ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (ctx, index) {
                        final article = articles[index];
                        return GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                              builder:  (context) => DetailScreen(
                                title: article.title,
                                description: article.description,
                                urlImage: article.urlToImage,
                                source: article.source,
                                publishedDate: article.formattedDate,
                              ),
                            ));
                          },
                          child: Container(
                            height: 100,
                            child: Card(
                              child: ListTile(
                                leading: article.urlToImage.isNotEmpty
                                    ? Image.network(
                                  article.urlToImage,
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context , Widget child, ImageChunkEvent? loadingProgress){
                                    if ( loadingProgress == null ){
                                      return child;
                                    }
                                    else {
                                      return const Padding(
                                        padding: EdgeInsets.only(left: 145),
                                        child: SpinKitFadingCube(color: Colors.blue,),
                                      );
                                    }
                                  },
                                )
                                    : Container(
                                  color: Colors.grey,
                                  height: 60,
                                  width: 60,
                                ),
                                title: Text(
                                  article.title,
                                  maxLines: 1,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(child: Text(article.source)),
                                      Text(article.formattedDate)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },);
                }
              },),
          ),
        ],
      ),
    );
  }
}
