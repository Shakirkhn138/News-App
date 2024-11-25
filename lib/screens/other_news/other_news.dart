import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../detail_screen.dart';

class Article {
  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.source,
    required this.publishedAt,
  });
  final String title;
  final String description;
  final String urlToImage;
  final String source;
  final String publishedAt;

  String get formattedDate {
    try {
      DateTime date = DateTime.parse(publishedAt);
      return DateFormat('MM-DD-yyyy').format(date);
    } catch (e) {
      return publishedAt;
    }
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No titles available',
      description: json['description'] ?? 'No description available',
      urlToImage: json['urlToImage'] ?? '',
      source: json['source'] != null
          ? json['source']['name'] ?? 'No source available'
          : 'No source available',
      publishedAt: json['publishedAt'] ?? '',
    );
  }
}

class OtherNews extends StatefulWidget {
  const OtherNews({super.key});

  @override
  State<OtherNews> createState() => _OtherNewsState();
}

class _OtherNewsState extends State<OtherNews> {
  int? selectedButtonIndex = 0; // Default to 'General' news
  late Future<List<Article>> newsFuture;

  @override
  void initState() {
    super.initState();
    newsFuture = fetchNews('general'); // Default category
  }

  Future<List<Article>> fetchNews(String category) async {
    final apiKey = '48289674feef48bd8308c3cf656e44c3';
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$apiKey'));
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<Article> articles = [];
      for (Map<String, dynamic> i in data['articles']) {
        articles.add(Article.fromJson(i));
      }
      return articles;
    } else {
      throw Exception('Failed to fetch $category news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryButton(0, 'General', 'general'),
                _buildCategoryButton(1, 'Entertainment', 'entertainment'),
                _buildCategoryButton(2, 'Health', 'health'),
                _buildCategoryButton(3, 'Sports', 'sports'),
                _buildCategoryButton(4, 'Business', 'business'),
                _buildCategoryButton(5, 'Technology', 'technology'),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: newsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitFadingCircle(color: Colors.deepPurple),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('News not available'),
                  );
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
                                height: 100,
                                width: 60,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context , Widget child, ImageChunkEvent? loadingProgress){
                                  if ( loadingProgress == null ){
                                    return child;
                                  }
                                  else {
                                    return const Padding(
                                      padding: EdgeInsets.only(right: 250),
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
                              title: Text(article.title, maxLines: 1,),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
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

  Widget _buildCategoryButton(int index, String label, String category) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedButtonIndex = index;
            newsFuture = fetchNews(category); // Fetch news for the category
          });
        },
        child: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor:
          selectedButtonIndex == index ? Colors.blue : Colors.grey,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
