import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'movie_list_model.dart';

class MovieList extends StatelessWidget {

  final List<MovieViewModel> movies;
  MovieList({required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.movies.length,
      itemBuilder: (context, index) {
        final movie = this.movies[index];
        return Container(
          padding: EdgeInsets.all(7),
            height: 190,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(movie.poster),
                    ),
                    borderRadius: BorderRadius.circular(6)
                  ),
                  width: 150,
                ),
                Container(
                  width: 170,
                  height: 240,
                  child: Center(
                    child: Padding(padding: EdgeInsets.all(6),
                        child: FutureBuilder<MovieDetail>(
                            future: fetchMoviedata(movie.imdbID),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                 return Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Text(snapshot.data!.title.toString(),style: TextStyle(fontSize: 18, color: Color.fromRGBO(72, 75, 77, 1)),),
                                     SizedBox(height: 5,),
                                     Text(formatgenre(snapshot.data!.genre.toString()),style: TextStyle(fontSize: 14, color: Colors.black26),),
                                     SizedBox(height: 5,),
                                     SizedBox(
                                       width: 80,
                                       height: 30,
                                       child: Card(
                                           shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(15),
                                           ),
                                           color: ratecolor(snapshot.data!.imdbRating) ? Colors.green : Colors.blue,
                                           child: Center(
                                             child: Text(snapshot.data!.imdbRating + " IMDB",style: TextStyle(color: Colors.white),),
                                           )
                                         ),
                                       )
                                     ],
                                   );
                               } else if (snapshot.hasError) {
                                 return Text("${snapshot.error}");
                               }
                               return CircularProgressIndicator();
                             }
                             )
                    )
                  ),
                )
              ],
            )
        );
        },
    );
  }

   Future<MovieDetail> fetchMoviedata(String imdbID) async {
    final url = "http://www.omdbapi.com/?i=$imdbID&apikey=62aa0fc6";
    final response = await http.get(url);
    if(response.statusCode == 200) {
      return MovieDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  String formatgenre(String genre) {
    List<String> s1 = genre.split(",");
    String newgenre = "";
    for(var x in s1)
    {
      newgenre = newgenre+x.trim()+" | ";
    }
    newgenre = newgenre.trim();
    return newgenre.substring(0,newgenre.length-1);
  }

  bool ratecolor(String imdbRating) {
    var rate = double.parse(imdbRating);
    if(rate is double && rate > 7.0)
      {return true;}
    return false;
  }
}

class MovieDetail {
  final String genre;
  final String title;
  final String imdbRating;

  MovieDetail({required this.genre, required this.title, required this.imdbRating});

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      genre: json['Genre'],
      title: json['Title'],
        imdbRating: json['imdbRating']
    );
  }
}
