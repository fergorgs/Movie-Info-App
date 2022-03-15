import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class MovieCard extends StatelessWidget {
  
  final int id;
  final String title;
  final String poster_url;
  final String placeholder_url = 'https://d32qys9a6wm9no.cloudfront.net/images/movies/poster/500x735.png';
  final double vote_average;
  final String production_year;
  final List genres;

  const MovieCard({
    Key? key,
    this.id = -1,
    this.title = '',
    this.poster_url = '',
    this.vote_average = 0,
    this.production_year = '',
    this.genres = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { Navigator.pushNamed(context, '/details', arguments: {'id': id});},
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        color: Colors.grey[850],
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    // flex: 1,
                    child: AspectRatio(
                      aspectRatio: 0.8,
                      child: Image.network(poster_url,
                        errorBuilder: (context, exception, stackTrace) {
                            return Image(image: NetworkImage(placeholder_url));
                        },
                      )
                    ),
                  ),
                  Expanded(
                    // flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Rating:   ' + vote_average.toString() + ' ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[300]
                              )
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow[700],
                              size: 20,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Production year: ' + production_year,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[300]
                          )
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Genres:',
                          style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[300]
                              )
                        ),
                        SizedBox(height: 5),
                        Text(
                          genres.map((genre) {
                            return genre;
                          }).toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[300],
                          )
                        ),
                      ]
                    ),
                  )
                ],
              ),
              SizedBox(height: 30),
              Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300]
                )
              ),
            ]
          ),
        )
      ),
    );
  }
}