import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:news_app1/detail_screen.dart';
import 'package:news_app1/detail_screen.dart';

// Article model to parse JSON data
class Article {
  Article(
      {required this.title,
      required this.description,
      required this.urlToImage,
      required this.source,
      required this.publishedAt});

  final String title;
  final String description;
  final String urlToImage;
  final String source;
  final String publishedAt;

  String get formattedDate {
    try {
      DateTime date =
          DateTime.parse(publishedAt);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        title: json['title'] ?? 'no title',
        description: json['description'] ?? 'no description',
        urlToImage: json['urlToImage'] ?? '',
        source: json['source'] != null
            ? json['source']['name'] ?? 'no source available'
            : 'No source available',
        publishedAt: json['publishedAt'] ?? 'No date available');
  }
}

class BBCNewsScreen extends StatefulWidget {
  const BBCNewsScreen({super.key});

  @override
  State<BBCNewsScreen> createState() => _BBCNewsScreenState();
}

class _BBCNewsScreenState extends State<BBCNewsScreen> {
  // Fetch TechCrunch news
  Future<List<Article>> generalNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=48289674feef48bd8308c3cf656e44c3'));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<Article> articles = [];
      for (Map<String, dynamic> i in data['articles']) {
        articles.add(Article.fromJson(i));
      }
      return articles;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  // Fetch BBC news
  Future<List<Article>> fetchBBcNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=577e690eecc7494487f8d1ca921485c8'));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<Article> articles = [];
      for (Map<String, dynamic> i in data['articles']) {
        articles.add(Article.fromJson(i));
      }
      return articles;
    } else {
      throw Exception('Failed to fetch data');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Horizontal scrolling list for BBC News
          FutureBuilder<List<Article>>(
            future: fetchBBcNews(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SpinKitCircle(
                  color: Colors.deepPurple,
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No BBC articles available'),
                );
              } else {
                final articles = snapshot.data!;
                return GestureDetector(
                  onTap: (){
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 6),
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
                                // showModalBottomSheet(
                                //   context: context,
                                //   shape: const RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.only(
                                //           topRight: Radius.circular(50),
                                //           topLeft: Radius.circular(50))),
                                //   builder: (context) {
                                //     return Padding(
                                //       padding: const EdgeInsets.symmetric(
                                //           horizontal: 10),
                                //       child: Column(
                                //         children: [
                                //           Padding(
                                //             padding:
                                //             const EdgeInsets.only(top: 25),
                                //             child: Text(
                                //               article.title,
                                //               textAlign: TextAlign.center,
                                //               style: TextStyle(
                                //                   fontWeight: FontWeight.bold,
                                //                   fontSize: 18),
                                //             ),
                                //           ),
                                //           SizedBox(
                                //             height: 13,
                                //           ),
                                //           Row(
                                //             mainAxisAlignment:
                                //             MainAxisAlignment.spaceBetween,
                                //             children: [
                                //               Text(
                                //                 article.source,
                                //                 style: TextStyle(
                                //                     fontWeight: FontWeight.bold),
                                //               ),
                                //               Text(
                                //                 article.formattedDate,
                                //                 style: TextStyle(
                                //                     fontWeight: FontWeight.bold),
                                //               ),
                                //             ],
                                //           ),
                                //           SizedBox(
                                //             height: 14,
                                //           ),
                                //           Text(
                                //             article.description,
                                //             style: TextStyle(
                                //               fontSize: 15,
                                //             ),
                                //           )
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // );
                              },
                              child: Card(
                                margin: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 320,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(13),
                                    child: Stack(
                                      children: [
                                        article.urlToImage.isNotEmpty
                                            ? Image.network(
                                          article.urlToImage,
                                          width: 320,
                                          height: 370,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
                                            if ( loadingProgress == null ){
                                              return child;
                                            }
                                            else {
                                              return const SpinKitFadingCube(
                                                color: Colors.blue,
                                              );
                                            }
                                          },
                                        )
                                            : Container(
                                          height: 100,
                                          color: Colors.grey[300],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 30),
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 180, left: 15, right: 15),
                                              padding: const EdgeInsets.only(top: 15),
                                              height: 120,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(10)),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    article.title,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
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
                                                        Text(article.formattedDate
                                                            .toString())
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),

          // Vertical list for TechCrunch News
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
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No Crunch News articles available'));
                } else {
                  final articles = snapshot.data!;
                  return ListView.builder(
                    // shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
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
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                                    : null,
                                title: Text(
                                  article.title,
                                  maxLines: 1,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(article.source),
                                      Text(article.formattedDate)
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
