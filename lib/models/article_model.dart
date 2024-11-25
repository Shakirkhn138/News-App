import 'package:intl/intl.dart';

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