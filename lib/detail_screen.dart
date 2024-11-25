import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app1/models/article.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String urlImage;
  final String source;
  final String publishedDate;

  const DetailScreen(
      {super.key,
      required this.title,
      required this.description,
      required this.urlImage,
      required this.source,
      required this.publishedDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
        body: Stack(
      children: [
        const SizedBox(height: 30,),
        urlImage.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50)),
              child: Image.network(
                  urlImage,
                  width: double.infinity,
                  height: 350,
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
                ),
            )
            : ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50)),
              child: Container(
                child: Center(
                  child: Text('No image available', style: TextStyle(fontSize: 20),),
                ),
                  color: Colors.grey[300],
                  height: 350,
                  width: double.infinity,
                ),
            ),

        Padding(
          padding: const EdgeInsets.only(top: 310),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 23),
              child: Column(
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(source, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                      Text(publishedDate, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text(description, style: TextStyle(fontWeight: FontWeight.w500),)
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
